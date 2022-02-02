//
//  WebViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import UIKit

class WebViewController: UIViewController {

    /* MARK: - Atributos */
    
    private let mainView = WebView()
    
    private var queryUrl: String = ""
    
    private var url = "https://www.google.com/search?q="
    
    
    
    /* MARK: -  */
    
    init(placeQuery: MapPlace) {
        super.init(nibName: nil, bundle: nil)
        
        self.queryUrl = self.createQueryString(with: placeQuery)
    }

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}


    
    /* MARK: - Ciclo de Vida */
    
    public override func loadView() -> Void {
        super.loadView()
        
        self.view = self.mainView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        self.configureNavBar()
        
        let urlString = "\(self.url)\(self.queryUrl)"
        self.mainView.setUrl(at: urlString)
    }
    
    
    
    /* MARK: - Ações dos botões */
    
    @objc private func cancelAction() -> Void {
        self.dismiss(animated: true)
    }
    
    
    
    /* MARK: - Configurações */
        
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(self.cancelAction)
        )
    }
    
    
    /// Arruma a string para
    private func createQueryString(with placeQuery: MapPlace) -> String {
        var aux: String = placeQuery.name.replacingOccurrences(of: " ", with: "+")
        aux += "+\(placeQuery.addressInfo.district)"
        aux += "+\(placeQuery.addressInfo.city)"
        return aux
    }
}
