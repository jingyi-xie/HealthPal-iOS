//
//  LocationController.swift
//  HealthPal
//
//  Created by Jaryn on 2020/11/7.
//

import UIKit
import MapKit
import CoreLocation

class LocationController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var idInput: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var locationTable: UITableView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        checkLocationService()
        
        idInput.delegate = self
        
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
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkPermission()
        }
        else {
            let alert = UIAlertController(title: "Warning", message: "Location Services is disabled!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkPermission() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if let location = locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 50, longitudinalMeters: 50)
                mapView.setRegion(region, animated: true)
            }
            locationManager.startUpdatingLocation()
            break
        case .denied:
            let alert = UIAlertController(title: "Warning", message: "Location Permission is denied!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
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
    
     

}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 50, longitudinalMeters: 50)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkPermission()
    }
}
