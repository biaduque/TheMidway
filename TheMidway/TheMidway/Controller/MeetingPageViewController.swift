//
//  MeetingPageViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import Contacts
import CoreData
import CoreLocation
import EventKit
import EventKitUI
import UIKit


class MeetingPageViewController: UIViewController, MeetingPageViewControllerDelegate {

    /* MARK: - Atributos */
    
    private let mainView = MeetingPageView()
        
    private var mapManeger: MapViewManeger
    private let calendarEvent = EKEventStore()
    
    private var meeting: MeetingCompleteInfo
    private var participantsInfo: [ParticipantInfo] = []
    private var completeAddress: String = ""
    
    
    // Delegate e DataSources
    private var mainProtocol: MainControllerDelegate
    
    private let mapViewDelegate = MapViewDelegate()
    private let locationDelegate = LocationManegerDelegate()
    
    private let calendarDelegate = CalendarEventDelegate()
    
    private let participantsTableDelegate = MeetingPageTableDelegate()
    private let participantsTableDataSource = MeetingPageTableDataSource()
    
    
    
    /* MARK: -  */
    
    init(meetingInfo: MeetingCompleteInfo, delegate: MainControllerDelegate) {
        self.meeting = meetingInfo
        
        self.mainProtocol = delegate
        
        self.mapManeger = MapViewManeger(
            mapView: self.mainView.mapView,
            locationDelegate: self.locationDelegate,
            mapDelegate: self.mapViewDelegate
        )
    
        super.init(nibName: nil, bundle: nil)
        
        self.setParticipantsToMapDelegate()
    }

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func loadView() -> Void {
        super.loadView()
        
        self.view = self.mainView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        
        self.configureNavBar()
        
        
        let meeting = self.meeting.meeting
        let participants = self.meeting.participants
        
        // Configurando os títulos
        self.mainView.setTitles(
            dateTitle: LabelConfig(text: "Data", sizeFont: 22, weight: .semibold),
            localTitle: "Local",
            participantesTitle: "Participantes"
        )
        
        // Configurando as informações do encontro
        let date = "\(meeting.date ?? "") - \(meeting.hour ?? "")"
        
        let address = AddressInfo(
            postalCode: meeting.postalCode ?? "",
            country: meeting.country ?? "",
            city: meeting.city ?? "",
            district: meeting.district ?? "",
            address: meeting.address ?? "",
            number: meeting.addressNumber ?? ""
        )
        
        self.completeAddress = NewMeetingViewController.creatAddressVisualization(place: address)
        
        self.mainView.setMeetingInfo(
            meetingName: LabelConfig(text: meeting.meetingName ?? "", sizeFont: 30, weight: .heavy),
            date: LabelConfig(text: date, sizeFont: 17, weight: .medium),
            placeName: LabelConfig(text: meeting.placeName ?? "", sizeFont: 17, weight: .medium),
            address: LabelConfig(text: self.completeAddress, sizeFont: 15, weight: .regular),
            tag: LabelConfig(text: meeting.categorie ?? "", sizeFont: 14, weight: .medium)
        )
        
        
        // Configurando os participantes
        
        // var participantsCoords: [CLLocationCoordinate2D] = []
        for people in participants {
            let coords = CLLocationCoordinate2D(latitude: Double(people.latitude), longitude: Double(people.longitude))
            
            let pin = self.mapManeger.createPin(
                name: people.name ?? "",
                coordinate: coords,
                type: people.name ?? ""
            )
            self.mapManeger.addPointOnMap(pin: pin)
            
            // participantsCoords.append(coords)
        }
        
        // self.mapManeger.setRadiusViewDefault(10000)
        // let _ = self.mapManeger.getTheMidwayArea(with: participantsCoords, false)
        
        
        // Adicionando o lugar
        let coords = CLLocationCoordinate2D(latitude: Double(meeting.latitude), longitude: Double(meeting.longitude))
        let pin = self.mapManeger.createPin(
            name: meeting.placeName ?? "",
            coordinate: coords,
            type: completeAddress
        )
        self.mapManeger.addPointOnMap(pin: pin)
        self.mapManeger.setMapFocus(at: coords, radius: 10000)
        
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        self.participantsTableDataSource.setProtocol(self)
        
        // Define o delegate e dataSource
        self.mainView.setParticipantsTableDelegate(self.participantsTableDelegate)
        self.mainView.setParticipantsTableDataSource(self.participantsTableDataSource)
        
        
        self.reloadParticipantsTableView()
    }
    
    
    
    /* MARK: - Delegate (Protocolo) */
    
    /// Pega as infomações dos participantes para serem mostradas
    internal func getParticipants() -> [ParticipantInfo] {
        if self.participantsInfo.isEmpty {
            for person in self.meeting.participants {
                let infos = ParticipantInfo(
                    name: person.name ?? "",
                    image: Int(person.image),
                    distance: "",
                    distanceTime: ""
                )
                self.participantsInfo.append(infos)
            }
        }
        return self.participantsInfo
    }
    

    
    /* MARK: - Ações dos botões */
    
