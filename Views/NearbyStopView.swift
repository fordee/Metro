//
//  NearbyStopView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 12/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine

struct NearbyStopView: View {
  @ObservedObject var locationManager = LocationManager()

  @EnvironmentObject var metroData: MetroData
  @Environment(\.presentationMode) var presentation

  var body: some View {
    VStack {
      List {
        ForEach(metroData.nearbyStops) { stop in
          VStack(alignment: .leading) {
            Text(stop.stopID)
              .font(Font.system(size: 30.0, design: .rounded))
              .fontWeight(.bold)
              .padding(.vertical, 5)
            Text(stop.name)
              .font(Font.system(size: 15.0, design: .rounded))
              .padding(.bottom, 8)
          }
          .listRowPlatterColor(Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)))
          .onTapGesture {
            print("Tapped: \(stop.stopID)")
            metroData.addStop(stop)
            presentation.wrappedValue.dismiss()
          }
          NavigationLink(destination: MapView(latitude: stop.latitude, // TODO: Should be stop data
                                              longitude: stop.longitude).environmentObject(metroData)) {
            HStack {
              Image(systemName: "map")
                .imageScale(.large)
                .padding(.horizontal, 10)
              Text("Show Map")
            }
          }
          .listRowPlatterColor(Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)))
        }

      }
    }
    .onAppear {
      metroData.fetchNearbyStops(for: (locationManager.userLatitude, locationManager.userLongitude))
    }

  }
}

struct NearbyStopView_Previews: PreviewProvider {
  static var previews: some View {
    NearbyStopView()
  }
}
