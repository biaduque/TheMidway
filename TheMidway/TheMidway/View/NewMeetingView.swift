//
//  NewMeetingView.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit
import MapKit

class NewMeetingView: UIView {

    /* MARK: -  Atributos */
    
    private lazy var emptyView = EmptyView()
    
    private var emptyViewConstraints: [NSLayoutConstraint] = []
    
    
    // Formulário
    
    private let formsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.backgroundColor = UIColor(named: "BackgroundColor")   // .secondarySystemBackground
        table.isScrollEnabled = false
        
        table.clipsToBounds = true
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 7
        
        table.register(NewMeetingTableTitleCell.self, forCellReuseIdentifier: NewMeetingTableTitleCell.identifier)
        table.register(NewMeetingTableDateCell.self, forCellReuseIdentifier: NewMeetingTableDateCell.identifier)
        table.register(NewMeetingTableParticipantsCell.self, forCellReuseIdentifier: NewMeetingTableParticipantsCell.identifier)
        
        table.rowHeight = 45
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        
        let view = UIView(frame: frame)
        table.tableHeaderView = view
        table.tableFooterView = view
        
        // Tirando o espaço entre as seções
        table.sectionHeaderHeight = .leastNormalMagnitude
        table.sectionFooterHeight = 20
        
        table.contentInset = .zero
        
