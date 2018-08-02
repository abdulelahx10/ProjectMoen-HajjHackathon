//
//  MapViewController.swift
//  Moen
//
//  Created by Turki Alqasem on 8/2/18.
//  Copyright © 2018 ETAR. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import CoreLocation
import ARCL

class MapViewController: UIViewController , CLLocationManagerDelegate{
    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var ARview: SceneLocationView! = SceneLocationView()
    @IBOutlet weak var sideBar: UIView!
    @IBOutlet weak var miniSideBar: UIView!
    
    var reportsRef: DatabaseReference!
    var reportsList = [ReportData]()
    var locationManager:CLLocationManager!
    var isAR:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBar.layer.cornerRadius = 8
        sideBar.layer.masksToBounds = true
        miniSideBar.layer.cornerRadius = 8
        miniSideBar.layer.masksToBounds = true
        ARview.isHidden = true
        reportsRef = Database.database().reference().child("reports")
        reportsRef.observe(DataEventType.value, with: { (snapshot) in
            self.reportsList.removeAll()
            self.MapView.clear()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                let type = child.childSnapshot(forPath: "type").value as! String
                let description = child.childSnapshot(forPath: "description").value as! String
                let latitude = child.childSnapshot(forPath: "latitude").value as! Double
                let longitude = child.childSnapshot(forPath: "longitude").value as! Double
                let altitude = child.childSnapshot(forPath: "altitude").value as! Double
                self.reportsList.append(ReportData(id, type, description, latitude, longitude, altitude))
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = "Type: " + type
                marker.snippet = description
                switch type {
                case "health":
                    marker.icon = GMSMarker.markerImage(with: .red)
                    break
                case "unsafe":
                    marker.icon = GMSMarker.markerImage(with: .yellow)
                    break
                case "stamp":
                    marker.icon = GMSMarker.markerImage(with: .orange)
                    break
                default:
                    print("yo")
                }
                marker.map = self.MapView
            }
            //update table when data is updated
            for report in self.reportsList {
                
                var marker = self.makeARmarker(latitude: report.latitude, longitude: report.longitude, altitude: report.altitude, type: report.type)
                
                self.ARview.addLocationNodeWithConfirmedLocation(locationNode: marker)
            }
        })
        let camera = GMSCameraPosition.camera(withLatitude: 21.531001, longitude: 39.216664, zoom: 6.0)
        MapView.camera = camera
        MapView.isMyLocationEnabled = true
        
        // Creates a marker in the center of the map.

    
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ARclicked(_ sender: Any) {
        
        if !isAR {
            ARview.run()
            ARview.isHidden = false
            isAR = true
            
        }else{
            ARview.pause()
            ARview.isHidden = true
            isAR = false
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
        }
    }
    func makeARmarker(latitude:Double , longitude:Double , altitude:Double , type:String) -> LocationAnnotationNode {
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude + 1.5
        )
        var annotationNode : LocationAnnotationNode!
        
        switch type {
        case "health":
            annotationNode = LocationAnnotationNode(location: location, image:#imageLiteral(resourceName: "health"))
            break
        case "unsafe":
            annotationNode = LocationAnnotationNode(location: location, image:#imageLiteral(resourceName: "unsafe"))
            break
        case "stamp":
            annotationNode = LocationAnnotationNode(location: location, image:#imageLiteral(resourceName: "stamp"))
            break
        default:
            print("yo")
        }
        
        return annotationNode
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
