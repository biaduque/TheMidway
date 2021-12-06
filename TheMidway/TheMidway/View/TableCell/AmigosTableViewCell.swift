//
//  AmigosTableViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 02/12/21.
//

import UIKit
import Contacts

protocol AmigosTableViewCellDelegate: AnyObject {
    func didTapped(newEnderecos: PessoaBase, wantAdress: Bool)
}

class AmigosTableViewCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    
    var wantsAdress: Bool = false
    var pessoa: PessoaBase?
    
    weak var delegate: AmigosTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkButtonTapped(_ sender: Any) {
        if checkButton.imageView?.image == (UIImage(systemName: "circle")){
            //se nao estiver clicado
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            wantsAdress = true
            
        }
        else{
            //se estiver clicado
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            wantsAdress = false
        }
        delegate?.didTapped(newEnderecos: pessoa ?? PessoaBase(nome: "Sem nome", endereco: "sem endereco", icone: "icone1", source: CNContact(),id: "base"), wantAdress: self.wantsAdress)
    }
    
    public func content(newPessoa: PessoaBase){
        self.pessoa = newPessoa
    }
    public func getAdress()-> Bool {
        return wantsAdress
    }
}
