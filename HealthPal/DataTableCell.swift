//
//  DataTableCell.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/28.
//

import UIKit

class DataTableCell: UITableViewCell {
    
    @IBOutlet weak var dataImg: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