        return table
    }()
    
    
    // Lugares encontrados
    
    private var placesFoundLabel: UILabel
    
    public let retryButton: UIButton
    
    private let placesFoundCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal                // Direção da rolagem (se é horizontal ou vertical)
        layout.itemSize = CGSize(width: 300, height: 120)   // Define o tamanho da célula
        layout.minimumLineSpacing = 15                      // Espaço entre as células

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NewMeetingCollectionCell.self, forCellWithReuseIdentifier: NewMeetingCollectionCell.identifier)
        cv.backgroundColor = UIColor(named: "BackgroundColor")
        cv.tag = -1
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()
    
    
    // Mapa
    
    public let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        map.layer.cornerRadius = 10
        return map
    }()
    
    
    private var placesFoundConstraints: [NSLayoutConstraint] = []
    
    private var placesFoundLabelText: String = ""
    
    
    
    /* MARK: -  */
    
    init() {
        self.placesFoundLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.retryButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        super.init(frame: .zero)
    
        self.backgroundColor = UIColor(named: "BackgroundColor")
                
        self.addSubview(self.formsTableView)
        
        self.addSubview(self.placesFoundLabel)
        self.addSubview(self.retryButton)
        self.addSubview(self.placesFoundCollection)
        
        self.addSubview(self.mapView)
        
        self.addSubview(self.emptyView)
        
        self.setConstraints()
        
        self.setRetryButtonVisible(true)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Define os textos e botões da tela
    public func setTitles(placeFoundText: LabelConfig) -> Void {
        self.placesFoundLabelText = placeFoundText.text
        self.placesFoundLabel.text = placeFoundText.text
        self.placesFoundLabel.font = .systemFont(ofSize: placeFoundText.sizeFont, weight: placeFoundText.weight)
        
        // Botões
        let configIcon = UIImage.SymbolConfiguration(pointSize: placeFoundText.sizeFont, weight: .semibold, scale: .large)
        
        self.retryButton.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configIcon), for: .normal)
    }
    
    
    /// Define a quantidade de locais encontrados
    public func setPlaceFoundCount(_ num: Int) -> Void {
        self.placesFoundLabel.text = "\(self.placesFoundLabelText): \(num)"
    }
    
    
    /// Tag onde salva a posição da célula que foi clicada
    public func getPlacesFoundCollectionTag() -> Int { return self.placesFoundCollection.tag }
    
    
    /// Define o número de participantes que foram selecionados
    public func setParticipantsCount(_ num: Int) -> Void {
        // Acessa a célula
        guard let cell = self.formsTableView.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as? NewMeetingTableParticipantsCell else {
            return
        }
        cell.setParticipantsCount(num: num)
    }
    
    
    /// Define a visibilidade do botão retry (se aparace ou fica escondido)
    public func setRetryButtonVisible(_ bool: Bool) -> Void {
        self.retryButton.isHidden = bool
        self.retryButton.isEnabled = !bool
    }
    
    
    // Delegate & Datasource
    
    public func setFormsTableDelegate(_ delegate: NewMeetingFormsTableDelegate) -> Void {
        self.formsTableView.delegate = delegate
    }
    
    public func setFormsTableDataSource(_ dataSource: NewMeetingFormsTableDataSource) -> Void {
        self.formsTableView.dataSource = dataSource
    }
    
    public func setPlacesFoundCollectionDelegate(_ delegate: NewMeetingPlacesFoundCollectionDelegate) -> Void {
        self.placesFoundCollection.delegate = delegate
    }
    
    public func setPlacesFoundCollectionDataSource(_ dataSource: NewMeetingPlacesFoundCollectionDataSource) -> Void {
        self.placesFoundCollection.dataSource = dataSource
    }
    
    
    // Dados da table e collection
    
    /// Atualiza as informações do mapa
    public func updatePlacesFoundCollectionData() -> Void { self.placesFoundCollection.reloadData() }
    
    
    /// Pega as informações que froam selecionas e definidas da tabela
    public func getFormsTableData() -> MeetingInfo {
        guard let cellTitle = self.formsTableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as? NewMeetingTableTitleCell,
                let cellDate = self.formsTableView.cellForRow(at: NSIndexPath(row: 0, section: 1) as IndexPath) as? NewMeetingTableDateCell else {
            return MeetingInfo(date: "", hour: "", meetingName: "")
        }
        
        return MeetingInfo(
            date: cellDate.getDate(),
            hour: cellDate.getTime(),
            meetingName: cellTitle.getText()
        )
    }
    
    
    // EmptyView
    
    public func activateEmptyView(_ bool: Bool) -> Void {
        if bool {
            self.emptyView.isHidden = false
            NSLayoutConstraint.activate(self.emptyViewConstraints)
            
            if !self.emptyView.isDescendant(of: self) {
                self.addSubview(self.emptyView)
            }
            
            
            self.setPlaceFoundGroupViewVisibility(is: true)
            NSLayoutConstraint.deactivate(self.placesFoundConstraints)

        } else {
            self.emptyView.isHidden = true
            NSLayoutConstraint.deactivate(self.emptyViewConstraints)
            self.emptyView.removeFromSuperview()

            self.setPlaceFoundGroupViewVisibility(is: false)
            NSLayoutConstraint.activate(self.placesFoundConstraints)
        }
    }
    
    
    public func setEmptyViewInfo(img: String, label: LabelConfig, button: LabelConfig) {
        self.emptyView.setEmptyViewInfo(img: img, text: label, button: button)
    }
    
    public func getEmptyViewButton() -> UIButton {
        return self.emptyView.getButton()
    }
    
    
    /// Ativa/desativa as view que mostram informações sobre locais
    private func setPlaceFoundGroupViewVisibility(is bool: Bool) -> Void {
        self.placesFoundLabel.isHidden = bool
        self.placesFoundCollection.isHidden = bool
        self.mapView.isHidden = bool
    }
    
    
    
    /* MARK: -  Constraints */
    
    private func setConstraints() -> Void {
        let lateralSpace: CGFloat = 18
        let betweenSpace: CGFloat = 20
        
        let buttonSize: CGFloat = 25
        
        
        /* Formulário */
        let formsTableViewConstraints: [NSLayoutConstraint] = [
            self.formsTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            self.formsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.formsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.formsTableView.heightAnchor.constraint(equalToConstant: 160)
        ]
        NSLayoutConstraint.activate(formsTableViewConstraints)
        
        
        /*  Lugares encontrados */
        
        // Label
        let placesFoundConstraints: [NSLayoutConstraint] = [
            // Label
            self.placesFoundLabel.topAnchor.constraint(equalTo: self.formsTableView.bottomAnchor, constant: betweenSpace*1.2),
            self.placesFoundLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.placesFoundLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.placesFoundLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // Botão de atualizar locais
            self.retryButton.topAnchor.constraint(equalTo: self.placesFoundLabel.topAnchor),
            self.retryButton.centerYAnchor.constraint(equalTo: self.placesFoundLabel.centerYAnchor),
            self.retryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.retryButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.retryButton.widthAnchor.constraint(equalToConstant: buttonSize),
            
            // Collection
            self.placesFoundCollection.topAnchor.constraint(equalTo: self.placesFoundLabel.bottomAnchor, constant: betweenSpace/2),
            self.placesFoundCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.placesFoundCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.placesFoundCollection.heightAnchor.constraint(equalToConstant: 140),
            
            // Mapa
            self.mapView.topAnchor.constraint(equalTo: self.placesFoundCollection.bottomAnchor, constant: betweenSpace/2),
            self.mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2),
            
        ]
        self.placesFoundConstraints = placesFoundConstraints
        
        
        
        /* EmptyView */
        
        let emptyViewConstraints: [NSLayoutConstraint] = [
            self.emptyView.topAnchor.constraint(equalTo: self.formsTableView.bottomAnchor),
            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]

        self.emptyViewConstraints = emptyViewConstraints
    }
}
