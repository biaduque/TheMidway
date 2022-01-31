//
//  ParticipantsViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 29/01/22.
//

import Contacts
import ContactsUI
import MapKit
import UIKit


class ParticipantsViewController: UIViewController {

    /* MARK: - Atributos */
    
    private let mainView = ParticipantsView()
    
    // private var mapManeger = MapViewManeger()
    
    
    /* ViewController */
    
    private let contactController = CNContactPickerViewController()
    
    // private var superViewController: MainViewController
    

    /* Delegates & Data Sources*/
    
    private var contactDelegate = CNContactDelegate()
    
    private let tableDelegate = ParticipantsTableDelegate()
    private let tableDataSource = ParticipantsTableDataSource()
    
    //private let placesFoundDelegate = NewMeetingPlacesFoundCollectionDelegate()
    //private let placesFoundDataSource = NewMeetingPlacesFoundCollectionDataSource()
    
    
    
    /* MARK: -  */
    
//    init(vc: MainViewController) {
//        self.superViewController = vc
//
//        super.init(nibName: nil, bundle: nil)
//    }
    
    // required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Ciclo de Vida */
        
    public override func loadView() -> Void {
        super.loadView()

        self.view = self.mainView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        // Nav bar
        self.configureNavBar()
        
        self.contactController.delegate = self.contactDelegate
        
        
        self.mainView.addPersonButton.addTarget(self, action: #selector(self.addParticipantsAction), for: .touchDown)
        
        self.mainView.setTitles(
            confirmedText: "Pessoas confirmadas",
            notFoundText: "Endereços não encontrados",
            sizeFont: 25,
            w: .bold
        )
        
        self.addParticipantsAction()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        self.contactDelegate.setParentController(self)
        
        // Definindo delegate & datasources
        self.mainView.setConfirmedTableDelegate(self.tableDelegate)
        self.mainView.setConfirmedTableDataSource(self.tableDataSource)
        
        self.mainView.setNotFoundTableDelegate(self.tableDelegate)
        self.mainView.setNotFoundTableDataSource(self.tableDataSource)

        self.reloadTablesDatas()
    }
    
    
    public override func viewDidAppear(_ animated: Bool) -> Void {
        super.viewDidAppear(animated)
    }
    
                
    
    /* MARK: - Ações dos botões */
    
    /// Salva os dados criados do novo encontro
    @objc private func saveAction() -> Void {
        // guard let _ = try? MeetingCDManeger.shared.newMeeting(data: data) else {
        //     print("\n\nErro na hora de salvar o encontro no CoreData\n\n")
        //     return
        // }
        
        // self.superViewController.reloadDataMeetingsTableView()
        self.dismiss(animated: true)
    }
        
    
    /// Cancelando a criação de um novo encontro
    @objc private func cancelAction() -> Void {
        self.dismiss(animated: true)
    }
    
    
    /// Mostra a tela de selecionar os contatos
    @objc private func addParticipantsAction() -> Void {
        self.contactController.modalPresentationStyle = .popover
        self.present(self.contactController, animated: true)
    }
        
    
    
    /* MARK: - Configurações*/
    
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Salvar",
            style: .done,
            target: self,
            action: #selector(self.saveAction)
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancelar",
            style: .plain,
            target: self,
            action: #selector(self.cancelAction)
        )
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    
    /// Atualiza os dados da collection
    public func reloadTablesDatas() -> Void {
        self.mainView.updateTableDatas()
    }
    
    
    /// Verifica se o endereço existe
    public func verifyContactAddress(_ contactsSelected: [ContactInfo]) -> Void {
        
        var people: [Person] = []
        
        for contact in contactsSelected {
            let image = Int.random(in: 1...8)
            
            let person = Person(
                contactInfo: contact,
                image: image,
                coordinate: CLLocationCoordinate2D(),
                meetingId: 0
            )
            
            people.append(person)
        }
        
        self.tableDataSource.setPerson(people)
        self.reloadTablesDatas()
    }
}
