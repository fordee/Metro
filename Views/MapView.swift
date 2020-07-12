//
//  MapView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 12/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import MapKit
import SwiftUI


struct PinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
  let latitude: Double
  let longitude: Double

  @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -41.23335086, longitude: 174.81820100),
                                                 span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

  var body: some View {
    VStack {
      Map(coordinateRegion: $region,
          annotationItems: [PinItem(coordinate: .init(latitude: latitude, longitude: longitude))]) { item in
        MapMarker(coordinate: item.coordinate)
      }
      .onAppear {
        setupMap()
      }
    }
  }

  func setupMap() {
    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude),
                                span: MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035))
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(latitude: -41.23335086, longitude: 174.81820100)
  }
}
