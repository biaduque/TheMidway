//
//  OndeSeraTableViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 25/11/21.
//

import UIKit

class QuemVaiTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    public func stylize(){
        self.imageView?.image = UIImage(systemName: "person.fill")!
        self.textLabel?.text = "Quem vai?"
    }

}
