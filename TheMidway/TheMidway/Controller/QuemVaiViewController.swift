//
//  QuemVaiViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit
import Contacts


protocol QuemVaiViewControllerDelegate: AnyObject {
    func getAdress(endFriends:[String])
    func didReload()
    func getLocations()
}

class QuemVaiViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: QuemVaiViewControllerDelegate?
    
    public var enderecos: [String] = []
    
    var contacts = [PessoaBase]()

    private lazy var imagePerfil = ["perfil1","perfil2","perfil3","perfil4","perfil5","perfil6","perfil7","perfil8"]
    
    override func viewWillAppear(_ animated: Bool) {
        contacts = Contacts.shared.fatchContacts()
    }
    
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
        self.delegate?.getLocations()
        self.delegate?.didReload()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let vc = storyboard?.instantiateViewController(identifier: "novoEncontro") as?
                    NovoEncontroViewController {
            vc.collectionView?.reloadData()
        }
    }
}


extension QuemVaiViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///clique na celula
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}


extension QuemVaiViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "amigosCell", for: IndexPath(index: indexPath.row)) as! AmigosTableViewCell
        cell.delegate = self
        cell.content(newPessoa: contacts[indexPath.row])
        cell.textLabel?.text = contacts[indexPath.row].nome
        cell.imageView?.image = UIImage(named: imagePerfil[Int.random(in: 0..<imagePerfil.count)])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
        }
}

extension QuemVaiViewController: AmigosTableViewCellDelegate{
    func didTapped(newEnderecos: PessoaBase, wantAdress: Bool) {
        let adress = wantAdress
        
        if (adress == true){
            //se o endereco for vazio, o app da a oportunidade da pessoa adicionar um endereço
            if newEnderecos.endereco == ""{
                let ac = UIAlertController(title: "Ops! Endereço não cadastrado", message: "Não encontramos um endereço cadastrado para esse Amigo. Deseja adicionar um novo endereço?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        [weak self] action in
                    //abre a viewController de adicionar endereco
                    if let vc = self?.storyboard?.instantiateViewController(identifier: "novoEndereco") as?
                                NovoEnderecoViewController {
                        vc.contact = newEnderecos.source
                        //self.collectionView?.reloadData()
                        self?.navigationController?.pushViewController(vc, animated: true)
                        }
                }))
                ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                present(ac, animated: true)
            }
            self.enderecos.append(newEnderecos.endereco)
            
        }
        
        else{
            //se a pessoa remove a selecao do amigo, esse endereco é removido do vetor de enderecos
            for i in 0..<self.enderecos.count{
                if self.enderecos[i] == newEnderecos.endereco{
                    self.enderecos.remove(at: i)
                }
            }
        }
    }
}
