//
//  PerfilViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit

class PerfilViewController: UIViewController {
    var contacts = [PessoaBase]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = Contacts.shared.fatchContacts()
        print(contacts)
        // Do any additional setup after loading the view.
    }

}
