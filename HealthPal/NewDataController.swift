//
//  NewDataController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/27.
//

import UIKit
import CoreData
import HealthKit

class NewDataController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var TypeSegControl: UISegmentedControl!
    @IBOutlet weak var ValueInput: UITextField!
    @IBOutlet weak var UnitInput: UITextField!
    @IBOutlet weak var ValueLabel: UILabel!
    @IBOutlet weak var UnitLabel: UILabel!
    
    // context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // health kit store
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    // picker view for unit
    let units = ["lbs", "kg"]
    var unitPickerView = UIPickerView()
    
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
        
        // set up delegate of picker views
        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        UnitInput.inputView = unitPickerView
        UnitInput.text = "lbs"
        
        checkHealthPermission()
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
            if (self.ValueInput.text == "" || self.UnitInput.text == "" || Int64(self.ValueInput.text!) == nil) {
                self.showAlert(title: "Warning", message: "Please provide a valid value and unit")
                return
            }
            createNewWeight(value: Int64(self.ValueInput.text!)!, unit: self.UnitInput.text!)
        }
        // hand washing
        else {
            createNewHandwashing()
        }
        do {
            try self.context.save()
            self.ValueInput.text = ""
            self.UnitInput.text = "lbs"
            self.performSegue(withIdentifier: "returnToSummary", sender: self)
            self.showAlert(title: "Success", message: "New Data Added!")
        }
        catch {
            self.showAlert(title: "Error", message: "Failed to save data!")
            self.ValueInput.text = ""
            self.UnitInput.text = "lbs"
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkHealthPermission() {
        if !HKHealthStore.isHealthDataAvailable() {
            print("health data not available on the device")
            return
        }
        let obj1: HKObjectType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let obj2: HKObjectType = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.handwashingEvent)!
        if healthKitStore.authorizationStatus(for: obj1) != HKAuthorizationStatus.sharingAuthorized || healthKitStore.authorizationStatus(for: obj2) != HKAuthorizationStatus.sharingAuthorized {
            let toRead: Set<HKObjectType> = []
            let toWrite: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!, HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.handwashingEvent)!]
            healthKitStore.requestAuthorization(toShare: toWrite, read: toRead){(success, error) -> Void in print("Authorization success")}
        }
    }
    
    func createNewWeight(value: Int64, unit: String) {
        let newWeightData = WeightData(context: context)
        newWeightData.value = value
        newWeightData.unit = unit
        newWeightData.date = Date()
        saveWeightToHealth(value: value, unitStr: unit)
    }
    
    func saveWeightToHealth(value: Int64, unitStr: String) {
        if !HKHealthStore.isHealthDataAvailable() {
            print("health data not available on the device")
            return
        }
        let weight = unitStr == "lbs" ? Double(value) : Double(value) * 2.2
        let today = Date()
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) {
            let quantity = HKQuantity(unit: HKUnit.pound(), doubleValue: weight)
            let data = HKQuantitySample(type: type, quantity: quantity, start: today, end: today)
            healthKitStore.save(data) {(success, error) -> Void in
                print("Saved new weight data")
            }
        }
    }
    
    func createNewHandwashing() {
        var washData: [HandWashData] = []
        var targetData: HandWashData? = nil
        do {
            washData = try context.fetch(HandWashData.fetchRequest())
        }
        catch {
            print("Failed to fetch handwashing data")
        }
        let calendar = Calendar.current
        for data in washData {
            if calendar.isDateInToday(data.date!) {
                targetData = data
                break
            }
        }
        if targetData != nil {
            targetData?.times += 1
        }
        else {
            let newHandWashData = HandWashData(context: context)
            newHandWashData.times = 1
            newHandWashData.date = Date()
        }
        saveHandwashingToHealth()
    }
    
    func saveHandwashingToHealth() {
        if !HKHealthStore.isHealthDataAvailable() {
            print("health data not available on the device")
            return
        }
        let today = Date()
        if let type = HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.handwashingEvent) {
            let data = HKCategorySample(type: type, value: HKCategoryValue.notApplicable.rawValue, start: today, end: today + 20)
            healthKitStore.save(data) {(success, error) -> Void in
                print("Saved handwashing data")
            }
        }
    }
    
    
    // MARK: - picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UnitInput.text = units[row]
        UnitInput.resignFirstResponder()
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
