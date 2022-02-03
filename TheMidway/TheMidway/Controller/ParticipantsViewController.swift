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


class ParticipantsViewController: UIViewController, ParticipantsControllerDelegate {

    /* MARK: - Atributos */
    
    private let mainView = ParticipantsView()
    
    private var participantesSelected: ParticipantsSelected = ParticipantsSelected(confirmed: [], notConfirmed: [])
    
    private var personEdited: Person?
    
    /* ViewController */
    
    private let contactController = CNContactPickerViewController()
    
    private var parentDelegate: NewMeetingControllerDelegate!
    

    /* Delegates & Data Sources*/
    
    private var contactDelegate = CNContactDelegate()
    
    private let confirmedTableDelegate = ParticipantsTableDelegate()
    private let confirmedTableDataSource = ParticipantsTableDataSource()
    
    private let notConfirmedTableDelegate = ParticipantsTableDelegate()
    private let notConfirmedDataSource = ParticipantsTableDataSource()
    
    
    
    /* MARK: - Ciclo de Vida */
        
    public override func loadView() -> Void {
        super.loadView()

        self.view = self.mainView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        
        // Nav bar
        self.configureNavBar()
        
        // View
        self.mainView.addPersonButton.addTarget(self, action: #selector(self.addParticipantsAction), for: .touchDown)
        
        self.mainView.setTitles(
            confirmedText: "Pessoas confirmadas",
            notFoundText: "Endereços não encontrados",
            sizeFont: 25,
            w: .bold
        )
        
        // Empty View
        
        let emptyViewText: String = "Escolha os endereços nos seus contatos dos seus amigos para criar o encontro!"
        
        self.mainView.setEmptyViewInfo(
            img: "FriendsEmptyView",
            label: LabelConfig(text: emptyViewText, sizeFont: 15, weight: .regular),
            button: LabelConfig(text: "Adicionar participantes", sizeFont: 15, weight: .medium))
        
        self.mainView.getEmptyViewButton().addTarget(self, action: #selector(self.addParticipantsAction), for: .touchDown)
        
        self.addParticipantsAction()
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        self.contactController.delegate = self.contactDelegate
        
        self.contactDelegate.setParentController(self)
        
        self.confirmedTableDelegate.setDelegate(self)
        self.notConfirmedTableDelegate.setDelegate(self)
        
        // Definindo delegate & datasources
        self.mainView.setConfirmedTableDelegate(self.confirmedTableDelegate)
        self.mainView.setConfirmedTableDataSource(self.confirmedTableDataSource)
        
        self.mainView.setNotFoundTableDelegate(self.notConfirmedTableDelegate)
        self.mainView.setNotFoundTableDataSource(self.notConfirmedDataSource)

        self.reloadTablesDatas()
    }
    
    
    public override func viewDidAppear(_ animated: Bool) -> Void {
        super.viewDidAppear(animated)
        
        if self.participantesSelected.notConfirmed.isEmpty {
            if self.participantesSelected.confirmed.isEmpty {
                self.mainView.setConfirmedVisibility(bool: true)
            }
            self.mainView.setNotFoundVisibility(bool: true)
        }
    }
    
    
    /* MARK: - Delegate (Protocol) */
    
    func openContactPage(with contact: Person) -> Void {
        self.personEdited = contact
        
        var personContact: CNContact = contact.contactInfo.contact
        
        if !personContact.areKeysAvailable([CNContactViewController.descriptorForRequiredKeys()]) {
            do {
                let store = CNContactStore()
                personContact = try store.unifiedContact(withIdentifier: personContact.identifier, keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
            }
            catch { }
        }
        
        self.personEdited?.contactInfo.contact = personContact
        
        let contactViewController = CNContactViewController(for: personContact)
        
        contactViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(self.exitContactController)
        )
        
        let navBar = UINavigationController(rootViewController: contactViewController)
        self.present(navBar, animated: true)
    }
    
                    
    
    /* MARK: - Encapsulamento */
    
    /// Define o delegate da NewMeeting para poder se comunicar com ela (via protocolo)
    public func setParenteDelegate(_ delegate: NewMeetingControllerDelegate) -> Void {
        self.parentDelegate = delegate
    }
    
    
    
    /* MARK: - Ações dos botões */
    
    /// Salva os dados criados do novo encontro
    @objc private func saveAction() -> Void {
        self.parentDelegate.getParticipants(by: self.participantesSelected)
        
        self.navigationController?.popViewController(animated: true)
    }
        
        
    /// Mostra a tela de selecionar os contatos
    @objc private func addParticipantsAction() -> Void {
        self.contactController.modalPresentationStyle = .popover
        self.present(self.contactController, animated: true)
    }
    
    
    /// Mostra a tela de selecionar os contatos
    @objc private func exitContactController() -> Void {
        self.dismiss(animated: true, completion: nil)
        self.participantesSelected.confirmed.append(self.personEdited!)
        
        var contacts: [CNContact] = []
        for person in self.participantesSelected.confirmed {
            contacts.append(person.contactInfo.contact)
        }
        
        self.contactDelegate.contactPicker(self.contactController, didSelect: contacts)
        // self.verifyContactEdited(self.personEdited!)
        
    }
        
    
    
    /* MARK: - Configurações*/
    
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        self.title = "Quem vai?"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Salvar",
            style: .done,
            target: self,
            action: #selector(self.saveAction)
        )
    }
    
    
    /// Atualiza os dados da collection
    public func reloadTablesDatas() -> Void {
        self.confirmedTableDelegate.setPerson(self.participantesSelected.confirmed)
        self.confirmedTableDataSource.setPerson(self.participantesSelected.confirmed)
        
        self.notConfirmedTableDelegate.setPerson(self.participantesSelected.notConfirmed)
        self.notConfirmedDataSource.setPerson(self.participantesSelected.notConfirmed)
        
        self.mainView.updateTableDatas()
    }
    
    
    /// Verifica se o endereço existe
    public func verifyContactAddress(_ contactsSelected: [ContactInfo]) -> Void {
        
        let group = DispatchGroup()
        
        var peopleConfirmed: [Person] = []
        var peopleNotConfirmed: [Person] = []
    
        for contact in contactsSelected {
            group.enter()
            let address = NewMeetingViewController.creatAddressVisualization(place: contact.address)
            var addressCoords = CLLocationCoordinate2D()
            
            
            MapViewManeger.getCoordsByAddress(address: address) { result in
                defer {group.leave()}
                
                switch result {
                case .success(let coords):
                    addressCoords = coords
                case .failure(_):
                    addressCoords = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                }
            }
            
            group.notify(queue: .main) {
                let image = Int.random(in: 1...8)
                
                if address == "" {
                    addressCoords = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                }
                
                let person = Person(
                    contactInfo: contact,
                    image: image,
                    coordinate: addressCoords,
                    meetingId: 0
                )
                
                if addressCoords.latitude == 0 {
                    peopleNotConfirmed.append(person)
                } else {
                    peopleConfirmed.append(person)
                }
            }
        }
        
        group.notify(queue: .main) {
            if !peopleConfirmed.isEmpty {
                self.mainView.activateEmptyView(num: 1)
                
                if !peopleNotConfirmed.isEmpty {
                    print("Lista: ", peopleNotConfirmed)
                    self.participantesSelected.notConfirmed = peopleNotConfirmed
                    self.mainView.setNotFoundVisibility(bool: false)
                } else {
                    self.mainView.setNotFoundVisibility(bool: true)
                }
                
                self.mainView.setConfirmedVisibility(bool: false)
                self.participantesSelected.confirmed = peopleConfirmed
                
                self.reloadTablesDatas()
            } else {
                self.mainView.activateEmptyView(num: 0)
            }
        }
    }
    
    
    /// Verifica se o contato que foi editado está correto
    public func verifyContactEdited(_ person: Person) -> Void {
        let newContactInfo = self.contactDelegate.getContactInfo(with: person.contactInfo.contact)
        let group = DispatchGroup()
        
        let address = NewMeetingViewController.creatAddressVisualization(place: newContactInfo.address)
        var addressCoords = CLLocationCoordinate2D()
        
        group.enter()
        MapViewManeger.getCoordsByAddress(address: address) { result in
            defer {group.leave()}
            
            switch result {
            case .success(let coords):
                addressCoords = coords
            case .failure(_):
                addressCoords = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
        }
    
        group.notify(queue: .main) {
            let newPerson = Person(
                contactInfo: newContactInfo,
                image: person.image,
                coordinate: addressCoords,
                meetingId: person.meetingId
            )
                
            if addressCoords.latitude != 0 {
                self.participantesSelected.confirmed.append(newPerson)
                self.participantesSelected.notConfirmed.remove(at: self.mainView.getTagTableNotFound())
            }
            
            self.reloadTablesDatas()
            self.personEdited = nil
        }
    }
}
