//
//  flightCell.swift
//  ticketsReservation
//
//  Created by Victoria Samsonova on 14.05.24.
//

import Foundation
import UIKit

class flightCell: UITableViewCell {
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var comp: UILabel!
    @IBOutlet weak var pri: UILabel!
    @IBOutlet weak var durat: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        comp.text = NSLocalizedString("comp", comment: "")
        pri.text = NSLocalizedString("price", comment: "")
        durat.text = NSLocalizedString("durat", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


