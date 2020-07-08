//
//  FavouriteStopsView.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 7/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import SwiftUI

struct ListSelectView: View {
  let selectionType: SettingsType

  var body: some View {
    Group {
      switch selectionType {
        case .services:
          ServicesListView()
        case .stops:
          StopsListView()
      }
    }

  }
}

struct FavouriteStopsView_Previews: PreviewProvider {
  static var previews: some View {
    ListSelectView(selectionType: .stops)
  }
}
