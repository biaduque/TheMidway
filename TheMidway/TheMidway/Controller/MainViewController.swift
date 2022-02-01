//
//  MainViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 18/01/22.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, MainControllerDelegate {
 
    /* MARK: - Atributos */
    
    private let mainView: MainView = MainView()
    
    // Delegate e DataSources
    private let mainTableDelegate = MainTableDelegate()
    private let mainTableDataSource = MainTableDataSource()
    
    private let mainCollectionDelegate = MainCollectionDelegate()
    private let mainCollectionDataSource = MainCollectionDataSource()
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func loadView() -> Void {
        super.loadView()
        
        self.view = self.mainView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
            
        // Configurando informações da view
        self.mainView.setTitles(
            suggestionText: "Sugestões de Locais",
            meetingText: "Meus Encontros",
            sizeFont: 30, w: .bold
        )
        
        self.mainView.newMeetingButton.addTarget(self, action: #selector(self.newMeetingAction), for: .touchDown)
        
        
        // Empty View
        let emptyViewText: String = "Você ainda não possui nenhum encontro marcado. Clique em ”+” para marcar!"
        
        self.mainView.setEmptyViewInfo(
            img: "MeetingsEmptyView",
            label: LabelConfig(text: emptyViewText, sizeFont: 15, weight: .regular),
            button: LabelConfig(text: "Criar novo encontro", sizeFont: 15, weight: .medium))
        
        self.mainView.getEmptyViewButton().addTarget(self, action: #selector(self.newMeetingAction), for: .touchDown)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        // Define o delegate e dataSource
        self.mainView.setMeetingsTableDelegate(self.mainTableDelegate)
        self.mainView.setMeetingsTableDataSource(self.mainTableDataSource)
        self.mainCollectionDelegate.setProtocol(self)
        self.mainView.setSuggestionsCollectionDelegate(self.mainCollectionDelegate)
        self.mainView.setSuggestionsCollectionDataSource(self.mainCollectionDataSource)
        
        
        self.reloadDataMeetingsTableView()
    }
    
    
    
    /* MARK: - Delegate (Protocolo) */
    
    func openSuggestionsAction(name: String) -> Void {
        let vc = SuggestionsViewController(mainWord: name)
        vc.title = "Sugestões"
        vc.modalPresentationStyle = .popover
        
        
        let navBar = UINavigationController(rootViewController: vc)
        self.present(navBar, animated: true)
    }
    
    
    
    /* MARK: - Ações dos botões */
    
    @objc private func newMeetingAction() -> Void {
        let vc = NewMeetingViewController(vc: self)
        vc.title = "Novo encontro"
        vc.modalPresentationStyle = .popover
        
        
        let navBar = UINavigationController(rootViewController: vc)
        self.present(navBar, animated: true)
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Recarrega os dados da TableView
    public func reloadDataMeetingsTableView() -> Void {
        // Pega os dados do CoreData
        let meetingCoreData = MeetingCDManeger.shared.getMeetingsCreated()
        
        // Atualiza a variável do DataSource e Delegate
        self.mainTableDataSource.setMeetings(meetingCoreData)
        self.mainTableDelegate.setMeetings(meetingCoreData)
    
        self.mainView.updateMeetingsTableData()
        
        // Verifica se precisa ativar a emptyView
        self.mainView.activateEmptyView(num: meetingCoreData.count)
    }
}
