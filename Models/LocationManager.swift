//
//  LocationManager.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 12/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {

  @Published var userLatitude: Double = 0
  @Published var userLongitude: Double = 0

  private let locationManager = CLLocationManager()

  override init() {
    super.init()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
  }
}

extension LocationManager: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    userLatitude = location.coordinate.latitude
    userLongitude = location.coordinate.longitude
    print(location)
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print("Auth Status: \(manager.desiredAccuracy)")
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("didFailWithError \(error.localizedDescription)")
  }

}
