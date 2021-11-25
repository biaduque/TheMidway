//
//  NovoEncontroTableViewCell.swift
//  TheMidway
//
//  Created by Beatriz Duque on 25/11/21.
//

import UIKit


class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func editTable(){
        textField.placeholder = "Título do encontro"
    }
}

// MARK: TextField
extension TextFieldCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    ///essa funcao faz com que a tecla return do teclado faca o app aceitar a entrada e o teclado abaixe
        textField.autocapitalizationType = .words
        textField.resignFirstResponder()
        return true
    }
}
