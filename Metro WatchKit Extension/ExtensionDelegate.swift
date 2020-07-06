//
//  ExtensionDelegate.swift
//  Metro WatchKit Extension
//
//  Created by John Forde on 5/07/20.
//  Copyright © 2020 John Forde. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

  // Call when the app goes to the background.
  func applicationDidEnterBackground() {
    // Schedule a background refresh task to update the complications.
    //scheduleBackgroundRefreshTasks()
    print("In the background")
    let metroDataProvider = MetroData.shared
    metroDataProvider.schedule(true)
  }

  func applicationDidFinishLaunching() {
    // Perform any final initialization of your application.
  }

  func applicationDidBecomeActive() {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillResignActive() {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
  }

  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.

    let metroDataProvider = MetroData.shared

    for task in backgroundTasks {
      // Use a switch statement to check the task type
      switch task {
        case let backgroundTask as WKApplicationRefreshBackgroundTask:
          // Be sure to complete the background task once you’re done.
          
          backgroundTask.setTaskCompletedWithSnapshot(false)
        case let snapshotTask as WKSnapshotRefreshBackgroundTask:
          // Snapshot tasks have a unique completion call, make sure to set your expiration date
          snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
        case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
          // Be sure to complete the connectivity task once you’re done.
          connectivityTask.setTaskCompletedWithSnapshot(false)
        case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
          // Be sure to complete the URL session task once you’re done.
          print("Session Refresh Background Task")
          metroDataProvider.refresh() { (update: Bool) -> Void in
            metroDataProvider.schedule(false)
            if update {
              //self.updateActiveComplications()
              print("Update Active Complications")
            }
            urlSessionTask.setTaskCompletedWithSnapshot(false)
          }


          urlSessionTask.setTaskCompletedWithSnapshot(false)
        case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
          // Be sure to complete the relevant-shortcut task once you're done.
          relevantShortcutTask.setTaskCompletedWithSnapshot(false)
        case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
          // Be sure to complete the intent-did-run task once you're done.
          intentDidRunTask.setTaskCompletedWithSnapshot(false)
        default:
          // make sure to complete unhandled task types
          task.setTaskCompletedWithSnapshot(false)
      }
    }
  }

  // MARK: - Private Methods
  // Schedule the next background refresh task.
  //  func scheduleBackgroundRefreshTasks() {
  //
  //    // Get the shared extension object.
  //    let watchExtension = WKExtension.shared()
  //
  //    // If there is a complication on the watch face, the app should get at least four
  //    // updates an hour. So calculate a target date 15 minutes in the future.
  //    let targetDate = Date().addingTimeInterval(15.0 * 60.0)
  //
  //    // Schedule the background refresh task.
  //    watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetDate, userInfo: nil) { (error) in
  //
  //      // Check for errors.
  //      if let error = error {
  //        print("*** An background refresh error occurred: \(error.localizedDescription) ***")
  //        return
  //      }
  //
  //      print("*** Background Task Completed Successfully! ***")
  //    }
  //  }

}
