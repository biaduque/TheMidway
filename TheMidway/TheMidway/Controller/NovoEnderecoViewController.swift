//
//  NovoEnderecoViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 06/12/21.
//

import UIKit
import Contacts

class NovoEnderecoViewController: UIViewController {
    @IBOutlet weak var ruaTextField: UITextField!
    @IBOutlet weak var bairroTextField: UITextField!
    @IBOutlet weak var cidadeTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    @IBOutlet weak var paisTextField: UITextField!
    
    
    public var contact: CNContact?
    
    
//    init(newContact: CNContact){
//        self.contact = newContact
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func doneButton(_ sender: Any) {

        contact?.postalAddresses[0].value.setValue(ruaTextField.text, forKey: "street")

        contact?.postalAddresses[0].value.setValue(bairroTextField.text, forKey: "subLocality")

        contact?.postalAddresses[0].value.setValue(cidadeTextField.text, forKey: "city")

        contact?.postalAddresses[0].value.setValue(estadoTextField.text, forKey: "state")

        contact?.postalAddresses[0].value.setValue(paisTextField.text, forKey: "country")
        let saveRequest = CNSaveRequest()
        if let unsavedContact = contact?.mutableCopy() as? CNMutableContact {
            saveRequest.update(unsavedContact)
        }
        else{
            print("Nao foi possivel salvar o contato")
        }
        
//        var novo = ruaTextField.text ?? ""
//        novo = novo + bairroTextField.text!
//        novo = novo + cidadeTextField.text!
//        novo = novo + estadoTextField.text!
//        novo = novo + paisTextField.text!
//        contact?.endereco = novo
        
        self.navigationController?.popViewController(animated: true)
    }
}
