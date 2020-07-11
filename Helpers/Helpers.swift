//
//  Helpers.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import UIKit

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

extension FileManager {
  static var documentDirectory: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

extension UIColor {
  public convenience init?(hex: String) {
    let r, g, b: CGFloat//, a: CGFloat

    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])

      if hexColor.count == 6 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          //a = CGFloat(hexNumber & 0x000000ff) / 255

          self.init(red: r, green: g, blue: b, alpha: 1)
          return
        }
      }
    }

    return nil
  }
}
