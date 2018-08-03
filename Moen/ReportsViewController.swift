//
//  ReportsViewController.swift
//  Moen
//
//  Created by Turki Alqasem on 8/1/18.
//  Copyright © 2018 ETAR. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ReportsViewController: UIViewController, UITableViewDelegate , UITableViewDataSource , CLLocationManagerDelegate{

    var reportsRef: DatabaseReference!
    var reportsList = [ReportData]()

    @IBOutlet weak var reportsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportsTable.delegate = self
        reportsTable.dataSource = self
        reportsTable.backgroundColor = UIColor(red: 238, green: 238, blue: 238, alpha: 1)
      
        // Do any additional setup after loading the view.

        reportsRef = Database.database().reference().child("reports")
        reportsRef.observe(DataEventType.value, with: { (snapshot) in
            self.reportsList.removeAll()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let id = child.key
                let type = child.childSnapshot(forPath: "type").value as! String
                let description = child.childSnapshot(forPath: "description").value as! String
                let latitude = child.childSnapshot(forPath: "latitude").value as! Double
                let longitude = child.childSnapshot(forPath: "longitude").value as! Double
                let altitude = child.childSnapshot(forPath: "altitude").value as! Double
                self.reportsList.append(ReportData(id, type, description, latitude, longitude, altitude))
            }
            //update table when data is updated
            self.reportsTable.reloadData()
            
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCall") as? ReportCell
        
        switch (reportsList[indexPath.row].type) {
        case "health":
            cell?.incidentColor.backgroundColor = UIColor(red: 221, green: 0, blue: 0, alpha: 1)
            cell?.incidentType.text = "Health hazard"
            break
            
        case "unsafe":
            cell?.incidentColor.backgroundColor = UIColor(red: 255, green: 214, blue: 0, alpha: 1)
            cell?.incidentType.text = "Unsafe zone"
            break
        
            
        case "stamp":
            cell?.incidentColor.backgroundColor = UIColor(red: 255, green: 145, blue: 0, alpha: 1)
            cell?.incidentType.text = "Stamp"
            break
        default:
            print("yo")
        }
        cell?.incidentColor.layer.cornerRadius = 8
        cell?.incidentColor.layer.masksToBounds = true
        cell?.reportDescription.text = reportsList[indexPath.row].description
        cell?.reportLocation.text = "\(reportsList[indexPath.row].latitude!)\(reportsList[indexPath.row].longitude!) "
        
        cell?.setFunction {
            self.removeReport(WithId: self.reportsList[indexPath.row].id)
            print(self.reportsList[indexPath.row].id)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    


    func removeReport(WithId id: String) {
        reportsRef.child(id).removeValue()
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
