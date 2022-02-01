//
//  NewMeetingViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import CoreLocation
import Contacts
import ContactsUI
import MapKit
import UIKit


class NewMeetingViewController: UIViewController, NewMeetingControllerDelegate {
        
    /* MARK: - Atributos */
    
    private let mainView = NewMeetingView()
    
    private var mapManeger: MapViewManeger!
    
    private var participants: [Person] = []
    
    private let meetingId: Int = UserDefaults.standard.integer(forKey: "meetingId") + 1
    
    
    // The Midway configurações
    
    private var theMidwayCoordinates: CLLocationCoordinate2D!
    
    private var placesInMidwayArea: [MapPlace] = []
    
    /// Palavras chaves para busca de lugares para API da Apple
    private let searchWords: [String] = ["bar", "restaurant", "pizza", "shopping", "club", "park", "night", "party"]
    
    /// Tipos de lugares categorizados pela Apple que fazem sentido para a busca
    private let placesTypes: [MKPointOfInterestCategory] = [
        .amusementPark, .nationalPark,
        .restaurant, .bakery, .cafe, .nightlife,
        .theater, .movieTheater
    ]
    
    /* ViewController */
    
    private var superViewController: MainViewController
    
    private let participantsController = ParticipantsViewController()
    

    /* Delegates & Data Sources */
    
    private var contactDelegate = CNContactDelegate()
    
    private let mapViewDelegate = MapViewDelegate()
    private let locationDelegate = LocationManegerDelegate()
    
    private let formsTableDelegate = NewMeetingFormsTableDelegate()
    private let formsTableDataSource = NewMeetingFormsTableDataSource()
    
    private let placesFoundDelegate = NewMeetingPlacesFoundCollectionDelegate()
    private let placesFoundDataSource = NewMeetingPlacesFoundCollectionDataSource()
    
    
    
    /* MARK: -  */
    