    @objc private func dismissAction() -> Void {
        self.dismiss(animated: true)
    }
    
    
    /// Deletar um encontro
    @objc private func deleteMeeting() -> Void {
        let alert = UIAlertController(
            title: "Exluindo encontro",
            message: "Tem certeza de que deseja exluir esse encontro?",
            preferredStyle: .alert
        )
        
        let confirm = UIAlertAction(title: "Excluir", style: .destructive) { _ in
            self.mainProtocol.deleteMeeting(with: self.meeting.meeting)
            self.dismissAction()
        }
        alert.addAction(confirm)
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancel)
    
        self.present(alert, animated: true)
    }
    
    
    @objc private func shareAction() -> Void {
        let textTemplete: String = """
        Olha esse TheMidway que eu achei para nós:
        
        📆 \(self.meeting.meeting.date ?? "")
        🕝 \(self.meeting.meeting.hour ?? "")
        🏤 \(self.meeting.meeting.placeName ?? "")
        📍 \(self.completeAddress)
        """
        
        let vc = UIActivityViewController(activityItems: [textTemplete], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    /// Mostra o local em algum app de navegação
    @objc private func openPlaceOnNavigationApp() -> Void {
        let latitude = self.meeting.meeting.latitude
        let longitude = self.meeting.meeting.longitude
        
        let navUrls: [String:String] = [
            "Apple Maps" : "http://maps.apple.com/?daddr=\(latitude),\(longitude)",
            "Google Maps" : "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving",
            "Waze" : "waze://?ll=\(latitude),\(longitude)&navigate=false"
        ]
        
        // Verifica se alguns dos apps existem no dispositivo do usuário
        var installedNavigationApps: [String:URL] = [:]
        
        for place in navUrls {
            if let url = URL(string: place.1) {
                if UIApplication.shared.canOpenURL(url) {
                    installedNavigationApps[place.0] = url
                }
            }
        }
        
        let alert = UIAlertController(
            title: "Navegação",
            message: "Selecione uma opção de navegação",
            preferredStyle: .actionSheet
        )
        
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    
    /// Abre o calendário para marcar o evento
    @objc private func openCalendar() -> Void {
        self.calendarEvent.requestAccess(to: EKEntityType.event) {granted, error in
            DispatchQueue.main.async {
    
               if (granted) && (error == nil) {
                   let event = EKEvent(eventStore: self.calendarEvent)
                   event.title = self.meeting.meeting.meetingName
                   
                   // Data
                   let dateString = "\(self.meeting.meeting.date ?? "") - \(self.meeting.meeting.hour ?? "")"
                   
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "dd/MM/yyyy - HH:mm"
                   let date = dateFormatter.date(from: dateString)
                   
                   event.startDate = date
                   // event.url = URL(string: "https://apple.com")
                   
                   // Chama a tela do calendário
                   let eventController = EKEventEditViewController()
                   eventController.event = event
                   eventController.eventStore = self.calendarEvent
                   eventController.editViewDelegate = self.calendarDelegate
                   
                   self.present(eventController, animated: true, completion: nil)
               }
           }
       }
    }
    
    
    
    /* MARK: - Configurações */
    
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        let shareButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"), style: .plain,
            target: self, action: #selector(self.shareAction)
        )
        
        // Context Menu: menu de opções
        let calendarAction = UIAction(
            title: "Criar evento",
            image: UIImage(systemName: "calendar.badge.plus")
        ) {_ in self.openCalendar()}

        let mapsAction = UIAction(
            title: "Abrir no mapa",
            image: UIImage(systemName: "location.fill")
        ) {_ in self.openPlaceOnNavigationApp()}
        
        let options = UIMenu(title: "", options: .displayInline,  children: [calendarAction, mapsAction])
        
        let deleteAction = UIAction(title: "Excluir", attributes: .destructive) { _ in self.deleteMeeting()}
        
        let menuButton = UIBarButtonItem(
            title: "Add", image: UIImage(systemName: "ellipsis"),
            primaryAction: nil,
            menu: UIMenu(title: "", children: [options, deleteAction])
        )
        self.navigationItem.rightBarButtonItems = [menuButton, shareButton]
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "OK",
            style: .done,
            target: self,
            action: #selector(self.dismissAction)
        )
    }
    
    
    /// Recarrega os dados da TableView
    private func reloadParticipantsTableView() -> Void {
        self.mainView.updateParticipantsTableData()
    }
    
    
    /// Passa os participnates para o delegate do mapa
    private func setParticipantsToMapDelegate() -> Void {
        var participants: [Person] = []
        
        for person in self.meeting.participants {
            let personInfo = Person(
                contactInfo: ContactInfo(name: person.name ?? "", contact: CNContact()),
                image: Int(person.image),
                coordinate: CLLocationCoordinate2D(
                    latitude: Double(person.latitude),
                    longitude: Double(person.longitude)
                ),
                meetingId: Int(person.meetingId)
            )
            participants.append(personInfo)
        }
        
        self.mapViewDelegate.setParticipantsSelected(participants)
    }
}
