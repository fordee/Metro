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

  private var displayAllStops = false

  let stops: [MetStop] = [
    MetStop(stopNumber: 3546, stopName: "Newlands Road"),
    MetStop(stopNumber: 5016, stopName: "Wellington Stn"),
    MetStop(stopNumber: 5014, stopName: "Lambton Quay"),
    MetStop(stopNumber: 5012, stopName: "Farmers"),
    MetStop(stopNumber: 5010, stopName: "Cable Car Ln"),
    MetStop(stopNumber: 5008, stopName: "Willis St"),
  ]

  let favoriteServices = ["52", "56", "57", "58"]

  // MARK: - Private Methods

  // The model's initializer. Do not call this method.
  // Use the shared instance instead.
  private override init() {
    super.init()
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

  public func firstServiceDate(fromDate: Date, stopID: String) -> Date? {
    if let departures = departureDetails[stopID] {
      for service in filterBy(serviceIDs: favoriteServices, services: departures) {
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
        services = filterBy(serviceIDs: favoriteServices, services: result.services)
      }
      departureDetails[result.stop.stopID] = result.services
      print(" Stop: \(result.stop.stopID) count: \(result.services.count)")
    }
  }

  private func filterBy(serviceIDs: [String], services: [BusTrainService]) -> [BusTrainService] {
    let filteredServices = services.filter {
      for serviceID in serviceIDs {
        if $0.serviceID == serviceID {
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



