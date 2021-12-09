//
//  QuemVaiViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit
import Contacts
import ContactsUI


protocol QuemVaiViewControllerDelegate: AnyObject {
    func getAdress(endFriends:[String])
    func getPessoas(newPessoas: [PessoaBase])
    func didReload()
    func getLocations()
}

class QuemVaiViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: QuemVaiViewControllerDelegate?
    
    public var enderecos: [String] = []
    
    var contacts = [PessoaBase]()
    
    var noAdress: Bool?
    
    var noAdressPerson: PessoaBase?

    private lazy var imagePerfil = ["perfil1","perfil2","perfil3","perfil4","perfil5","perfil6","perfil7","perfil8"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    
   ///acao do botao que atualiza o mapa
    @IBAction func doneButton(_ sender: Any) {
        //essa tela retorna a lista de strings de cada endereço
        print("teste:", enderecos)
        self.delegate?.getAdress(endFriends: enderecos)
        self.delegate?.getPessoas(newPessoas: contacts)
        self.delegate?.getLocations()
        self.delegate?.didReload()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func addButton(_ sender: Any) {
        let contactViewController = CNContactPickerViewController()
        contactViewController.delegate = self
        self.present(contactViewController, animated: true)
        
    }
    
    // MARK: Contact Picker
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let nome = contact.givenName
        ///verificando a existencia de endereco
        let icone = "icone1"
        let source = contact
        let id = contact.identifier
        
        let endereco = contact.postalAddresses
        
        ///se a rua nao for vazia, ele considera o endereco
        if endereco[0].value.street != "" {
            let model = PessoaBase(nome: nome, endereco: getString(postalAdress: endereco), icone: icone, source: source, id: id)
            contacts.append(model)
        }
        else{
            noAdress = true
            let model = PessoaBase(nome: nome, endereco: "", icone: icone, source: source, id: id)
            noAdressPerson = model
            //contacts.append(model)
        }
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if let vc = storyboard?.instantiateViewController(identifier: "novoEncontro") as?
                    NovoEncontroViewController {
            vc.collectionView?.reloadData()
        }
    }
    
    // MARK: Adiciona endereco no vetor
    func addAdress(newEndereco: PessoaBase, wantAdress: Int){
        for endereco in enderecos{
            if newEndereco.endereco == endereco{
                ///se o endereco ja estiver adicionado, nao adiciona novamente
                return
            }
        }
        self.enderecos.append(contacts[wantAdress].endereco)
        print("testando",enderecos)
    }
    
    @objc func cancelButton() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: Conversao de postal para string
    func getString(postalAdress: [CNLabeledValue<CNPostalAddress>]) -> String{
        var string = postalAdress[0].value.street
        string = string + "," + postalAdress[0].value.subLocality
        string = string + " " + postalAdress[0].value.city
        string = string + "-" + postalAdress[0].value.state
        string  = string + "," + postalAdress[0].value.country
        return string
    }
    
    // MARK: Adicionar novo endereco
    func didTapped(newEnderecos: PessoaBase, wantAdress: Int) {
            //se o endereco for vazio, o app da a oportunidade da pessoa adicionar um endereço
            if newEnderecos.endereco == ""{
                let ac = UIAlertController(title: "Ops! Endereço não cadastrado", message: "Não encontramos um endereço cadastrado para esse Amigo. Deseja adicionar um novo endereço?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        [weak self] action in
                    //abre a viewController de adicionar endereco
                    var contact = newEnderecos.source
                    if !contact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
                        do {
                            let storeC = CNContactStore()
                            contact = try storeC.unifiedContact(withIdentifier: contact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
                        }
                        catch { }
                    }
                    let viewControllerforContact = CNContactViewController(for: contact)
                    viewControllerforContact.delegate = self
                    viewControllerforContact.navigationItem.leftBarButtonItem = UIBarButtonItem(
                        barButtonSystemItem: .done, target: self, action: #selector(self?.cancelButton)
                    )
                    self?.present(UINavigationController(rootViewController: viewControllerforContact),animated: true)
                    
                }))
                ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                present(ac, animated: true)
        }
        tableView.reloadData()
    }
}

// MARK: Table View
extension QuemVaiViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///clique na celula
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension QuemVaiViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "amigosCell", for: IndexPath(index: indexPath.row)) as! AmigosTableViewCell
        cell.delegate = self
        if contacts.count != 0 {
            cell.content(newPessoa: contacts[indexPath.row])
            cell.textLabel?.text = contacts[indexPath.row].nome
            cell.imageView?.image = UIImage(named: imagePerfil[Int.random(in: 0..<imagePerfil.count)])
            if noAdress == true {
                didTapped(newEnderecos: noAdressPerson!, wantAdress: indexPath.row)
                noAdress = false
                //contacts.append(noAdressPerson!)
            }
            addAdress(newEndereco: contacts[indexPath.row], wantAdress: indexPath.row)

        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                   // Deleta esse item aqui
                   completionHandler(true)
            self.contacts.remove(at: indexPath.row)
            self.enderecos.remove(at: indexPath.row)
            tableView.reloadData()
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}

extension QuemVaiViewController: AmigosTableViewCellDelegate{
    
}
