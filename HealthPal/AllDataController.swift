//
//  DataController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/27.
//

import UIKit

class AllDataController: UIViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func clickHealthApp(_ sender: Any) {
        print("click health app")
        UIApplication.shared.open(URL(string: "x-apple-health://")!)

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
    
}
