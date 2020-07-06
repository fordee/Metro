//
//  ContentView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
  @AppStorage("currentStop") private var currentStop = "3546"
  @AppStorage("displayAllStops") private var displayAllStops = false

  // Access the shared model object.
  let data = MetroData.shared

  var body: some View {
    VStack {
      Picker(selection: $currentStop, label: EmptyView()) {
        ForEach(data.stops) { stop in
          Text("\(stop.stopName)").tag("\(stop.stopNumber)")
        }
      }
      .frame(minHeight: 44, maxHeight: 44)
      NavigationLink(destination: TimetableView(stop: currentStop, displayAllStops: displayAllStops).environmentObject(data)) {
        //Label("Timetable", systemImage: "bus")//"arrow.counterclockwise.circle")
        HStack {
          Image(systemName: "bus")
            .imageScale(.large)
            .padding(.horizontal, 8)
          Text("Timetable")
        }
      }
      Toggle(isOn: $displayAllStops) {
        Text("Display All Stops")
      }
      .padding(4)
      HStack {
        Button {
          print("Settings tapped.")
        } label: {
          Image(systemName: "gearshape")
            .imageScale(.large)
            .padding(.horizontal, 8)
            .foregroundColor(.purple)
        }
        .frame(width: 22, height: 20, alignment: .center)
        .padding(.horizontal, 8)
        .padding(.top, 8)
        Spacer()
      }
    }

  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    return ContentView()
  }
}