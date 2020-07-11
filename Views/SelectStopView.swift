//
//  SelectStopView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 8/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI

struct SelectStopView: View {
  // Access the shared model object.
  @EnvironmentObject var metroData: MetroData
  @Environment(\.presentationMode) var presentation
  @State private var digit1: Float = 0
  @State private var digit2: Float = 0
  @State private var digit3: Float = 0
  @State private var digit4: Float = 0

  //@State private var stopName: String = ""

  var body: some View {

    VStack {
      FourDigitPickerView(digit1: $digit1, digit2: $digit2, digit3: $digit3, digit4: $digit4)
      Group {
        switch metroData.fetchState {
          case .failed:
            Text("Not valid stop")
          case .fetching:
            Text("Fetching...")
          case .success:
            Text(metroData.stopName)
        }
      }
      .frame(height: 44, alignment: .leading)
      HStack {
        Button {
          let stopNumber = String(Int(digit1)) + String(Int(digit2)) + String(Int(digit3)) + String(Int(digit4))
          print("Tapped \(stopNumber)...!")
          metroData.fetchStopName(for: stopNumber)
        }
        label: {
          VStack {
            Image(systemName: "arrow.clockwise.circle")
              .imageScale(.large)
              .padding(.horizontal, 10)
            Text("Refresh")
          }
        }
        .background(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
        .cornerRadius(16.0)
        Button {
          let stopNumber = String(Int(digit1)) + String(Int(digit2)) + String(Int(digit3)) + String(Int(digit4))
          print("Tapped \(stopNumber)...!")
          //metroData.fetchData(for: stopNumber, displayAllStops: false)
          let stop = BusTrainStop(stopID: stopNumber, name: metroData.stopName)
          if !(metroData.stops.map { $0.stopID }.contains(stop.stopID)) {
            metroData.stops.append(stop)
          }
          presentation.wrappedValue.dismiss()
        }
        label: {
          VStack {
            Image(systemName: "figure.wave.circle")
              .imageScale(.large)
              .padding(.horizontal, 10)
            Text("Add")
          }
        }
        .background(Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)))
        .cornerRadius(16.0)
      }
    }
  }
}

struct SelectStopView_Previews: PreviewProvider {
  static var previews: some View {
    SelectStopView()
  }
}
