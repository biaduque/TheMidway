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
            
        // Configurando informações da view
        self.mainView.setImage(name: self.mainWord)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        // Define o delegate e dataSource
//        self.mainView.setSuggestionsCollectionDelegate(self.mainCollectionDelegate)
//        self.mainView.setSuggestionsCollectionDataSource(self.mainCollectionDataSource)
//        
//        
//        self.reloadDataCollection()
    }
 
    
    
    /* MARK: - Ações dos botões */
    
    
    
    
    
    /* MARK: - Configurações */
    
    /// Recarrega os dados da CollectionView
    public func reloadDataCollection() -> Void {
        // Pega os dados do CoreData
       
    }
}
