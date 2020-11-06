//
//  WashController.swift
//  HealthPal WatchKit Extension
//
//  Created by Jaryn on 2020/11/6.
//

import WatchKit
import Foundation


class WashController: WKInterfaceController {

    @IBOutlet weak var timer: WKInterfaceTimer!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let _ = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(timerEnded), userInfo: nil, repeats: false)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.timer.setDate(Date(timeIntervalSinceNow: 20))
        self.timer.start()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @objc func timerEnded() {
        // send message to phone app
        self.pop()
    }
    
    

}
