# HealthPal

### Key features
1. Weight management: 
    * add new data on phone (use keyboard) and watch (rotate the crown)
    * see all history data on phone in charts and table
    * support different measurement units (lbs and kg)
    * receive daily notification at 11 AM on watch and phone to record weight data 
2. Handwashing
    * add new record on phone and watch
    * see all history data on phone in charts and table
    * a 20 seconds timer on the watch
    * receive notification when entered customized locations(see handwashing -> Locations)
3. HealthKit
    * Automatically sync the data to the native health app on iPhone(click "view in health app" or "open health app")

### Highlights
* iPhone app(UIKit) with a companion watch app(WatchKit)
* use core data to store all the information
* display all the history data in charts and show the average in a dotted line
* use UserNotifications framework to implement time and location based local notifications
* use WatchConnectivity framework to implement communication between the phone and watch
* use HealthKit to integrate with the native Health app on the phone
* use MapKit and CoreLocation to show and store the user's current location

### How to Test
* **Please use iPhone 12 and Apple Watch series 5 - 44mm for testing**
* **Please give permission for notification and location**
* On the iphone simulator, go to the "Watch" app, scroll down and make sure the HealthPal app is installed on the watch.
* On the iphone simulator, go to "Watch"->"Notifications", make sure the notification of HealthPal is mirrored to the watch.

1.  Weight management:
* add new record on Phone: click "New Data" in the tab bar, choose "Weight" and then enter the value and choose the measurement units
* add new record on watch: **Please open the app on iPhone to ensure the communication**. Click "weight" on watch and then rotate the digital crown to change the value, then click add. Then, you can click "Weight" on the phone app to see the new record
* daily notification: The time of the notification is hard coded in `SummaryController` on Line 112 - 114. If the screen of the phone simulator is on and the app is in the background, you'll see the notification on the phone. To receive notification on the watch, make sure the screen of the phone simulator is locked.

2. Handwashing:
* add new record on Phone: click "New Data" in the tab bar, choose "handwashing" and submit
* add new record on watch: **Please open the app on iPhone to ensure the communication**. Click "handwashing" on watch and then there is a 20 seconds timer. When the timer is finished, you'll be redirected to the home screen on the watch. Then, you can click "Handwashing" on the phone app to see the new record (times of today incremented by 1)
* location notification: On the phone app, go to "Handwashing"->"Locations", you should see the map. Go to Xcode and go to "Debug"->"Simulate Locations", choose "Hudson Hall". Then go back to the simulator and you should see the location in the map. Now input a name and click "Add current Location". Now go back to Xcode and change the location to "Duke Chapel", then change it back to "Hudson Hall" and you'll receive a notification on the simulator.

3. HealthKit
* Weight: add a new record first. Then on the Phone simulator, go to "Weight"->"See in Health App", then go to "Browse"->"Body Measurements"->"Weight"
* Handwashing: add a new record first. Then on the Phone simulator, go to "Handwashing"->"See in Health App", then go to "Browse"->"Other Data"->"Handwashing"