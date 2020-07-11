//
//  MetroData.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI
import Combine
import ClockKit


enum FetchState {
  case fetching, success, failed
}

class MetroData: NSObject, ObservableObject, URLSessionDownloadDelegate {

  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    if location.isFileURL {
      do {
        let jsonData = try Data(contentsOf: location)
        let dd = try JSONDecoder().decode(DepartureDetails.self, from: jsonData)
        departureDetails[dd.stop.stopID] = dd.services
      } catch let error as NSError {
        print("Could not read data from \(location), error:\(error).")
      }
    }
  }

  var completionHandler : ((_ update: Bool) -> Void)?

  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    print("session didCompleteWithError \(error.debugDescription)")
    DispatchQueue.main.async {
      self.completionHandler?(error == nil)
      self.completionHandler = nil
    }
  }


  static let shared = MetroData()

  private lazy var backgroundURLSession: URLSession = {
    let config = URLSessionConfiguration.background(withIdentifier: "BackgroundMetro")
    config.isDiscretionary = false
    config.sessionSendsLaunchEvents = true

    return URLSession(configuration: config, delegate: self, delegateQueue: nil)
  }()

  var backgroundTask: URLSessionDownloadTask? = nil
  func schedule(_ first: Bool) {
    if backgroundTask == nil {
      let bgTask = backgroundURLSession.downloadTask(with: URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/3546")!)
      bgTask.earliestBeginDate = Date().addingTimeInterval(first ? 60 : 15*60)
      bgTask.countOfBytesClientExpectsToSend = 200
      bgTask.countOfBytesClientExpectsToReceive = 2048

      bgTask.resume()

      backgroundTask = bgTask
    }
  }

  func refresh(_ completionHandler: @escaping (_ update: Bool) -> Void) {
    self.completionHandler = completionHandler
  }

  // Because this is @Published property,
  // Combine notifies any observers when a change occurs.
  @Published public var departureDetails: Dictionary<String, [BusTrainService]> = [:]
  @Published public var services: [BusTrainService] = []
  @Published public var fetchState: FetchState = FetchState.fetching
  @Published public var request: AnyCancellable?

  @Published public var stopName: String = ""

  @Published public var stops: [BusTrainStop] = [] {
    didSet {
      saveUserStops()
    }
  }

// 3546, name: "Newlands Road"
// 5016, name: "Wellington Stn"
// 5014, name: "Lambton Quay"
// 5012, name: "Farmers"
// 5010, name: "Cable Car Ln"
// 5008, name: "Willis St"


  @Published public var favoriteRoutes: [Route] = [] {
    didSet {
      saveUserRoutes()
    }
  }

  // User Preferences Data
  let stopsFile: URL = FileManager.documentDirectory
    .appendingPathComponent("Stops")
    .appendingPathExtension("txt")
  let routesFile: URL = FileManager.documentDirectory
    .appendingPathComponent("Routes")
    .appendingPathExtension("txt")

  private var displayAllStops = false

  func deleteStop(at indices: IndexSet) {
    indices.forEach { stops.remove(at: $0) }
  }

  func deleteService(at indices: IndexSet) {
    indices.forEach { favoriteRoutes.remove(at: $0) }
  }
  // MARK: - Private Methods

  // The model's initializer. Do not call this method.
  // Use the shared instance instead.
  private override init() {
    super.init()

    // Load user routes and stops
    loadUserStops()
    loadUserRoutes()

    // Begin loading the data from disk.
    fetchAllData()

    // Add a subscriber to currentDrinks that responds whenever currentDrinks changes.
    updateSink = $departureDetails.sink { /*[unowned self]*/ _ in

      // Update any complications on active watch faces.
      let server = CLKComplicationServer.sharedInstance()
      for complication in server.activeComplications ?? [] {
        server.reloadTimeline(for: complication)
      }

    }
  }

  public func loadUserStops() {
    let decoder = JSONDecoder()

    do {
      let data = try Data(contentsOf: stopsFile)
      stops = try decoder.decode([BusTrainStop].self, from: data)
    } catch let error {
      print(error)
    }
  }

  public func loadUserRoutes() {
    let decoder = JSONDecoder()

    do {
      let data = try Data(contentsOf: routesFile)
      favoriteRoutes = try decoder.decode([Route].self, from: data)
    } catch let error {
      print(error)
    }
  }

  public func saveUserStops() {
    let encoder = JSONEncoder()

    do {
      let data = try encoder.encode(stops)
      try data.write(to: stopsFile, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }

  public func saveUserRoutes() {
    let encoder = JSONEncoder()

    do {
      let data = try encoder.encode(favoriteRoutes)
      try data.write(to: routesFile, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }

  public func firstServiceDate(fromDate: Date, stopID: String) -> Date? {
    if let departures = departureDetails[stopID] {
      for service in filterBy(serviceIDs: favoriteRoutes, services: departures) {
        if let serviceDate = service.aimedArrival.converStringToDate() {
          if serviceDate > fromDate {  
            print("serviceDate: \(serviceDate), fromDate: \(fromDate)")
            return serviceDate
          }
        }
      }
    }
    return nil
  }

  // A sink that is also called whenever the currentDrinks array changes.
  var updateSink: AnyCancellable!

  var cancellables: Set<AnyCancellable> = []

  func fetchAllData() {
    let publisher1 = stopDataPublisher(for: "3546")
    let publisher2 = stopDataPublisher(for: "5016")
    Publishers.Zip(publisher1, publisher2)
      .receive(on: DispatchQueue.main)
      //.sink(receiveValue: parse)
      .sink(receiveCompletion: { completion in
        print(completion)
      }, receiveValue: { departure1, departure2 in
        self.parse(result: departure1)
        self.parse(result: departure2)
      })
      .store(in: &cancellables)
  }

  func fetchData(for stop: String, displayAllStops: Bool = false) {
    self.displayAllStops = displayAllStops
    if let url = URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/" + stop) {
      print("Stop: \(stop)")
      fetchState = .fetching
      request = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: DepartureDetails.self, decoder: JSONDecoder())
        .replaceError(with: DepartureDetails())
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: parse)
    }
  }

  func fetchStopName(for stop: String) {
    if let url = URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/" + stop) {
      print("Stop: \(stop)")
      fetchState = .fetching
      request = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: DepartureDetails.self, decoder: JSONDecoder())
        .replaceError(with: DepartureDetails())
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: parseStopName)
    }
  }

    // https://www.metlink.org.nz/api/v1/StopNearby/-41.3431194/174.7706202

    func stopDataPublisher(for stop: String) -> AnyPublisher<DepartureDetails, Never> {
      let url = URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/" + stop)!
      return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: DepartureDetails.self, decoder: JSONDecoder())
        .replaceError(with: DepartureDetails())
        .eraseToAnyPublisher()
    }

    func parse(result: DepartureDetails) {
      if result.services.count == 0 {
        // fetch error!
        fetchState = .failed
      } else {
        // fetch succeeded!
        fetchState = .success

        if displayAllStops {
          services = result.services
        } else {
          services = filterBy(serviceIDs: favoriteRoutes, services: result.services)
        }
        departureDetails[result.stop.stopID] = result.services
        print(" Stop: \(result.stop.stopID) \(stopName) count: \(result.services.count)")
      }
    }

    func parseStopName(result: DepartureDetails) {
      if result.services.count == 0 {
        // fetch error!
        fetchState = .failed
        stopName = ""
      } else {
        // fetch succeeded!
        fetchState = .success
        stopName = Abbreviator.abbrv(result.stop.name) 
        print(" Stop: \(result.stop.stopID) \(result.stop.name) (\(stopName))")
      }
    }

    private func filterBy(serviceIDs: [Route], services: [BusTrainService]) -> [BusTrainService] {
      let filteredServices = services.filter {
        for serviceID in serviceIDs {
          if $0.serviceID == serviceID.routeShortName {
            return true
          }
        }
        return false
      }
      return filteredServices
    }

    // The deinitializer for the model object.
    deinit {
      // Cancel the observer.
      updateSink.cancel()
    }
  }





