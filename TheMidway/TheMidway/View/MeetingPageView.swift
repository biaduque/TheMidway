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
        // lbl.textAlignment = .center
        return lbl
    }()
    
    private var dateImage = NewMeetingTableDateCell.newImageView(color: UIColor(named: "AccentColor"))
    private var meetingDataLabel = MainView.newLabel(color: .secondaryLabel)
    
    // Place info
    
    private var placeInfoView = PlaceVisualization(style: .withoutWebButton)
    
    
    private var participantsTitleLabel: UILabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))

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
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "BackgroundColor")
        
        self.addSubview(self.mapView)
        
        self.addSubview(self.meetingNameLabel)
        
        self.addSubview(self.dateImage)
        self.addSubview(self.meetingDataLabel)
        
        self.addSubview(self.placeInfoView)
        
        self.addSubview(self.participantsTitleLabel)
        self.addSubview(self.participantsTableView)
             
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    /// Definindo os títulos
    public func setTitles(dateIcon: LabelConfig, participantesTitle: LabelConfig) -> Void {
        self.dateImage.setImage(with: dateIcon)
        self.participantsTitleLabel.configureLabelText(with: participantesTitle)
    }
    
    
    /// Definindo as informações do encontro
    public func setMeetingInfo(meetingName: LabelConfig, date: LabelConfig, placeName: LabelConfig, address: LabelConfig, tag: PlacesCategories) -> Void {
        
        self.meetingNameLabel.configureLabelText(with: meetingName)
        self.meetingDataLabel.configureLabelText(with: date)
        self.placeInfoView.setInfo(title: placeName, address: address, tag: tag)
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
        let safeArea: CGFloat = 60
        let lateralSpace: CGFloat = 15
        let betweenSpace: CGFloat = 20
        
        let iconSize: CGFloat = 30
        let labelSize: CGFloat = 20
        
        
        let viewConstraints: [NSLayoutConstraint] = [
            self.mapView.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mapView.heightAnchor.constraint(equalToConstant: 250),
            
            
            self.meetingNameLabel.topAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: betweenSpace/2),
            self.meetingNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.meetingNameLabel.heightAnchor.constraint(equalToConstant: labelSize*2),
            
            
            
            self.dateImage.topAnchor.constraint(equalTo: self.meetingNameLabel.bottomAnchor, constant: betweenSpace),
            self.dateImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.dateImage.heightAnchor.constraint(equalToConstant: iconSize),
            self.dateImage.widthAnchor.constraint(equalToConstant: iconSize),
            
            self.meetingDataLabel.topAnchor.constraint(equalTo: self.dateImage.topAnchor),
            self.meetingDataLabel.centerYAnchor.constraint(equalTo: self.dateImage.centerYAnchor),
            self.meetingDataLabel.leftAnchor.constraint(equalTo: self.dateImage.rightAnchor, constant: lateralSpace),
            self.meetingDataLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.meetingDataLabel.heightAnchor.constraint(equalToConstant: labelSize),
            
            
            
            self.placeInfoView.topAnchor.constraint(equalTo: self.self.meetingDataLabel.bottomAnchor, constant: betweenSpace),
            self.placeInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.placeInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.placeInfoView.heightAnchor.constraint(equalToConstant: 100),
            
            
            
            self.participantsTitleLabel.topAnchor.constraint(equalTo: self.placeInfoView.bottomAnchor, constant: betweenSpace),
            self.participantsTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.participantsTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.participantsTitleLabel.heightAnchor.constraint(equalToConstant: labelSize+5),
            
    
            self.participantsTableView.topAnchor.constraint(equalTo: self.participantsTitleLabel.bottomAnchor, constant: betweenSpace/1.5),
            self.participantsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.participantsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.participantsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -lateralSpace)
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
}