    init(vc: MainViewController) {
        self.superViewController = vc
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Ciclo de Vida */
        
    public override func loadView() -> Void {
        super.loadView()

        self.view = self.mainView
        
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        // Nav bar
        self.configureNavBar()
        
        
        // Configurando a remoção do teclado em qualquer lugar da tela
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        // Delegates
        self.mapManeger = MapViewManeger(
            mapView: self.mainView.mapView,
            locationDelegate: self.locationDelegate,
            mapDelegate: self.mapViewDelegate
        )
        self.locationDelegate.setManeger(manegar: self.mapManeger)
        

        self.mainView.setTitles(placeFoundText: LabelConfig(text: "Locais encontrados", sizeFont: 23, weight: .bold))
        
        self.mainView.retryButton.addTarget(self, action: #selector(self.retryAction), for: .touchDown)
        
        
        // Empty View
        let emptyViewText: String = "Escolha os participantes do encontro para achar os locais perto deles."
        
        self.configureEmptyView(show: true, emptyViewText)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        

        // Definindo delegate & datasources
        self.participantsController.setParenteDelegate(self)
        
        self.formsTableDelegate.setProtocol(self)                       // Define o delegate (protocolo) da delegate
        self.mainView.setFormsTableDelegate(self.formsTableDelegate)
        
        self.mainView.setFormsTableDataSource(self.formsTableDataSource)
        
        self.placesFoundDelegate.setMapManeger(self.mapManeger)
        self.mainView.setPlacesFoundCollectionDelegate(self.placesFoundDelegate)
        
        self.mainView.setPlacesFoundCollectionDataSource(self.placesFoundDataSource)
        

        self.reloadCollectionData()
    }
    
    
    
    /* MARK: - Delegate (Protocol) */
    
    /// Ação de quando clica na célula para selecionar os participantes
    @objc func setParticipantsAction() -> Void {
        self.navigationController?.pushViewController(self.participantsController, animated: true)
    }
    
    
    /// Pega os participantes selecionados
    func getParticipants(by participants: ParticipantsSelected) -> Void {
        self.participants = participants.confirmed
        
        // Define para o delegate do MapView (permite criar os ícones pra cada participante no mapa)
        self.mapViewDelegate.setParticipantsSelected(self.participants)
        
        // Define na label da célula a quantidade de pessoas
        self.mainView.setParticipantsCount(self.participants.count)
        
        self.calculateTheMidwayPoint()
        
        self.findPlacesInMidwayArea()
    }
    
    
    
    /* MARK: - Ações dos botões */
    
    /// Salva os dados criados do novo encontro
    @objc private func saveNewMeetingAction() -> Void {
        // Verifica se os dados passados estão completos
        if !self.isDataInputComplete() {return}
        
        // Salva os participantes
        var participants: [String] = []
                
        for var person in self.participants {
            person.meetingId = self.meetingId
            
            if let personAdded = try? ParticipantsCDManeger.shared.newParticipant(data: person) {
                participants.append(personAdded.name ?? "")
            } else {
                print("\n\nErro na hora de salvar uma pessoa no CoreData\n\n")
            }
        }
        
        // Salva o encontro
        let mapPlace = self.placesInMidwayArea[self.mainView.getPlacesFoundCollectionTag()]
        
        let data = MeetingCreated(
            meetingId: self.meetingId,
            placeInfo: mapPlace,
            meetingInfo: self.mainView.getFormsTableData(),
            participants: participants
        )
        
        if let _ = try? MeetingCDManeger.shared.newMeeting(data: data) {
            UserDefaults.standard.set(self.meetingId, forKey: "meetingId")
            self.superViewController.reloadDataMeetingsTableView()
        } else {
            print("\n\nErro na hora de salvar o encontro no CoreData\n\n")
        }
        
        self.dismiss(animated: true)
    }
    
    
    /// Cancelando a criação de um novo encontro
    @objc private func retryAction() -> Void {
        self.placesInMidwayArea = []
        
        self.mapManeger.removeAllPins()
        
        self.reloadCollectionData()
        
        self.calculateTheMidwayPoint()
        
        self.findPlacesInMidwayArea()
    }
    
    
    /// Cancelando a criação de um novo encontro
    @objc private func cancelAction() -> Void {
        let warningText = "Tem certeza que deseja sair? As alteraçães feitas não vão ser salvas."
        self.createAlert(with: warningText)
    }
    
    
    /// Tira o teclado da tela
    @objc private func dismissKeyboard() -> Void {
        self.view.endEditing(true)
    }

    
    
    /* MARK: - Configurações */
    
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Salvar",
            style: .done,
            target: self,
            action: #selector(self.saveNewMeetingAction)
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancelar",
            style: .plain,
            target: self,
            action: #selector(self.cancelAction)
        )
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    
    /// Configura a EmptyView
    private func configureEmptyView(show: Bool, _ text: String = "") -> Void {
        self.mainView.setEmptyViewInfo(
            img: "PlacesEmptyView",
            label: LabelConfig(text: text, sizeFont: 15, weight: .regular),
            button: LabelConfig(text: "Adicionar participantes", sizeFont: 15, weight: .medium))
        
        self.mainView.getEmptyViewButton().addTarget(self, action: #selector(self.setParticipantsAction), for: .touchDown)
        
        self.mainView.activateEmptyView(show)
        
    }
    
    
    /// Modal de aviso para o usuário
    private func createAlert(with mainText: String) -> Void {
        let ac = UIAlertController(
            title: "Informações Incompletas",
            message: mainText,
            preferredStyle: .actionSheet
        )
        ac.addAction(UIAlertAction(title: "Cancelar criação", style: .destructive, handler: {[] action in
            self.dismiss(animated: true)})
        )
        ac.addAction(UIAlertAction(title: "Continuar editando", style: .cancel, handler: nil))
        
        self.present(ac, animated: true)
    }
    
    
    /// Verifica se falta alguma informação
    private func isDataInputComplete() -> Bool {
        var warningText = ""
        if self.mainView.getFormsTableData().meetingName == "" {
            warningText = "Coloque um título para o encontro."
        } else if self.mainView.getPlacesFoundCollectionTag() == -1 {
            warningText = "Nenhum local fo escolhido. Selecione os participantes para mostrar os locais no ponto médio encontrado e escolha um para poder concluir a criação do encontro"
        }
        
        if warningText != "" {
            self.createAlert(with: warningText)
            return false
        }
        return true
    }
    
    
    /// Atualiza os dados da collection
    public func reloadCollectionData() -> Void {
        self.placesFoundDelegate.setPlacesFound(self.placesInMidwayArea)
        self.placesFoundDataSource.setPlacesFound(self.placesInMidwayArea)
        
        self.mainView.updatePlacesFoundCollectionData()
    }
    
    
    /// Cria uma string com as informações do  endereço completo
    static func creatAddressVisualization(place: AddressInfo) -> String {
        if place.address == "" || place.district == "" || place.city == "" || place.postalCode == "" {
            return ""
        }
        
        if place.number == "" {
            return "\(place.address) - \(place.district), \(place.city) - \(place.postalCode)"
        }
        return "\(place.address), \(place.number) - \(place.district), \(place.city) - \(place.postalCode)"
    }
    
    
    /// Acha o ponto médio entre os participantes
    private func calculateTheMidwayPoint() -> Void {
        var participantesCoords: [CLLocationCoordinate2D] = []
        
        for person in self.participants {
            let coordinate = person.coordinate
            
            print("Adicionando \(person.contactInfo.name) - Coords\(person.coordinate)\n")
            
            let pin = self.mapManeger.createPin(
                name: person.contactInfo.name,
                coordinate: person.coordinate,
                type: PlacesCategories.person.localizedDescription
            )
            self.mapManeger.addPointOnMap(pin: pin)
            
            participantesCoords.append(coordinate)
        }
        
        self.theMidwayCoordinates = self.mapManeger.getTheMidwayArea(with: participantesCoords)
    }
    
    
    /// Acha o locais a partir do ponto médio encontrado
    private func findPlacesInMidwayArea() -> Void {
        let group = DispatchGroup()
        var errorText: String = ""
        
        for word in self.searchWords {
            group.enter()
            self.mapManeger.getNerbyPlaces(at: self.theMidwayCoordinates, mainWord: word, pointsFilter: self.placesTypes) {places in
                defer {group.leave()}
                
                switch places {
                case .success(let wordPlaces):
                    self.placesInMidwayArea += wordPlaces
                case .failure(let error):
                    errorText = error.localizedDescription
                }
            }
        }
        
        group.notify(queue: .main) {
            // Embaralha a lista encontrada
            self.placesInMidwayArea.shuffle()
            
            // Adiciona os locais encontrados no mapa
            for place in self.placesInMidwayArea {
                let coordinate = place.coordinates
                
                let pin = self.mapManeger.createPin(
                    name: place.name,
                    coordinate: coordinate,
                    type: place.type.localizedDescription
                )
                self.mapManeger.addPointOnMap(pin: pin)
            }
            
            // Atualiza a collection
            self.reloadCollectionData()
            
            // Mostra a quantidade de locais encontrados
            self.mainView.setPlaceFoundCount(self.placesInMidwayArea.count)
            
            // Ativa o botão de recarregar
            if self.placesInMidwayArea.count == 0 {
                self.configureEmptyView(show: true, errorText)
                self.mainView.getEmptyViewButton().isHidden = true
            } else if self.placesInMidwayArea.count < 10 {
                self.mainView.setRetryButtonVisible(false)
            }
            
            self.configureEmptyView(show: false)
        }
    }
}

