//
//  TimetableView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI
import Combine

struct TimetableView: View {
  let stop: String
  let displayAllStops: Bool

  @EnvironmentObject var metroData: MetroData

  var body: some View {
    Group {
      switch metroData.fetchState {
        case .failed:
          Text("No data...")
        case .fetching:
          Text("Fetching...")
        case .success:
          List {
            ForEach(metroData.services) { departure in
              ServiceRowView(service: departure)
            }
            .listRowBackground(Color.clear)
          }
      }
    }
    .toolbar {
      Button {
        print("Tapped...!")
        metroData.fetchDepartureData(for: stop, displayAllStops: displayAllStops)
      }
      label: {
        HStack {
          Image(systemName: "arrow.counterclockwise.circle")
            .imageScale(.large)
            .padding(.horizontal, 10)
          Text("Refresh")
        }
      }
    }
    .onAppear {
      print(stop)
      metroData.fetchDepartureData(for: stop, displayAllStops: displayAllStops)
    }
  }
}

struct TimetableView_Previews: PreviewProvider {
  static var previews: some View {
    //let store = Store()
    return TimetableView(stop: "5012", displayAllStops: false)
  }
}


