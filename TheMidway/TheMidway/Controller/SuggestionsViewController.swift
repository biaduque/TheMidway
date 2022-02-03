//
//  SuggestionsViewController.swift
//  TheMidway
//
//  Created by Leticia Utsunomiya on 01/02/22.
//

import UIKit
import CoreLocation

class SuggestionsViewController: UIViewController {

    /* MARK: - Atributos */
    
    private let mainView = SuggestionsView()
    private var mainWord: String = ""
    
    // Delegate e DataSources
    private let mainCollectionDelegate = MainCollectionDelegate()
    private let mainCollectionDataSource = MainCollectionDataSource()
    
    
    
    /* MARK: -  */
    
    init(mainWord: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.mainWord = mainWord
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
        
        self.mainView.setImage(name: self.mainWord)
        
        
        // Empty View
        let emptyViewText: String = "Poxa, não foi possível te mandar as nossas sugestões. Tente novamente mais tarde"
        
        self.mainView.setEmptyViewInfo(
            img: "PlacesEmptyView",
            label: LabelConfig(text: emptyViewText, sizeFont: 20, weight: .regular),
            button: LabelConfig(text: "", sizeFont: 15, weight: .medium)
        )
        self.mainView.activateEmptyView(num: 0)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        // Define o delegate e dataSource
    }
 
    
    
    /* MARK: - Ações dos botões */
    
    @objc private func cancelAction() -> Void {
        self.dismiss(animated: true)
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Recarrega os dados da CollectionView
    public func reloadCollectionData() -> Void {
        
       
    }
    
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        self.title = "Sugestões"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancelar",
            style: .plain,
            target: self,
            action: #selector(self.cancelAction)
        )
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
}
