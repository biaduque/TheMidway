//
//  AmigosTableViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 02/12/21.
//

import UIKit

protocol AmigosTableViewCellDelegate: AnyObject {
    func didTapped(newEnderecos: String, wantAdress: Bool)
}

class AmigosTableViewCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    
    var wantsAdress: Bool = false
    var pessoa = PessoaBase(nome: "Bia", endereco: "Teste", icone: "perfil")
    
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
        delegate?.didTapped(newEnderecos: pessoa.endereco, wantAdress: self.wantsAdress)
    }
    
    public func content(newPessoa: PessoaBase){
        self.pessoa = newPessoa
    }
    public func getAdress()-> Bool {
        return wantsAdress
    }
}
