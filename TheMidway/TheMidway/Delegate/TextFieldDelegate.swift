//
//  TextFieldDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 26/01/22.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /* MARK: - Delegate */
    
    /// Essa função faz com que a tecla return do teclado faça o app aceitar a entrada e o teclado abaixe
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.returnKeyType = .done
        textField.resignFirstResponder()
        return true
    }
}
