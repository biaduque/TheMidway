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
    
    func style(encontro: Encontro){
        let formatter =  DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        dateLabel.text = formatter.string(from: encontro.data ?? Date())
        
        titleLabel.text = encontro.nome
    }

}
