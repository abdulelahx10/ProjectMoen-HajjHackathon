//
//  ViewController.swift
//  Moen
//
//  Created by Abdulelah Alshalhoub on 01/08/2018.
//  Copyright © 2018 ETAR. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var Map: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        Map.camera = camera
        //let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        //view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = Map
        Map.isMyLocationEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
}


