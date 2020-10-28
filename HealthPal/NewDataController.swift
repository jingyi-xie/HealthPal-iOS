//
//  NewDataController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/27.
//

import UIKit

class NewDataController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var TypeSegControl: UISegmentedControl!
    @IBOutlet weak var ValueInput: UITextField!
    @IBOutlet weak var UnitInput: UITextField!
    @IBOutlet weak var ValueLabel: UILabel!
    @IBOutlet weak var UnitLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ValueInput.delegate = self
        UnitInput.delegate = self
        ValueInput.addDoneButtonToKeyboard(myAction:  #selector(self.ValueInput.resignFirstResponder))
        self.ValueInput.keyboardType = .asciiCapableNumberPad
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
        if segControl.selectedSegmentIndex == 0 {
            self.ValueLabel.isHidden = false
            self.ValueInput.isHidden = false
            self.UnitLabel.isHidden = false
            self.UnitInput.isHidden = false
        }
        else {
            self.ValueLabel.isHidden = true
            self.ValueInput.isHidden = true
            self.UnitLabel.isHidden = true
            self.UnitInput.isHidden = true
        }
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
