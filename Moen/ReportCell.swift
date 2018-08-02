//
//  ReportCell.swift
//  Moen
//
//  Created by Turki Alqasem on 8/1/18.
//  Copyright © 2018 ETAR. All rights reserved.
//

import UIKit

class ReportCell: UITableViewCell {

    @IBOutlet weak var incidentColor: UIView!
    @IBOutlet weak var incidentType: UILabel!
    @IBOutlet weak var reportDescription: UILabel!
    @IBOutlet weak var reportLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    var buttonFunc: (() -> (Void))!
    @IBAction func solved(_ sender: UIButton) {
        buttonFunc()
    }
    func setFunction(_ function: @escaping () -> Void){
        self.buttonFunc = function
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
