//
//  NewMeetingViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit
import Contacts
import ContactsUI
import CoreLocation

class NewMeetingViewController: UIViewController {
    
    /* MARK: - Atributos */
    
    private let mainView = NewMeetingView()
    
    private var placesOnTheMidway: [MapPlace] = []
    private var mapManeger: MapViewManeger!
    
    
    /* ViewController */
    
    private var superViewController: MainViewController
    

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
        
        self.setInfoForTests()  // Pré definindo algumas informações apenas pra teste
        
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
        
        
        // The Midway logic
        var coords: [CLLocationCoordinate2D] = []
        for place in self.placesOnTheMidway {
            let pin = self.mapManeger.createPin(name: place.name, coordinate: place.coordinates, type: place.type.localizedDescription)
            self.mapManeger.addPointOnMap(pin: pin)
            
            coords.append(place.coordinates)
        }
        
        let midwayCoords = self.mapManeger.midpointCalculate(coordinates: coords)
        let pin = self.mapManeger.createPin(name: "The Midway", coordinate: midwayCoords, type: "The Midway")
    
        self.mapManeger.addPointOnMap(pin: pin)
        
        self.mapManeger.addCircle(at: midwayCoords)
        self.mapManeger.setMapFocus(at: midwayCoords, radius: 4000)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        // Definindo delegate & datasources
        self.formsTableDelegate.setParentController(self)
        self.mainView.setFormsTableDelegate(self.formsTableDelegate)
        
        self.mainView.setFormsTableDataSource(self.formsTableDataSource)
        
        self.placesFoundDelegate.setMapManeger(self.mapManeger)
        self.mainView.setPlacesFoundCollectionDelegate(self.placesFoundDelegate)
        
        self.mainView.setPlacesFoundCollectionDataSource(self.placesFoundDataSource)
        

        self.reloadCollectionData()
    }
    
                
    
    /* MARK: - Ações dos botões */
    
    /// Salva os dados criados do novo encontro
    @objc private func saveNewMeetingAction() -> Void {
        let mapPlace = self.placesOnTheMidway[self.mainView.getPlacesFoundCollectionTag()]
        
        let data = MeetingCreated(
            placeInfo: mapPlace,
            meetingInfo: self.mainView.getFormsTableData(),
            participants: []
        )

        guard let _ = try? MeetingCDManeger.shared.newMeeting(data: data) else {
            print("\n\nErro na hora de salvar o encontro no CoreData\n\n")
            return
        }
        
        self.superViewController.reloadDataMeetingsTableView()
        self.dismiss(animated: true)
    }
        
    
    /// Cancelando a criação de um novo encontro
    @objc private func cancelAction() -> Void {
        self.dismiss(animated: true)
    }
    
    
    /// Tira o teclado da tela
    @objc private func dismissKeyboard() -> Void {
        self.view.endEditing(true)
    }
        
    
    
    /* MARK: - Configurações*/
    
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
    
    
    /// Atualiza os dados da collection
    public func reloadCollectionData() -> Void {
        self.placesFoundDelegate.setPlacesFound(self.placesOnTheMidway)
        self.placesFoundDataSource.setPlacesFound(self.placesOnTheMidway)
        
        self.mainView.updatePlacesFoundCollectionData()
    }
    
    
    /// Cria uma string com as informações do  endereço completo
    static func creatAddressVisualization(place: AddressInfo) -> String {
        return "\(place.address), \(place.number) - \(place.district), \(place.city) - \(place.postalCode)"
    }
    
    
    /// Função apenas para teste
    private func setInfoForTests() -> Void {
        self.placesOnTheMidway = [
            MapPlace(
                name: "Muza",
                coordinates: CLLocationCoordinate2D(latitude: -23.495333, longitude: -46.868243),
                pin: nil,
                type: .restaurant,
                addressInfo: AddressInfo(
                    postalCode: "06414-007",
                    country: "BR",
                    city: "SP",
                    district: "Barueri",
                    address: "Avenida Sebastião Davino dos Reis",
                    number: "101"
                )
            ),
            MapPlace(
                name: "Gui Reis",
                coordinates: CLLocationCoordinate2D(latitude: -23.713213, longitude: -46.536622),
                pin: nil,
                type: .nightlife,
                addressInfo: AddressInfo(
                    postalCode: "09770-200",
                    country: "BR",
                    city: "SP",
                    district: "São Bernardo do Campo",
                    address: "Rua Nicola Spinelli",
                    number: "469"
                )
            ),
            MapPlace(
                name: "Leh",
                coordinates: CLLocationCoordinate2D(latitude: -23.627604, longitude: -46.637000),
                pin: nil,
                type: .cafe,
                addressInfo: AddressInfo(
                    postalCode: "04304-000",
                    country: "BR",
                    city: "SP",
                    district: "São Paulo",
                    address: "Avenida Fagundes Filho",
                    number: "470"
                )
            )
        ]
    }
}
