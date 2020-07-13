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
  @EnvironmentObject var metroData: MetroData
  @Environment(\.presentationMode) var presentation
    
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
        .onTapGesture {
          print("Tapped: \(route.routeShortName)")
          metroData.addRoute(route)
          presentation.wrappedValue.dismiss()
        }
      }
      .listItemTint(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
    }
  }
}

struct AvailableRoutesListView_Previews: PreviewProvider {
  static var previews: some View {
    AvailableRoutesListView()
  }
}

