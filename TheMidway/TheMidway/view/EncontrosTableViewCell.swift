//
//  EncontrosTableViewCell.swift
//  TheMidway
//
//  Created by Felipe Leite on 02/12/21.
//

import UIKit

class EncontrosTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var friendsLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
