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
  case fetching
  case success
  case failed
}

// 3546, name: "Newlands Road"
// 5016, name: "Wellington Stn"
// 5014, name: "Lambton Quay"
// 5012, name: "Farmers"
// 5010, name: "Cable Car Ln"
// 5008, name: "Willis St"

class MetroData: NSObject, ObservableObject, URLSessionDownloadDelegate {

  public static let shared = MetroData()

  @Published public var request: AnyCancellable?
  @Published public var departureDetails: Dictionary<String, [BusTrainService]> = [:]
  @Published public var services: [BusTrainService] = []
  @Published public var fetchState: FetchState = FetchState.fetching
  @Published public var stop: BusTrainStop = BusTrainStop(stopID: "", name: "", latitude: 0.0, longitude: 0.0)
  @Published public var favouriteStops: [BusTrainStop] = [BusTrainStop(stopID: "3546", name: "Newlands Road at SalFord Street", latitude: -41.2290642, longitude: 174.8183648)] {
    didSet {
      saveUserStops()
    }
  }

  @Published public var favoriteRoutes: [Route] = [Route(routeId: 520, agencyId: "MNM", routeShortName: "52", routeLongName: "Johnsonville - Newlands - Wellington", routeType:   3, routeColor: "6cace4", routeTextColor: "000000")] {
    didSet {
      saveUserRoutes()
    }
  }

  @Published public var nearbyStops: [BusTrainStop] = []

  public func firstServiceDate(fromDate: Date, stopID: String) -> Date? {
    if let departures = departureDetails[stopID] {
      for service in filterBy(serviceIDs: favoriteRoutes, services: departures) {
        if let serviceDate = service.departureTime.converStringToDate() {
          if serviceDate > fromDate {
            print("serviceDate: \(serviceDate), fromDate: \(fromDate)")
            return serviceDate
          }
        }
      }
    }
    return nil
  }

  public func fetchAllData() {
    let publisher1 = stopDataPublisher(for: "3546")
    let publisher2 = stopDataPublisher(for: "5016")
    Publishers.Zip(publisher1, publisher2)
      .receive(on: DispatchQueue.main)
      //.sink(receiveValue: parse)
      .sink(receiveCompletion: { completion in
        print(completion)
      }, receiveValue: { departure1, departure2 in
        self.parseDepartures(result: departure1)
        self.parseDepartures(result: departure2)
      })
      .store(in: &cancellables)
  }

