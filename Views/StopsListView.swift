//
//  ServicesListView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 8/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI

struct StopsListView: View {

  // Access the shared model object.
  //let data = MetroData.shared
  @EnvironmentObject var metroData: MetroData
  
  var body: some View {
    List {
      ForEach(metroData.stops) { stop in
        VStack(alignment: .leading) {
          Text(stop.stopID)
            .font(Font.system(size: 30.0, design: .rounded))
            .fontWeight(.bold)
            .padding(.vertical, 5)
          Text(stop.name)
            .font(Font.system(size: 15.0, design: .rounded))
            .padding(.bottom, 8)
        }
      }
      .onDelete { metroData.deleteStop(at: $0) }
      .listRowPlatterColor(Color.purple)
      NavigationLink(destination: SelectStopView().environmentObject(metroData)) {
        HStack {
          Image(systemName: "figure.wave.circle")
            .imageScale(.large)
            .padding(.horizontal, 10)
          Text("Add New")
        }
      }
      .listRowPlatterColor(Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)))
    }
    //.padding(.bottom, 20)
  }
}

struct StopsListView_Previews: PreviewProvider {
  static var previews: some View {
    StopsListView()
  }
}
