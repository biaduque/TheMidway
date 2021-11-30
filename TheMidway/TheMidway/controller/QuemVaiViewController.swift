//
//  QuemVaiViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit


protocol QuemVaiViewControllerDelegate: AnyObject {
    func getAdress(endFriends:[String])
    func didReload()
}

class QuemVaiViewController: UIViewController {
    
    weak var delegate: QuemVaiViewControllerDelegate?
    public var teste = "oie"
    let enderecos = ["","","","",""]
    
    override func viewDidLoad() {
        print(teste)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    public func setTeste(teste: String){
        self.teste = teste
    }

   ///acao do botao que atualiza o mapa
    
    @IBAction func doneButton(_ sender: Any) {
        //essa tela retorna a lista de strings de cada endereço
        self.delegate?.getAdress(endFriends: enderecos)
        self.delegate?.didReload()
        self.navigationController?.popViewController(animated: true)
        
    }
}
