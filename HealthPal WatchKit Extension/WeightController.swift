//
//  WeightController.swift
//  HealthPal WatchKit Extension
//
//  Created by Jaryn on 2020/11/6.
//

import WatchKit
import Foundation
import WatchConnectivity


class WeightController: WKInterfaceController, WCSessionDelegate, WKCrownDelegate {

    @IBOutlet weak var numLabel: WKInterfaceLabel!
    
    var session: WCSession!
    var weightValue = 100
    let expectedMoveDelta = 0.523599 // 30° Degree
    var crownRotationalDelta = 0.0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        crownSequencer.delegate = self
        crownSequencer.focus()
        numLabel.setText("100 lbs")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        crownRotationalDelta  += rotationalDelta
        if crownRotationalDelta > expectedMoveDelta {
            weightValue += 1
            crownRotationalDelta = 0.0
        }
        else if crownRotationalDelta < -expectedMoveDelta {
            weightValue -= 1
            crownRotationalDelta = 0.0
        }
        if weightValue < 0 {
            weightValue = 0
        }
        numLabel.setText("\(weightValue) lbs")

    }
    
    
    @IBAction func clickAddBtn() {
        // send message to phone app
        if WCSession.isSupported() {
            session.sendMessage(["type": "weight", "value": Int64(weightValue)], replyHandler: nil, errorHandler: nil)
            print("sent weight data to phone")
        }
        self.pop()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activation completed")
    }

}
