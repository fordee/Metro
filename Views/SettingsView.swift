//
//  SettingsView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 7/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI

let settingsOptions = [
  SettingsOption(type: .services, symbol: "bus.doubledecker", color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
  SettingsOption(type: .stops, symbol: "figure.wave", color: UIColor.purple)
]

struct SettingsView: View {

  @EnvironmentObject var metroData: MetroData
  
  var body: some View {
    List {
      ForEach(settingsOptions) { option in
        NavigationLink(destination: ListSelectView(selectionType: option.type).environmentObject(metroData)) {
          SettingCell(option: option)
            .frame(height: 80.0)
        }
        .listRowPlatterColor(Color(option.color))
      }
    }
  }
}

struct SettingCell: View {
  var option: SettingsOption

  var body: some View {
    HStack {
      Image(systemName: option.symbol)
        .font(.title)
        .padding(.horizontal, 10)
      Text(option.type.rawValue)
       .font(.system(.headline, design: .rounded))
    }
  }
}


struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}

enum SettingsType: String {
  case services = "Favourite Routes"
  case stops = "Favourite Stops"
}

struct SettingsOption: Identifiable {
  let type: SettingsType
  let symbol: String
  let color: UIColor


  var id: String {
    type.rawValue
  }
}

