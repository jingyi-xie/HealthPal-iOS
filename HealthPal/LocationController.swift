//
//  LocationController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/11/7.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class LocationController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var idInput: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var locationTable: UITableView!
    
    let locationManager = CLLocationManager()
    var savedLocations = [LocationData]()
    
    
    // context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        checkLocationService()
        
        idInput.delegate = self
        
        // tap gesture to dismiss the keyboard
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(Tap);
        
        // location table
        locationTable.delegate = self
        locationTable.dataSource = self
        updateTable()
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
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkPermission()
        }
        else {
            showAlert(title: "Warning", message: "Location Services is disabled!")
        }
    }
    
    func checkPermission() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 75, longitudinalMeters: 75)
                mapView.setRegion(region, animated: true)
            }
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlert(title: "Warning", message: "Location Permission is denied!")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("unknown permission status")
        }
    }
    
    func updateTable() {
        do {
            self.savedLocations = try context.fetch(LocationData.fetchRequest())
        }
        catch {
            print("Failed to fetch core data")
        }
        self.locationTable.reloadData()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickAddBtn(_ sender: Any) {
        if self.locationManager.location == nil { return }
        if self.idInput.text == "" {
            showAlert(title: "Error", message: "Please provide a name for current location!")
            return
        }
        let newLocationData = LocationData(context: context)
        let name = self.idInput.text!
        let latitude = self.locationManager.location!.coordinate.latitude
        let longitude = self.locationManager.location!.coordinate.longitude
        newLocationData.name = name
        newLocationData.latitude = latitude
        newLocationData.longitude = longitude
        configureWashNotification(latitude: latitude, longitude: longitude, identifier: name)
        do {
            try self.context.save()
            self.idInput.text = ""
            self.showAlert(title: "Success", message: "New Location Added!")
            updateTable()
        }
        catch {
            self.showAlert(title: "Error", message: "Failed to save data!")
            self.idInput.text = ""
        }
    }
    
    func configureWashNotification(latitude: Double, longitude: Double, identifier: String) {
        
    }
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 75, longitudinalMeters: 75)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermission()
    }
}

extension LocationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension LocationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTable.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableCell
        cell.nameLabel.text = savedLocations[indexPath.row].name
        return cell
    }
}
