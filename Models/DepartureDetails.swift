//
//  DepartureDetails.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation
import SwiftUI

public struct BusTrainService: Codable, Identifiable, Equatable {
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

struct BusTrainStop: Codable, Identifiable {
  public enum CodingKeys: String, CodingKey {
    case stopID = "Sms"
    case name = "Name"
  }

  var id: String {
    stopID
  }
  
  let stopID: String
  let name: String

  init(stopID: String, name: String) {
    self.stopID = stopID
    self.name = name
  }
}

public struct DepartureDetails: Codable, Equatable {
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
    stop = BusTrainStop.init(stopID: "", name: "")
    services = []
  }
}
