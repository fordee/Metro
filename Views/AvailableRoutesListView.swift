//
//  AvailableRoutesListView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 9/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI

struct AvailableRoutesListView: View {

  // Access the shared model object.
  //let data = MetroData.shared
  //let sortedRoutes = availableRoutes.sorted(by: $0.)

  var body: some View {
    List {
      ForEach(availableRoutes.sorted(by: <)) { route in
        VStack(alignment: .leading) {
          Text(route.routeShortName)
            .font(Font.system(size: 30.0, design: .rounded))
            .fontWeight(.bold)
            .padding(.vertical, 5)
          Text(route.routeLongName)
            .font(Font.system(size: 15.0, design: .rounded))
            .padding(.bottom, 8)
        }
      }
      .listRowPlatterColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
      NavigationLink(destination: SelectStopView()) {
        HStack {
          Image(systemName: "bus")
            .imageScale(.large)
            .padding(.horizontal, 10)
          Text("Add New")
        }
      }
      .listRowPlatterColor(Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)))
    }
    .padding(.bottom, 20)
  }
}

struct AvailableRoutesListView_Previews: PreviewProvider {
  static var previews: some View {
    AvailableRoutesListView()
  }
}

