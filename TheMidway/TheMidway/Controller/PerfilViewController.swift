//
//  PerfilViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit
import ContactsUI
import Contacts

class PerfilViewController: UIViewController, CNContactPickerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [PessoaBase]()
    
    private lazy var imagePerfil = ["perfil1","perfil2","perfil3","perfil4","perfil5","perfil6","perfil7","perfil8"]
    
    override func viewWillAppear(_ animated: Bool) {
        contacts = Contacts.shared.fatchContacts()
        print(contacts)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        tableView.reloadInputViews()
        tableView.reloadData()
    }

}
extension PerfilViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///clique na celula
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
        
        ///lembrar de pedir permissao para isso
    
        let contact = contacts[indexPath.row].source
        let vc  = CNContactViewController(for: contact)
        present(UINavigationController(rootViewController: vc),animated: true)
    }
}


extension PerfilViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "amigosCell", for: IndexPath(index: indexPath.row)) as! AmigosTableViewCell
        
        cell.textLabel?.text = contacts[indexPath.row].nome
        cell.imageView?.image = UIImage(named: imagePerfil[Int.random(in: 0..<imagePerfil.count)])
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
        }
}

