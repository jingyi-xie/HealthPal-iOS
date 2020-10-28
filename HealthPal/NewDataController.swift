//
//  NewDataController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/27.
//

import UIKit
import CoreData

class NewDataController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var TypeSegControl: UISegmentedControl!
    @IBOutlet weak var ValueInput: UITextField!
    @IBOutlet weak var UnitInput: UITextField!
    @IBOutlet weak var ValueLabel: UILabel!
    @IBOutlet weak var UnitLabel: UILabel!
    
    // context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ValueInput.delegate = self
        UnitInput.delegate = self
        
        // add "Done" to value input keyboard
        ValueInput.addDoneButtonToKeyboard(myAction:  #selector(self.ValueInput.resignFirstResponder))
        // only use numeric keyboard on value input
        self.ValueInput.keyboardType = .asciiCapableNumberPad
        
        // tap gesture to dismiss the keyboard
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(Tap);
    }
    
    // when click anywhere outside of the keyboard, dismiss the keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // when click "return" on the keyboard, dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func changeDataType(_ sender: Any) {
        guard let segControl = sender as? UISegmentedControl else {
            return
        }
        // weight
        if segControl.selectedSegmentIndex == 0 {
            self.ValueLabel.isHidden = false
            self.ValueInput.isHidden = false
            self.UnitLabel.isHidden = false
            self.UnitInput.isHidden = false
        }
        // hand washing
        else {
            self.ValueLabel.isHidden = true
            self.ValueInput.isHidden = true
            self.UnitLabel.isHidden = true
            self.UnitInput.isHidden = true
        }
    }
    
    @IBAction func clickSubmit(_ sender: Any) {
        // weight
        if self.TypeSegControl.selectedSegmentIndex == 0 {
            if (self.ValueInput.text == "" || self.UnitInput.text == "") {
                self.showAlert(title: "Warning", message: "Please provide a valid value and unit")
                return
            }
            let newWeightData = WeightData(context: context)
            newWeightData.value = Int64(self.ValueInput.text!)!
            newWeightData.unit = self.UnitInput.text
            newWeightData.time = Date()
        }
        // hand washing
        else {
            let newHandWashData = HandWashData(context: context)
            newHandWashData.time = Date()
        }
        do {
            try self.context.save()
            self.ValueInput.text = ""
            self.UnitInput.text = ""
            self.performSegue(withIdentifier: "returnToSummary", sender: self)
            self.showAlert(title: "Success", message: "New Data Added!")
        }
        catch {
            self.showAlert(title: "Error", message: "Failed to save data!")
            self.ValueInput.text = ""
            self.UnitInput.text = ""
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// source: https://stackoverflow.com/questions/38133853/
extension UITextField{

    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }
}
