//
//  Helpers.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation

func getTimeFromDateString(from: String?) -> String {
  if let from = from {
    if from == "" { return "" }
    let indexStartOfText = from.index(from.startIndex, offsetBy: 11)
    let indexEndOfText = from.index(from.startIndex, offsetBy: 15)
    let timeString = from[indexStartOfText ... indexEndOfText]
    return String(timeString)
  } else {
    return ""
  }
}

extension String {
  public func converStringToDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "NZST")

    let date = dateFormatter.date(from: self)

    return date//?.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))

  }
}

