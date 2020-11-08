//
//  SummaryController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/28.
//

import UIKit
import WatchConnectivity
import UserNotifications


class SummaryController: UIViewController, WCSessionDelegate {

    var session: WCSession!
    let newController = NewDataController()
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        
        // Ask for notification permission
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        configureWeightNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! DetailController
        if(segue.identifier == "clickWeight"){
            dest.type = "weight"
            dest.navigationItem.title = "Weight Data"
        }
        else if(segue.identifier == "clickHand"){
            dest.type = "hand"
            dest.navigationItem.title = "Handwashing Data"
        }
    }

    @IBAction func backFromNewData(_ segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 0
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received a message on phone")
        if message["type"] as! String == "wash" {
            DispatchQueue.main.async {
                self.newController.createNewHandwashing()
            }
        }
        else if message["type"] as! String == "weight" {
            let value = message["value"] as! Int64
            DispatchQueue.main.async {
                self.newController.createNewWeight(value: value, unit: "lbs")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activation completed")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func configureWeightNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to weight!"
        content.body = "Click to add new data."
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        // get notification at 11am
        dateComponents.hour = 0
        dateComponents.minute = 53
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weight", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
}