  public func fetchDepartureData(for stop: String, displayAllStops: Bool = false) {
    self.displayAllStops = displayAllStops
    if let url = URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/" + stop) {
      print("Stop: \(stop)")
      fetchState = .fetching
      request = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: DepartureDetails.self, decoder: JSONDecoder())
        .replaceError(with: DepartureDetails())
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: parseDepartures)
    }
  }

  public func fetchStop(for stop: String) {
    if let url = URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/" + stop) {
      print("Stop: \(stop)")
      fetchState = .fetching
      request = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: DepartureDetails.self, decoder: JSONDecoder())
        .replaceError(with: DepartureDetails())
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: parseStop)
    }
  }

  public func fetchNearbyStops(for location: (Double, Double)) {
    // https://www.metlink.org.nz/api/v1/StopNearby/-41.23335086,+174.81820100 //-41.3431194/174.7706202
    if let url = URL(string: "https://www.metlink.org.nz/api/v1/StopNearby/\(location.0)/\(location.1)") {
      print("Location: \(location.0)/\(location.1)")
      fetchState = .fetching
      request = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: [BusTrainStop].self, decoder: JSONDecoder())
        .replaceError(with: [])
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: parseNearbyStops)
    }
  }

  // MARK: Stops
  public func addStop(_ stop: BusTrainStop) {
    if !(favouriteStops.map { $0.stopID }.contains(stop.stopID)) {
      favouriteStops.append(stop)
      CLKComplicationServer.sharedInstance().reloadComplicationDescriptors() // Reload complications because a new stop exists
    }
  }

  public func deleteStop(at indices: IndexSet) {
    indices.forEach { favouriteStops.remove(at: $0) }
    CLKComplicationServer.sharedInstance().reloadComplicationDescriptors() // Reload complications because a stop is deleted
  }

  // MARK: Routes
  public func addRoute(_ route: Route) {
    favoriteRoutes.append(route)
  }

  public func deleteRoute(at indices: IndexSet) {
    indices.forEach { favoriteRoutes.remove(at: $0) }
  }


  // A sink that is also called whenever the currentDrinks array changes.
  private var updateSink: AnyCancellable!
  private var cancellables: Set<AnyCancellable> = []

  // MARK: - Private Methods

  // The model's initializer. Do not call this method.
  // Use the shared instance instead.
  private override init() {
    super.init()
    // Load user routes and stops
    loadUserStops()
    loadUserRoutes()
    // Fetch Departure Data.
    fetchAllData()
    
    updateSink = $departureDetails.sink { _ in
      // Update any complications on active watch faces.
      let server = CLKComplicationServer.sharedInstance()
      for complication in server.activeComplications ?? [] {
        server.reloadTimeline(for: complication)
      }
    }
  }




  private func stopDataPublisher(for stop: String) -> AnyPublisher<DepartureDetails, Never> {
    let url = URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/" + stop)!
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: DepartureDetails.self, decoder: JSONDecoder())
      .replaceError(with: DepartureDetails())
      .eraseToAnyPublisher()
  }

  private func parseDepartures(result: DepartureDetails) {
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
      print(" Stop: \(result.stop.stopID) \(String(describing: result.stop)) count: \(result.services.count)")
    }
  }

  private func parseStop(result: DepartureDetails) {
    if result.services.count == 0 {
      // fetch error!
      fetchState = .failed
      stop = BusTrainStop(stopID: "", name: "", latitude: 0.0, longitude: 0.0)
    } else {
      // fetch succeeded!
      fetchState = .success
      stop = result.stop
      stop.name = Abbreviator.abbrv(result.stop.name)
      //let stopName = Abbreviator.abbrv(result.stop.name)

      print(" Stop: \(result.stop.stopID) \(result.stop.name) (\(String(describing: stop)))")
      
    }
  }

  private func parseNearbyStops(result: [BusTrainStop]) {
    if result.count == 0 {
      // fetch error!
      fetchState = .failed
      nearbyStops = []
    } else {
      // fetch succeeded!
      nearbyStops = result
      fetchState = .success
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

  private var displayAllStops = false

  // MARK: User Preferences Storage
  private let stopsFile: URL = FileManager.documentDirectory
    .appendingPathComponent("Stops")
    .appendingPathExtension("txt")
  private let routesFile: URL = FileManager.documentDirectory
    .appendingPathComponent("Routes")
    .appendingPathExtension("txt")

  // MARK: Background Processing Storage
  private lazy var backgroundURLSession: URLSession = {
    let config = URLSessionConfiguration.background(withIdentifier: "BackgroundMetro")
    config.isDiscretionary = false
    config.sessionSendsLaunchEvents = true

    return URLSession(configuration: config, delegate: self, delegateQueue: nil)
  }()

  private var completionHandler : ((_ update: Bool) -> Void)?

  private var backgroundTask: URLSessionDownloadTask? = nil

  // The deinitializer for the model object.
  deinit {
    // Cancel the observer.
    updateSink.cancel()
  }
}

// MARK: Background Processing
extension MetroData {
  public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
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

  public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    print("session didCompleteWithError \(error.debugDescription)")
    DispatchQueue.main.async {
      self.completionHandler?(error == nil)
      self.completionHandler = nil
    }
  }

  public func schedule(_ first: Bool) {
    if backgroundTask == nil {
      let bgTask = backgroundURLSession.downloadTask(with: URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/3546")!)
      bgTask.earliestBeginDate = Date().addingTimeInterval(first ? 60 : 15*60)
      bgTask.countOfBytesClientExpectsToSend = 200
      bgTask.countOfBytesClientExpectsToReceive = 2048

      bgTask.resume()

      backgroundTask = bgTask
    }
  }

  public func refresh(_ completionHandler: @escaping (_ update: Bool) -> Void) {
    self.completionHandler = completionHandler
  }
}

// MARK: Loading / Saving User Preferences

extension MetroData {
  private func loadUserStops() {
    let decoder = JSONDecoder()

    do {
      let data = try Data(contentsOf: stopsFile)
      favouriteStops = try decoder.decode([BusTrainStop].self, from: data)
    } catch let error {
      print(error)
    }
  }

  private func loadUserRoutes() {
    let decoder = JSONDecoder()

    do {
      let data = try Data(contentsOf: routesFile)
      favoriteRoutes = try decoder.decode([Route].self, from: data)
    } catch let error {
      print(error)
    }
  }

  private func saveUserStops() {
    let encoder = JSONEncoder()

    do {
      let data = try encoder.encode(favouriteStops)
      try data.write(to: stopsFile, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }

  private func saveUserRoutes() {
    let encoder = JSONEncoder()

    do {
      let data = try encoder.encode(favoriteRoutes)
      try data.write(to: routesFile, options: .atomicWrite)
    } catch let error {
      print(error)
    }
  }
}




