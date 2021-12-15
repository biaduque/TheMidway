//
//  SugestoesCollectionViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 14/12/21.
//

import UIKit
protocol SugestoesCollectionViewCellDelegate: AnyObject{
    func changeLocal(local: String)
}

class SugestoesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var setButton: UIButton!
    
    weak public var delegate: SugestoesCollectionViewCellDelegate?
    
    let images = ["Bakery", "Bar", "Cinema", "Coffee", "Restaurant", "Shopping", "Theater"]

    let names = ["Padaria", "Bar", "Cinema", "Café", "Restaurante", "Shopping", "Teatro"]
    
    public let nomeLocalArray = ["Mercatto",
                          "Igrejinha Bar",
                          "Cinépollis",
                          "Starbucks",
                          "Bananeira",
                          "Eldorado",
                          "Theatro Municipal do RJ"
                        ]
    public let enderecos = ["Av. Nascimento de Castro, 1890 - Lagoa Nova, Natal - RN, 59056-450",
        "Rua Fernando de Albuquerque - SP, BR - Consolação",
        "Alameda Rio Negro - Iguatemi, SP - Alphaville",
        "Kalanderpl. 1, 8045 Zürich - ZH, Wiedikon",
        "R. Mal. Hastimphilo de Moura,419 - SP, Morumbi",
        "Av. Rebouças,  3970 - SP, Pinheiros",
        "Praça Floriano, S/N - Centro, Rio de Janeiro - RJ, 20031-050, Brasil"
    ]
    
    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var nomeLocal: UILabel!
    
    
    func stylize(index: Int){
        imageBackground.image = UIImage(named: images[index])
        imageBackground.layer.cornerRadius = 8
        labelNome.text = names[index]
        nomeLocal.text = nomeLocalArray[index]
        enderecoLabel.text = enderecos[index]
    }
    func didChange() {
        if setButton.imageView?.image == UIImage(systemName: "circle"){
            setButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        else{
            setButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    func desativate(){
        setButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
}
