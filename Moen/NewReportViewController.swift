//
//  NewReportViewController.swift
//  Moen
//
//  Created by Turki Alqasem on 8/2/18.
//  Copyright © 2018 ETAR. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import GoogleMaps

class NewReportViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var currentType = "health"
    let type = ["health","unsafe","stamp"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentType = type[row]
    }
    
    var reportsRef: DatabaseReference!
    
    var locationManager:CLLocationManager!
    var currentLat:Double!
    var currentLon:Double!
    var currentAlt:Double!
    
    @IBOutlet weak var mapMarker: UIImageView!
    @IBOutlet weak var MapView: GMSMapView!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var selectType: UIPickerView!
    @IBOutlet weak var tapArounbttn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        picker.delegate = self
        picker.dataSource = self
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        reportsRef = Database.database().reference().child("reports")
        MapView.isMyLocationEnabled = true
        if(locationManager.location?.coordinate != nil){
            MapView.camera = GMSCameraPosition.camera(withLatitude:         (locationManager.location?.coordinate.latitude)!, longitude:         (locationManager.location?.coordinate.longitude)!, zoom: 15)
        }
        mapMarker.layer.zPosition = 999

    }
    override func viewDidAppear(_ animated: Bool) {
        if(locationManager.location?.coordinate != nil){
            MapView.camera = GMSCameraPosition.camera(withLatitude:         (locationManager.location?.coordinate.latitude)!, longitude:         (locationManager.location?.coordinate.longitude)!, zoom: 15)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var textfield: UITextField!
    @IBAction func sendReports(_ sender: Any) {
        submitReport(WithType: currentType, description: textfield.text!, latitude: MapView.camera.target.latitude, longitude: MapView.camera.target.longitude, altitude: currentAlt)
        self.navigationController?.popViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            currentLat = location.coordinate.latitude
            currentLon = location.coordinate.longitude
            currentAlt = location.altitude
        }
    }
    
    func submitReport(WithType type: String, description desc: String, latitude lat: Double, longitude long: Double, altitude alt: Double) {
        let ref = reportsRef.childByAutoId()
        let report = ["type": type,
                      "description": desc,
                      "latitude": lat,
                      "longitude": long,
                      "altitude": alt] as [String : Any]
        ref.setValue(report)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        UIView.animate(withDuration: 0.25) {
        //
        //
        //            self.messageViewHC.constant =  self.keyboardHeight!//308
        //            self.view.layoutIfNeeded()
        //        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //        UIView.animate(withDuration: 0.25) {
        //            self.messageViewHC.constant = 50
        //            self.view.layoutIfNeeded()
        //
        //        }
        ////        tapButton.isHidden = true
        //        scrollLastCell()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
