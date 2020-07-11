//
//  Abbreviator.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 11/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation

struct Abbreviator {
  static let commonAbbreviations: [String : String] = [
    // Terminus
    "Station": "Stn",
    "Stop": "Stp",
    // Street
    "Place": "Pl",
    "Street": "St",
    "Road": "Rd",
    "Lane": "Ln",
    "Quay": "Qy",
    "Crescent": "Cr",
    "Court": "Ct",
    "Cove": "Cv",
    "Drive": "Dv",
    "Ferry": "Fry",
    "Floor": "Fl",
    "Boulevard": "Bv",
    // Location
    "North": "N",
    "South": "S",
    "East": "E",
    "West": "W",
//    "at": "@",
    "Grand": "Gr",
    "Theatre": "Thtr"
  ]

  static let aggressiveAbbreviations: [String : String] = [
    "Courtenay": "Crtny",
    "Lambton": "Lmtn",
    "James": "Jms"

  ]

  static func abbrv(_ sentence: String) -> String {
    if sentence.count < 15 { return sentence }

    let words = sentence.split(separator: " ")
    var newWords: [String] = words.map {
      if let replacment = commonAbbreviations[String($0)] {
        return replacment
      } else {
        return String($0)
      }
    }
    if newWords.joined(separator: " ").count > 20 {
      newWords = newWords.map {
        if let replacment = aggressiveAbbreviations[String($0)] {
          return replacment
        } else {
          return String($0)
        }
      }
    }

    return newWords.joined(separator: " ")
  }
}
