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
