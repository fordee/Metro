//
//  ComplicationController.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
//    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
//        handler([.forward, .backward])
//    }
//
//    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
//        handler(nil)
//    }
//
//    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
//        handler(nil)
//    }
//
//    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
//        handler(.showOnLockScreen)
//    }
//
//    // MARK: - Timeline Population
//
//    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
//        // Call the handler with the current timeline entry
//        handler(nil)
//    }
//
//    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
//        // Call the handler with the timeline entries prior to the given date
//        handler(nil)
//    }
//
//    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
//        // Call the handler with the timeline entries after to the given date
//        handler(nil)
//    }
//
//    // MARK: - Placeholder Templates
//
//    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
//        // This method will be called once per supported complication, and the results will be cached
//        handler(nil)
//    }
  // The Metro Finder app's data model
    lazy var data = MetroData.shared



    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
      var descriptors: [CLKComplicationDescriptor] = []
      var dataDict: Dictionary<AnyHashable, Any> = [:]

      for stop in data.stops {
        dataDict = ["name": stop.stopName, String("id"): String(stop.id)]
        let descriptor = CLKComplicationDescriptor(identifier: String(stop.id),
                                                   displayName: stop.stopName,
                                                   supportedFamilies: [CLKComplicationFamily.graphicCorner
                                                                     //, CLKComplicationFamily.graphicCircular
                                                   ],
                                                   userInfo: dataDict)
        descriptors.append(descriptor)
      }

      // Call the handler with the currently supported complication descriptors
      handler(descriptors)
    }

    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
      // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    // Define whether the app can provide future data.
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler:@escaping (CLKComplicationTimeTravelDirections) -> Void) {
        // Indicate that the app can provide future timeline entries.
        handler([.forward])
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
      // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
      // Indicate that the app can provide timeline entries for the next 12 hours.
      handler(Date().addingTimeInterval(12 * 60.0 * 60.0))
    }

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
      // Call the handler with your desired behavior when the device is locked
      handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
      // Call the handler with the current timeline entry
      handler(createTimelineEntry(forComplication: complication, date: Date()))
    }

    func getTimelineEntries(for complication: CLKComplication,
                            after date: Date,
                            limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
      // Call the handler with the timeline entries after the given date

      var entries: [CLKComplicationTimelineEntry] = []

      let stopID = complication.userInfo!["id"]! as! String // TODO remove !
      let services = data.departureDetails[stopID] ?? []

      for service in services {
        let date = service.aimedArrival.converStringToDate()! // TODO remove !
        let entry = createTimelineEntry(forComplication: complication, date: date)
        entries.append(entry)
        print("\(stopID) Timeline entry for \(date) for complication: \(complication.userInfo!["id"]!)")
      }

      handler(entries)

    }

    // MARK: - Sample Templates

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
      // This method will be called once per supported complication, and the results will be cached
      let future = Date()//.addingTimeInterval(60.0)
      let template = createTemplate(forComplication: complication, date: future)
      handler(template)
    }

    // MARK: - Private Methods

    // Return a timeline entry for the specified complication and date.
    private func createTimelineEntry(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTimelineEntry {

        // Get the correct template based on the complication.
        let template = createTemplate(forComplication: complication, date: date)

        // Use the template and date to create a timeline entry.
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }

    // Select the correct template based on the complication's family.
    private func createTemplate(forComplication complication: CLKComplication, date: Date) -> CLKComplicationTemplate {
        switch complication.family {
  //      case .modularSmall:
  //          return createModularSmallTemplate(forDate: date)
  //      case .modularLarge:
  //          return createModularLargeTemplate(forDate: date)
  //      case .utilitarianSmall, .utilitarianSmallFlat:
  //          return createUtilitarianSmallFlatTemplate(forDate: date)
  //      case .utilitarianLarge:
  //          return createUtilitarianLargeTemplate(forDate: date)
  //      case .circularSmall:
  //          return createCircularSmallTemplate(forDate: date)
  //      case .extraLarge:
  //          return createExtraLargeTemplate(forDate: date)
        case .graphicCorner:
          return createGraphicCornerTemplate(forDate: date, complication: complication)
        case .graphicCircular:
            return createGraphicCircleTemplate(forDate: date)
  //      case .graphicRectangular:
  //          return createGraphicRectangularTemplate(forDate: date)
  //      case .graphicBezel:
  //          return createGraphicBezelTemplate(forDate: date)
  //      case .graphicExtraLarge:
  //          if #available(watchOSApplicationExtension 7.0, *) {
  //              return createGraphicExtraLargeTemplate(forDate: date)
  //          } else {
  //              fatalError("Graphic Extra Large template is only available on watchOS 7.")
  //          }
        default:
          fatalError("*** Unknown Complication Family ***")
        }
    }

    // Return a graphic template that fills the corner of the watch face.
    private func createGraphicCornerTemplate(forDate date: Date, complication: CLKComplication) -> CLKComplicationTemplate {
      var stopName = ""
      var stopID = ""
      var serviceTimeRelative: CLKRelativeDateTextProvider? = nil
      var serviceTime: CLKTimeTextProvider? = nil

      if let userInfo = complication.userInfo, let id = userInfo["id"], let name = userInfo["name"] {
        stopName = name as! String
        stopID = id as! String
      }

      //print("id:\(stopID), name: \(stopName)")

      if let firstServiceDate = data.firstServiceDate(fromDate: date, stopID: stopID) {
        serviceTime = CLKTimeTextProvider(date: firstServiceDate)
        serviceTime?.tintColor = UIColor(#colorLiteral(red: 0.9834979177, green: 0.05861451477, blue: 0.3534923792, alpha: 1))

        serviceTimeRelative = CLKRelativeDateTextProvider(date: firstServiceDate, style: .natural, units: [.minute])//CLKTimeTextProvider(date: firstServiceDate)
        serviceTimeRelative?.tintColor = UIColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
      }
      //print("serviceTime: \(String(describing: serviceTime?.date))")

      let innerText = CLKTextProvider(format: "%@", stopName)

      let outerText =  CLKTextProvider(format: "%@ %@", serviceTime ?? "No", serviceTimeRelative ?? "Data")
      let template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: innerText, outerTextProvider: outerText)


      return template

    }

    // Return a graphic circle template.
    private func createGraphicCircleTemplate(forDate date: Date) -> CLKComplicationTemplate {
        // Create the data providers.
      let percentage = Float(0.5)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill,
                                                   gaugeColors: [.green, .yellow, .red],
                                                   gaugeColorLocations: [0.0, 300.0 / 500.0, 450.0 / 500.0] as [NSNumber],
                                                   fillFraction: percentage)
  //
      let mgCaffeineProvider = CLKRelativeDateTextProvider(date: Date(), style: .naturalAbbreviated, units: [.minute])//CLKSimpleTextProvider(text: "13:32")
  //      let mgUnitProvider = CLKSimpleTextProvider(text: "mg Caffeine", shortText: "mg")
  //      mgUnitProvider.tintColor = data.color(forCaffeineDose: data.mgCaffeine(atDate: date))

        // Create the template using the providers.
        //let template = CLKComplicationTemplateGraphicCircularView(CircularComplicationView())
        let template = CLKComplicationTemplateGraphicCircularOpenGaugeSimpleText(gaugeProvider: gaugeProvider, bottomTextProvider: CLKSimpleTextProvider(text: "mg"), center: mgCaffeineProvider)
        template.gaugeProvider = gaugeProvider
        //template.centerTextProvider = mgCaffeineProvider
        //template.bottomTextProvider = CLKSimpleTextProvider(text: "mg")
        return template
    }

    
}
