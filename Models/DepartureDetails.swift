//
//  DepartureDetails.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation
import SwiftUI

struct MetStop: Identifiable {
  var id: String {
    stopNumber
  }
  let stopNumber: String
  let stopName: String
}

public struct BusTrainService: Decodable, Identifiable, Equatable {
  public enum CodingKeys: String, CodingKey {
    case serviceID = "ServiceID"
    case aimedArrival = "AimedArrival"
    case departureStatus = "DepartureStatus"
    case expectedDeparture = "ExpectedDeparture"
    case destinationStopName = "DestinationStopName"
  }
  var serviceID: String
  let aimedArrival: String
  let departureStatus: String?
  var expectedDeparture: String?
  var destinationStopName: String?

  init(serviceID: String, expectedDeparture: String) {
    self.serviceID = serviceID
    self.expectedDeparture = expectedDeparture
    self.aimedArrival = expectedDeparture
    self.departureStatus = "On Time"
  }

  public var id: String {
    serviceID + "-" + aimedArrival
  }
}

struct BusTrainStop: Decodable {
  public enum CodingKeys: String, CodingKey {
    case name = "Name"
    case stopID = "Sms"
  }
  let name: String
  let stopID: String

  init(name: String, stopID: String) {
    self.name = name
    self.stopID = stopID
  }
}

public struct DepartureDetails: Decodable, Equatable {
  public static func == (lhs: DepartureDetails, rhs: DepartureDetails) -> Bool {
    return lhs.lastModified < rhs.lastModified
  }
  public enum CodingKeys: String, CodingKey {
    case lastModified = "LastModified"
    case stop = "Stop"
    case services = "Services"
  }

  let lastModified: String
  let stop: BusTrainStop
  var services: [BusTrainService]

  init() {
    lastModified = ""
    stop = BusTrainStop.init(name: "", stopID: "")
    services = []
  }
}
