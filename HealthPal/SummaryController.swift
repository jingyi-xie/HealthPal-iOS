//
//  SummaryController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/28.
//

import UIKit

class SummaryController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backFromNewData(_ segue: UIStoryboardSegue) {
        self.tabBarController?.selectedIndex = 0
    }

}
