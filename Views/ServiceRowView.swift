//
//  ServiceRowView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI

struct ServiceRowView: View {
  let service: BusTrainService
  let size: CGFloat = 30

  @EnvironmentObject var metroData: MetroData

  var body: some View {
    let multiplier = size / 44
    let color = metroData.favoriteServices.contains(service.serviceID) ? #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)

    return HStack {
      HStack(alignment: .center, spacing: 4.0 * multiplier) {
        ZStack {
          Circle()
            .stroke(Color(color), style: StrokeStyle(lineWidth: 5 * multiplier))
            .frame(width: size, height: size)
          Circle()
            .colorInvert()
            .frame(width: size * 0.8, height: size * 0.8)
          Text(service.serviceID)
            .foregroundColor(Color.white)
            .font(.system(size: 16 * multiplier))
            .fontWeight(.bold)
        }
        VStack(alignment: .leading) {
          HStack {
            Text(getTimeFromDateString(from: service.expectedDeparture ?? service.aimedArrival + "a"))
              .foregroundColor(Color.white)
              .font(.system(size: 24 * multiplier))
              .fontWeight(.bold)
              .lineLimit(1)
              .padding(.trailing, 16 * multiplier)
            Text(service.departureStatus ?? "")//no status")
              .foregroundColor(Color.white)//.opacity(0.8)
              .font(.system(size: 16 * multiplier))
              .fontWeight(.bold)
              .padding(.trailing, 16 * multiplier)
              .frame(width: 60)
          }
          Text(service.destinationStopName ?? "No Destination")
            .foregroundColor(Color.white).opacity(0.8)
            .font(.system(size: 18 * multiplier))
            //.fontWeight(.bold)
            .padding(.trailing, 16 * multiplier)
        }
      }
    }
    .padding(multiplier * 2)
    .background(Color(color))
    .cornerRadius(44 * multiplier)
  }
}

struct ServiceRowView_Previews: PreviewProvider {
  static var previews: some View {
    let service = BusTrainService(serviceID: "52", expectedDeparture: "2020-06-30T06:32+12:00")
    return VStack {
      ServiceRowView(service: service)
    }
  }
}
