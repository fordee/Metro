//
//  Route.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 9/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import Foundation

struct Route: Codable, Identifiable {
  let routeId: Int
  let agencyId: String
  let routeShortName: String
  let routeLongName: String
  let routeType: Int
  let routeColor: String
  let routeTextColor: String

  var id: Int {
    routeId
  }
}

extension Route: Comparable {
  static func <(lhs: Route, rhs: Route) -> Bool {
//    let leftInt: Int? = Int(lhs.routeShortName)
//    let rightInt: Int? = Int(rhs.routeShortName)
//
//    if let leftInt = leftInt, let rightInt = rightInt { // If they are numbers compare them like numbers
//      return leftInt < rightInt                         // So that 26 < 210
//    }

    return lhs.routeShortName < rhs.routeShortName
  }
}

var availableRoutes: [Route] = [
  Route(routeId: 190, agencyId: "TZM", routeShortName: "19", routeLongName: "Johnsonville - Churton Park - Johnsonville", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 230, agencyId: "TZM", routeShortName: "23", routeLongName: "Houghton Bay - Newtown - Vogeltown - Kingston", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 370, agencyId: "NBM", routeShortName: "37", routeLongName: "Karori Route(Wrights Hill), - Kelburn - Brandon Street", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 1500, agencyId: "TZM", routeShortName: "150", routeLongName: "Kelson - Lower Hutt - Maungaraki - Petone", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 1540, agencyId: "TZM", routeShortName: "154", routeLongName: "Petone - Korokoro - Petone", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 181, agencyId: "NBM", routeShortName: "18e", routeLongName: "Miramar - Newtown - Kelburn - Karori", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 70, agencyId: "TZM", routeShortName: "7", routeLongName: "Kingston - Brooklyn - Wellington", routeType:   3, routeColor: "9f219f", routeTextColor: "ffffff"),
  Route(routeId: 570, agencyId: "MNM", routeShortName: "57", routeLongName: "Woodridge - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2640, agencyId: "UZM", routeShortName: "264", routeLongName: "Paraparaumu East - Paraparaumu - Kapiti Health Centre", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 260, agencyId: "TZM", routeShortName: "26", routeLongName: "Khandallah - Ngaio - Brandon Street", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2600, agencyId: "UZM", routeShortName: "260", routeLongName: "Raumati Beach - Paraparaumu Beach - Paraparaumu", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 290, agencyId: "TZM", routeShortName: "29", routeLongName: "Newtown - Southgate - Owhiro Bay - Brooklyn", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 1130, agencyId: "TZM", routeShortName: "113", routeLongName: "Riverstone Terraces - Upper Hutt", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 340, agencyId: "NBM", routeShortName: "34", routeLongName: "Karori West - Brandon Street", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 9911, agencyId: "TZM", routeShortName: "N1", routeLongName: "After Midnight Route(Wellington - Island Bay - Houghton Bay - Lyall Bay),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 180, agencyId: "NBM", routeShortName: "18", routeLongName: "Miramar - Kilbirnie", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 9914, agencyId: "TZM", routeShortName: "N4", routeLongName: "After Midnight Route(Wellington - Wadestown - Ngaio - Khandallah),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 280, agencyId: "NBM", routeShortName: "28", routeLongName: "Beacon Hill - Strathmore Park Shops", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 220, agencyId: "NBM", routeShortName: "22", routeLongName: "Johnsonville - Mairangi - Kelburn - Wellington", routeType:   3, routeColor: "f58025", routeTextColor: "000000"),
  Route(routeId: 2510, agencyId: "UZM", routeShortName: "251", routeLongName: "Paekakariki - Paraparaumu - Kapiti Health Centre", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 560, agencyId: "MNM", routeShortName: "56", routeLongName: "Johnsonville - Paparangi - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 1110, agencyId: "TZM", routeShortName: "111", routeLongName: "Upper Hutt - Totara Park - Upper Hutt", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2300, agencyId: "TZM", routeShortName: "230", routeLongName: "Whitby Route(The Crowsnest), - Aotea - Porirua", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 9916, agencyId: "TZM", routeShortName: "N6", routeLongName: "After Midnight Route(Wellington - Porirua - Whitby - Plimmerton),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 231, agencyId: "TZM", routeShortName: "23e", routeLongName: "Houghton Bay - Newtown - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 300, agencyId: "NBM", routeShortName: "30x", routeLongName: "Scorching Bay/Moa Point - Wellington Route(Express),", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 140, agencyId: "NBM", routeShortName: "14", routeLongName: "Wilton - Wellington - Roseneath - Hataitai - Kilbirnie", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 580, agencyId: "MNM", routeShortName: "58", routeLongName: "Newlands - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2610, agencyId: "UZM", routeShortName: "261", routeLongName: "Paraparaumu Beach - Paraparaumu Route(via Guildford Drive),", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 232, agencyId: "TZM", routeShortName: "23z", routeLongName: "Wellington Zoo - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 840, agencyId: "NBM", routeShortName: "84", routeLongName: "Eastbourne - Gracefield - Petone - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 9915, agencyId: "TZM", routeShortName: "N5", routeLongName: "After Midnight Route(Wellington - Newlands - Churton Park - Johnsonville),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 830, agencyId: "NBM", routeShortName: "83", routeLongName: "Eastbourne - Lower Hutt - Petone - Wellington", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2030, agencyId: "TZM", routeShortName: "203", routeLongName: "Masterton - Masterton North - Masterton", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 1100, agencyId: "TZM", routeShortName: "110", routeLongName: "Emerald Hill - Upper Hutt - Lower Hutt - Petone", routeType:   3, routeColor: "9849b8", routeTextColor: "ffffff"),
  Route(routeId: 2010, agencyId: "TZM", routeShortName: "201", routeLongName: "Masterton - Masterton West - Masterton", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 320, agencyId: "TZM", routeShortName: "32x", routeLongName: "Houghton Bay - Island Bay - Berhampore - Wellington Route(Express),", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2200, agencyId: "TZM", routeShortName: "220", routeLongName: "Titahi Bay - Porirua - Ascot Park", routeType:   3, routeColor: "8854", routeTextColor: "000000"),
  Route(routeId: 30, agencyId: "NBM", routeShortName: "3", routeLongName: "Lyall Bay/Rongotai - Kilbirnie - Newtown - Wellington", routeType:   3, routeColor: "5e9732", routeTextColor: "000000"),
  Route(routeId: 2100, agencyId: "TZM", routeShortName: "210", routeLongName: "Titahi Bay - Porirua", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 3000, agencyId: "TZM", routeShortName: "300", routeLongName: "Whenua Tapu Cemetery - Porirua - Titahi Bay", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 240, agencyId: "TZM", routeShortName: "24", routeLongName: "Johnsonville - Broadmeadows - Wellington - Miramar Heights", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 9912, agencyId: "NBM", routeShortName: "N2", routeLongName: "After Midnight Route(Wellington - Miramar - Strathmore Park - Seatoun),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 2810, agencyId: "UZM", routeShortName: "281", routeLongName: "Waikanae - Waikanae East - Waikanae", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 8, agencyId: "EBYW", routeShortName: "WHF", routeLongName: "Wellington Harbour Ferry Route(Days Bay - Queens Wharf),", routeType:   4, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2500, agencyId: "UZM", routeShortName: "250", routeLongName: "Paraparaumu - Raumati South - Paraparaumu", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2020, agencyId: "TZM", routeShortName: "202", routeLongName: "Masterton - Masterton South - Masterton", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 4, agencyId: "RAIL", routeShortName: "WRL", routeLongName: "Wairarapa Line Route(Masterton - Wellington),", routeType:   2, routeColor: "ffc000", routeTextColor: "000000"),
  Route(routeId: 9922, agencyId: "TZM", routeShortName: "N22", routeLongName: "After Midnight Route(Wellington - Naenae - Stokes Valley - Upper Hutt),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 120, agencyId: "NBM", routeShortName: "12", routeLongName: "Strathmore Park - Kilbirnie - Newtown", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2910, agencyId: "UZO", routeShortName: "291", routeLongName: "Waikanae - Levin", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2040, agencyId: "TZM", routeShortName: "204", routeLongName: "Greytown - Woodside", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 1200, agencyId: "TZM", routeShortName: "120", routeLongName: "Stokes Valley - Taita - Epuni - Lower Hutt", routeType:   3, routeColor: "8854", routeTextColor: "000000"),
  Route(routeId: 360, agencyId: "NBM", routeShortName: "36", routeLongName: "Lyall Bay - Kilbirnie - Hataitai - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 9, agencyId: "WCCL", routeShortName: "CCL", routeLongName: "Cable Car Route(Kelburn - Wellington),", routeType:   5, routeColor: "db2032", routeTextColor: "ffffff"),
  Route(routeId: 9913, agencyId: "NBM", routeShortName: "N3", routeLongName: "After Midnight Route(Wellington - Kelburn - Karori - Northland),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 1210, agencyId: "TZM", routeShortName: "121", routeLongName: "Stokes Valley Heights - Naenae - Lower Hutt - Seaview", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 600, agencyId: "MNM", routeShortName: "60", routeLongName: "Porirua - Tawa - Johnsonville", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 810, agencyId: "NBM", routeShortName: "81", routeLongName: "Eastbourne - Petone - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 5, agencyId: "RAIL", routeShortName: "HVL", routeLongName: "Hutt Valley Line Route(Upper Hutt - Wellington),", routeType:   2, routeColor: "ff6600", routeTextColor: "000000"),
  Route(routeId: 121, agencyId: "NBM", routeShortName: "12e", routeLongName: "Strathmore Park - Kilbirnie - Hataitai - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 210, agencyId: "NBM", routeShortName: "21", routeLongName: "Karori Route(Wrights Hill), - Kelburn - Courtenay Place", routeType:   3, routeColor: "ee80b3", routeTextColor: "000000"),
  Route(routeId: 270, agencyId: "TZM", routeShortName: "27", routeLongName: "Vogeltown - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 1450, agencyId: "TZM", routeShortName: "145", routeLongName: "Belmont - Melling - Lower Hutt", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 250, agencyId: "TZM", routeShortName: "25", routeLongName: "Khandallah - Wellington - Aro Valley - Highbury", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2060, agencyId: "TZM", routeShortName: "206", routeLongName: "Masterton - Masterton East - Masterton", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 1600, agencyId: "TZM", routeShortName: "160", routeLongName: "Wainuiomata North - Waterloo - Lower Hutt", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 170, agencyId: "TZM", routeShortName: "17", routeLongName: "Kowhai Park - Brooklyn", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 1700, agencyId: "TZM", routeShortName: "170", routeLongName: "Lower Hutt - Wainuiomata South - Lower Hutt", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 10, agencyId: "TZM", routeShortName: "1", routeLongName: "Johnsonville West/Churton Park/Grenada Village - Island Bay", routeType:   3, routeColor: "e31837", routeTextColor: "ffffff"),
  Route(routeId: 2800, agencyId: "UZM", routeShortName: "280", routeLongName: "Waikanae - Waikanae Beach - Waikanae", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 291, agencyId: "TZM", routeShortName: "29e", routeLongName: "Newtown - Southgate - Owhiro Bay - Brooklyn Route(Wellington extension),", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 9988, agencyId: "NBM", routeShortName: "N88", routeLongName: "After Midnight Route(Wellington - Petone - Lower Hutt - Eastbourne),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 1140, agencyId: "TZM", routeShortName: "114", routeLongName: "Trentham - Elderslea - Upper Hutt", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 1120, agencyId: "TZM", routeShortName: "112", routeLongName: "Te Marua - Timberlea - Maoribank - Upper Hutt", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 1300, agencyId: "TZM", routeShortName: "130", routeLongName: "Naenae - Waterloo - Lower Hutt - Petone", routeType:   3, routeColor: "00689e", routeTextColor: "ffffff"),
  Route(routeId: 9966, agencyId: "TZM", routeShortName: "N66", routeLongName: "After Midnight Route(Wellington - Lower Hutt - Waterloo - Wainuiomata),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 2620, agencyId: "UZM", routeShortName: "262", routeLongName: "Paraparaumu Beach - Paraparaumu Route(via Mazengarb Road),", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 520, agencyId: "MNM", routeShortName: "52", routeLongName: "Johnsonville - Newlands - Wellington", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 20, agencyId: "NBM", routeShortName: "2", routeLongName: "Karori - Wellington - Hataitai - Seatoun", routeType:   3, routeColor: "005eb8", routeTextColor: "ffffff"),
  Route(routeId: 1150, agencyId: "TZM", routeShortName: "115", routeLongName: "Upper Hutt - Pinehaven - Upper Hutt", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2360, agencyId: "TZM", routeShortName: "236", routeLongName: "Whitby Route(Navigation Drive), - Paremata - Papakowhai - Porirua", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 3, agencyId: "RAIL", routeShortName: "MEL", routeLongName: "Melling Line Route(Melling - Wellington),", routeType:   2, routeColor: "ff6600", routeTextColor: "000000"),
  Route(routeId: 200, agencyId: "NBM", routeShortName: "20", routeLongName: "Kilbirnie - Mt Victoria - Courtenay Place", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 310, agencyId: "NBM", routeShortName: "31x", routeLongName: "Miramar North - Wellington Route(Express),", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 6, agencyId: "RAIL", routeShortName: "JVL", routeLongName: "Johnsonville Line Route(Johnsonville - Wellington),", routeType:   2, routeColor: "42c3dc", routeTextColor: "000000"),
  Route(routeId: 850, agencyId: "NBM", routeShortName: "85x", routeLongName: "Eastbourne - Wellington Route(Express),", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2000, agencyId: "TZM", routeShortName: "200", routeLongName: "Masterton - Greytown - Featherston - Martinborough", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 2900, agencyId: "UZM", routeShortName: "290", routeLongName: "Waikanae - Otaki - Waikanae", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 9918, agencyId: "NBM", routeShortName: "N8", routeLongName: "After Midnight Route(Lower Hutt - Petone - Wellington),", routeType:   3, routeColor: "0", routeTextColor: "ffffff"),
  Route(routeId: 171, agencyId: "TZM", routeShortName: "17e", routeLongName: "Kowhai Park - Brooklyn - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2, agencyId: "RAIL", routeShortName: "KPL", routeLongName: "Kapiti Line Route(Waikanae - Wellington),", routeType:   2, routeColor: "d4e031", routeTextColor: "000000"),
  Route(routeId: 350, agencyId: "NBM", routeShortName: "35", routeLongName: "Hataitai - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 2260, agencyId: "TZM", routeShortName: "226", routeLongName: "Sievers Grove - Elsdon - Sievers Grove", routeType:   3, routeColor: "6cace4", routeTextColor: "000000"),
  Route(routeId: 191, agencyId: "TZM", routeShortName: "19e", routeLongName: "Johnsonville - Churton Park - Johnsonville Route(Wellington extension),", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 601, agencyId: "MNM", routeShortName: "60e", routeLongName: "Porirua - Tawa - Johnsonville - Wellington", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 330, agencyId: "NBM", routeShortName: "33", routeLongName: "Karori South - Brandon Street", routeType:   3, routeColor: "636466", routeTextColor: "ffffff"),
  Route(routeId: 130, agencyId: "NBM", routeShortName: "13", routeLongName: "Mairangi - Glenmore Street - Brandon Street", routeType:   3, routeColor: "636466", routeTextColor: "ffffff")
]



