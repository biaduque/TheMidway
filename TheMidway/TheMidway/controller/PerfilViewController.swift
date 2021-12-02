//
//  PerfilViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit

class PerfilViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [PessoaBase]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = Contacts.shared.fatchContacts()
        print(contacts)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

}
extension PerfilViewController: UITableViewDelegate{}
extension PerfilViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "amigosCell", for: IndexPath(index: indexPath.row)) as! AmigosTableViewCell
        
        cell.textLabel?.text = contacts[indexPath.row].nome
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
        }
}

