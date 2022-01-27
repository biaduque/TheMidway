//
//  NewMeetingViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit
import CoreLocation
import MapKit

class NewMeetingViewController: UIViewController,
                                UICollectionViewDelegate, UICollectionViewDataSource,
                                UITableViewDelegate, UITableViewDataSource{
    
    /* MARK: - Atributos */
    
    private let mainView = NewMeetingView()
    
    private var superViewController: MainViewController
    
    private var placesOnTheMidway: [MapPlace] = [
        MapPlace(
            name: "Muza",
            coordinates: CLLocationCoordinate2D(latitude: -23.495333, longitude: -46.868243),
            pin: nil,
            type: .restaurant,
            postalCode: "06414-007",
            country: "BR",
            city: "SP",
            district: "Barueri",
            address: "Avenida Sebastião Davino dos Reis",
            number: "101"
        ),
        MapPlace(
            name: "Gui Reis",
            coordinates: CLLocationCoordinate2D(latitude: -23.713213, longitude: -46.536622),
            pin: nil,
            type: .nightlife,
            postalCode: "09770-200",
            country: "BR",
            city: "SP",
            district: "São Bernardo do Campo",
            address: "Rua Nicola Spinelli",
            number: "469"
        ),
        MapPlace(
            name: "Leh",
            coordinates: CLLocationCoordinate2D(latitude: -23.627604, longitude: -46.637000),
            pin: nil,
            type: .cafe,
            postalCode: "04304-000",
            country: "BR",
            city: "SP",
            district: "São Paulo",
            address: "Avenida Fagundes Filho",
            number: "470"
        )
    ]
    
    private var mapManeger: MapViewManeger!
    
    private var lastCellChecked: NewMeetingCollectionCell = NewMeetingCollectionCell()
    
    
    
    /* Delegates */
    
    private let textFieldDelegate = TextFieldDelegate()
    
    private let mapViewDelegate = MapViewDelegate()
    
    private let locationDelegate = LocationManegerDelegate()
    
    
    /* DataSources */
    
    
    
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
            action: #selector(self.saveNewMeetingAction)
        )
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
        
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
        
        self.mainView.formsTableView.delegate = self
        self.mainView.formsTableView.dataSource = self

        self.mainView.placesFoundCollection.delegate = self
        self.mainView.placesFoundCollection.dataSource = self

        self.reloadDataMeetingsTableView()
    }
    
    
    
    /* MARK: - Delegate (Table) */

    /// Quantidade de células que vai ter na table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return 3
    }
    
    
    /// Número de sessões diferentes
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Ação de quando clica em uma célula
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
    
    
    /// Cria o conteúdo da célula
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            guard let newCell = self.mainView.formsTableView.dequeueReusableCell(withIdentifier: NewMeetingTableTitleCell.identifier, for: indexPath) as? NewMeetingTableTitleCell else {
                return cell
            }
            
            newCell.setTextBackground("Título do encontro")
            newCell.setTextFieldDelegate(delegate: self.textFieldDelegate)
            cell = newCell
        } else {
            switch indexPath.row {
            case 0:
                guard let newCell = self.mainView.formsTableView.dequeueReusableCell(withIdentifier: NewMeetingTableDateCell.identifier, for: indexPath) as? NewMeetingTableDateCell else {
                    return cell
                }
                
                newCell.setCellTitle(LabelConfig(text: "Quando será?", sizeFont: 17, weight: .bold))
                cell = newCell
                
            case 1:
                guard let newCell = self.mainView.formsTableView.dequeueReusableCell(withIdentifier: NewMeetingTableParticipantsCell.identifier, for: indexPath) as? NewMeetingTableParticipantsCell else {
                    return cell
                }
                
                newCell.setCellTitle(
                    leftText: LabelConfig(text: "Quem vai?", sizeFont: 17, weight: .bold),
                    rightText: LabelConfig(text: "10", sizeFont: 17, weight: .regular))
                cell = newCell

            default: return cell
            }
        }
    
        return cell
    }
    
    
    
    /* MARK: - Delegate (Collection) */
    
    /// Mostra quantas células vão ser mostradas
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.placesOnTheMidway.count
    }
    
    
    /// Configura uma célula
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewMeetingCollectionCell.identifier, for: indexPath) as? NewMeetingCollectionCell else {
            return UICollectionViewCell()
        }
        
        let completeAddress = NewMeetingViewController.creatAddressVisualization(place: self.placesOnTheMidway[indexPath.row])
        
        cell.setCellInfo(
            title: LabelConfig(text: self.placesOnTheMidway[indexPath.row].name, sizeFont: 20, weight: .bold),
            address: LabelConfig(text: completeAddress, sizeFont: 15, weight: .regular),
            tag: self.placesOnTheMidway[indexPath.row].type
        )
        return cell
    }
    
    
    /// Ação de quando clica em uma célula
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
        // Pega a célula clicada
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewMeetingCollectionCell else {
            return
        }
        
        cell.checkCell()
        self.lastCellChecked.uncheckCell()
        self.lastCellChecked = cell
        
        collectionView.tag = indexPath.row
        
        self.mapManeger.setMapFocus(at: self.placesOnTheMidway[indexPath.row].coordinates, radius: 3000)
    }
    
        
    
    /* MARK: - Ações dos botões */
    
    
    @objc private func saveNewMeetingAction() -> Void {
        
        let mapPlace = self.placesOnTheMidway[self.mainView.placesFoundCollection.tag]
        
        
        guard let cellDate = self.mainView.formsTableView.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as? NewMeetingTableDateCell else {
            return
        }
        
        guard let cellTitle = self.mainView.formsTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as? NewMeetingTableTitleCell else {
            return
        }
        
        if cellTitle.getText() == "" {
            // Caso para quando a pessoa não colocu um título
        }
        
        let data = MeetingCreated(
            placeInfo: mapPlace,
            date: cellDate.getDate(),
            hour: cellDate.getTime(),
            meetingName: cellTitle.getText(),
            participants: []
        )

        guard let _ = try? MeetingCDManeger.shared.newMeeting(data: data) else {
            print("\n\nErro na hora de salvar o encontro no CoreData\n\n")
            return
        }
        
        self.superViewController.reloadDataMeetingsTableView()
        self.dismiss(animated: true)
    }
    
    /// Tira o teclado da tela
    @objc private func dismissKeyboard() -> Void {
        self.view.endEditing(true)
    }
    
    
    
    
    /* MARK: - Configurações*/
    
    public func reloadDataMeetingsTableView() -> Void {
        self.mainView.formsTableView.reloadData()
    }
    
    
    static func creatAddressVisualization(place: MapPlace) -> String {
        return "\(place.address), \(place.number) - \(place.district), \(place.city) - \(place.postalCode)"
    }
}
