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

}
