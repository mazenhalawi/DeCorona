//
//  DirectionCell.swift
//  DeCorona
//
//  Created by Mazen on 11/30/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class DirectionCell: UITableViewCell {

    @IBOutlet weak var imgIcon:UIImageView!
    @IBOutlet weak var lblDirection:UILabel!
    @IBOutlet weak var container:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.selectionStyle = .none
    }
    
    func configure(step: Int, content: String, condition: StatusCondition) {
        switch step {
        case 1: imgIcon.image = #imageLiteral(resourceName: "step_one")
        case 2: imgIcon.image = #imageLiteral(resourceName: "step_two")
        case 3: imgIcon.image = #imageLiteral(resourceName: "step_three")
        default: imgIcon.image = nil
        }
        
        lblDirection.text = content
        
        self.container.backgroundColor = condition.color

    }
    
}
