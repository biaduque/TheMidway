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
    
    private var allMeetingsData: [Meetings] = MeetingCDManeger.shared.getMeetingsCreated()
    
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
        
        self.mainTableDelegate.setProtocol(self)
        self.mainTableDataSource.setProtocol(self)
        self.mainCollectionDelegate.setProtocol(self)
        
        // Define o delegate e dataSource
        self.mainView.setMeetingsTableDelegate(self.mainTableDelegate)
        self.mainView.setMeetingsTableDataSource(self.mainTableDataSource)
        
        self.mainView.setSuggestionsCollectionDelegate(self.mainCollectionDelegate)
        self.mainView.setSuggestionsCollectionDataSource(self.mainCollectionDataSource)
        
        
        self.reloadMeetingsTableData()
    }
    
    
    
    /* MARK: - Delegate (Protocolo) */
    
    /// Abre a área de sugestões
    internal func openSuggestionsAction(name: String) -> Void {
        let vc = SuggestionsViewController(mainWord: name, delegate: self)
        self.showViewController(with: vc)
    }
    
    
    /// Abre a  página do encontro
    internal func openMeetingPageAction(meetingInfo: MeetingCompleteInfo) -> Void {
        let vc = MeetingPageViewController(meetingInfo: meetingInfo, delegate: self)
        self.showViewController(with: vc)
    }
    
    
    /// Atualiza os dados da tabela e as informações vindas do Core Data
    internal func reloadMeetingsTableData() -> Void {
        self.allMeetingsData = MeetingCDManeger.shared.getMeetingsCreated()
        
        self.mainView.updateMeetingsTableData()
        
        // Verifica se precisa ativar a emptyView
        self.mainView.activateEmptyView(num: self.allMeetingsData.count)
    }
    
    
    /// Retorna os encontros do Core Data
    internal func getMeeting() -> [Meetings] {
        return self.allMeetingsData
    }
    
    
    /// Deleta um encontro no CoreData
    internal func deleteMeeting(with meeting: Meetings) -> Void {
        if let _ = try? MeetingCDManeger.shared.deleteMeeting(at: meeting) {
            self.reloadMeetingsTableData()
        }
    }
    
    
    
    /* MARK: - Ações dos botões */
    
    /// Abre a tela de novo encontro
    @objc private func newMeetingAction() -> Void {
        let vc = NewMeetingViewController(delegate: self, place: nil)
        self.showViewController(with: vc)
    }
}
