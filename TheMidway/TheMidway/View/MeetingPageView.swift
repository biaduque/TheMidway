//
//  MeetingPage.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import UIKit
import MapKit

class MeetingPageView: UIView {
    
    /* MARK: - Atributos */
    
    public let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    
    private var meetingNameLabel: UILabel = {
        let lbl = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private var dateTitleLabel: UILabel
    private var meetingDataLabel: UILabel
    
    // Place info
    private var placeTitleLabel: UILabel
    
    private var meetingPlaceNameLabel: UILabel = {
        let lbl = MainView.newLabel(color: .secondaryLabel)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private var meetingPlaceAddressLabel: UILabel = {
        let lbl = MainView.newLabel(color: .tertiaryLabel)
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .justified
        return lbl
    }()
    
    private var meetingPlaceTagLabel: UILabel = {
        let lbl = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    
    private var participantsTitleLabel: UILabel

    private let participantsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.backgroundColor = UIColor(named: "BackgroundColor")   // .secondarySystemBackground
        
        table.alwaysBounceVertical = false
        table.alwaysBounceHorizontal = false
        
        table.clipsToBounds = true
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 7
        
        table.register(MeetingPageTableCell.self, forCellReuseIdentifier: MeetingPageTableCell.identifier)

        table.rowHeight = 45
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        
        let view = UIView(frame: frame)
        table.tableHeaderView = view
        table.tableFooterView = view

        return table
    }()
    
    
    
    /* MARK: -  */

    init() {
        // Criando as labels
        self.dateTitleLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.meetingDataLabel = MainView.newLabel(color: .secondaryLabel)
        
        self.placeTitleLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        
        self.participantsTitleLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        
        
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "BackgroundColor")
        
        
        // Adicionando as views
        self.addSubview(self.mapView)
        
        self.addSubview(self.meetingNameLabel)
        
        self.addSubview(self.dateTitleLabel)
        self.addSubview(self.meetingDataLabel)
        
        self.addSubview(self.placeTitleLabel)
        self.addSubview(self.meetingPlaceNameLabel)
        self.addSubview(self.meetingPlaceAddressLabel)
        self.addSubview(self.meetingPlaceTagLabel)
        
        self.addSubview(self.participantsTitleLabel)
        self.addSubview(self.participantsTableView)
             
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    /// Definindo os títulos
    public func setTitles(dateTitle: LabelConfig, localTitle: String, participantesTitle: String) -> Void {
        let fontSize = dateTitle.sizeFont
        let weight = dateTitle.weight
        
        
        self.dateTitleLabel.text = dateTitle.text
        self.dateTitleLabel.font = .systemFont(ofSize: fontSize, weight: weight)
        
        self.placeTitleLabel.text = localTitle
        self.placeTitleLabel.font = .systemFont(ofSize: fontSize, weight: weight)
        
        self.participantsTitleLabel.text = participantesTitle
        self.participantsTitleLabel.font = .systemFont(ofSize: fontSize, weight: weight)
    }
    
    
    /// Definindo as informações do encontro
    public func setMeetingInfo(meetingName: LabelConfig, date: LabelConfig, placeName: LabelConfig, address: LabelConfig, tag: LabelConfig) -> Void {
        
        self.setLabelInfo(label: self.meetingNameLabel, info: meetingName)
        
        self.setLabelInfo(label: self.meetingDataLabel, info: date)
        
        self.setLabelInfo(label: self.meetingPlaceNameLabel, info: placeName)
        
        self.setLabelInfo(label: self.meetingPlaceAddressLabel, info: address)
        
        self.setLabelInfo(label: self.meetingPlaceTagLabel, info: tag)
        self.meetingPlaceTagLabel.backgroundColor = UIColor(named: tag.text)?.withAlphaComponent(0.4)
    }
    
    
    // Delegate & Datasource
        
    public func setParticipantsTableDelegate(_ delegate: MeetingPageTableDelegate) -> Void {
        self.participantsTableView.delegate = delegate
    }
    
    public func setParticipantsTableDataSource(_ dataSource: MeetingPageTableDataSource) -> Void {
        self.participantsTableView.dataSource = dataSource
    }
    
    
    // Atualizando dados da Table
    public func updateParticipantsTableData() -> Void { self.participantsTableView.reloadData() }
    
    
    
    /* MARK: -  Constraints */
    
    private func setConstraints() -> Void {
        let safeArea: CGFloat = 50
        let lateralSpace: CGFloat = 15
        let betweenSpace: CGFloat = 18
        
        
        let mapViewConstraints: [NSLayoutConstraint] = [
            self.mapView.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mapView.heightAnchor.constraint(equalToConstant: 250)
        ]
        NSLayoutConstraint.activate(mapViewConstraints)
        
        
        
        let meetingNameConstraints: [NSLayoutConstraint] = [
            self.meetingNameLabel.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: betweenSpace/2),
            self.meetingNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.meetingNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(meetingNameConstraints)
        
        
        
        let dateInfoConstraints: [NSLayoutConstraint] = [
            self.dateTitleLabel.topAnchor.constraint(equalTo: self.meetingNameLabel.bottomAnchor, constant: betweenSpace),
            self.dateTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.dateTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.dateTitleLabel.bottomAnchor.constraint(equalTo: self.meetingDataLabel.topAnchor),
            self.dateTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.meetingDataLabel.topAnchor.constraint(equalTo: self.dateTitleLabel.bottomAnchor, constant: betweenSpace/3),
            self.meetingDataLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingDataLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.meetingDataLabel.bottomAnchor.constraint(equalTo: self.placeTitleLabel.topAnchor),
            self.meetingDataLabel.heightAnchor.constraint(equalToConstant: 20),
        ]
        NSLayoutConstraint.activate(dateInfoConstraints)
        

        
        let placeInfoConstraints: [NSLayoutConstraint] = [
            self.placeTitleLabel.topAnchor.constraint(equalTo: self.meetingDataLabel.bottomAnchor, constant: betweenSpace),
            self.placeTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.placeTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.placeTitleLabel.bottomAnchor.constraint(equalTo: self.meetingPlaceNameLabel.topAnchor),
            self.placeTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.meetingPlaceNameLabel.topAnchor.constraint(equalTo: self.placeTitleLabel.bottomAnchor, constant: betweenSpace/3),
            self.meetingPlaceNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingPlaceNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.meetingPlaceNameLabel.bottomAnchor.constraint(equalTo: self.meetingPlaceAddressLabel.topAnchor),
            self.meetingPlaceNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.meetingPlaceAddressLabel.topAnchor.constraint(equalTo: self.meetingPlaceNameLabel.bottomAnchor),
            self.meetingPlaceAddressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingPlaceAddressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.meetingPlaceAddressLabel.bottomAnchor.constraint(equalTo: self.meetingPlaceTagLabel.topAnchor),
            self.meetingPlaceAddressLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            self.meetingPlaceTagLabel.topAnchor.constraint(equalTo: self.meetingPlaceAddressLabel.bottomAnchor),
            self.meetingPlaceTagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingPlaceTagLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -(lateralSpace*3)),
            // self.meetingPlaceTagLabel.bottomAnchor.constraint(equalTo: self.participantsTitleLabel.topAnchor),
            self.meetingPlaceTagLabel.heightAnchor.constraint(equalToConstant: 20),
        ]
        NSLayoutConstraint.activate(placeInfoConstraints)
        
        
        let participantsInfoConstraints: [NSLayoutConstraint] = [
            self.participantsTitleLabel.topAnchor.constraint(equalTo: self.meetingPlaceTagLabel.bottomAnchor, constant: betweenSpace),
            self.participantsTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.participantsTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.participantsTitleLabel.bottomAnchor.constraint(equalTo: self.participantsTableView.topAnchor),
            self.participantsTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.participantsTableView.topAnchor.constraint(equalTo: self.participantsTitleLabel.bottomAnchor, constant: betweenSpace/2),
            self.participantsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.participantsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.participantsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -lateralSpace)
        ]
        NSLayoutConstraint.activate(participantsInfoConstraints)
    }
    
    
    
    /* MARK: - Configurações */
    
    private func setLabelInfo(label: UILabel, info: LabelConfig) -> Void {
        label.text = info.text
        label.font = .systemFont(ofSize: info.sizeFont, weight: info.weight)
    }
}
