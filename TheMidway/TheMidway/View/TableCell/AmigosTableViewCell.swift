//
//  AmigosTableViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 02/12/21.
//

import UIKit
import Contacts

protocol AmigosTableViewCellDelegate: AnyObject {
}

class AmigosTableViewCell: UITableViewCell {
    
    var wantsAdress: Bool = false
    var pessoa: PessoaBase?
    
    weak var delegate: AmigosTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    public func content(newPessoa: PessoaBase){
        self.pessoa = newPessoa
    }
    public func getAdress()-> Bool {
        return wantsAdress
    }
}
