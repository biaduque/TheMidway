//
//  QuandoSeraTableViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 25/11/21.
//

import UIKit

class QuandoSeraTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func stylize(){
        self.imageView?.image = UIImage(systemName: "calendar")
        self.textLabel?.text = "Quando será?"
    }
}
