//
//  NewMeetingView.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit
import MapKit

class NewMeetingView: UIViewWithEmptyView {

    /* MARK: -  Atributos */
        
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
        cv.allowsMultipleSelection = false
        return cv
    }()
    
    
    private let suggestionPlaceView = PlaceVisualization()
    
    // Mapa
    
    public let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        
        map.layer.cornerRadius = 10
        return map
    }()
    
    
    private var placesFoundLabelText: String = ""
    
    
    
    /* MARK: -  */
    
    override init() {
        self.placesFoundLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.retryButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        super.init()
        
        // self.suggestionPlaceView.backgroundColor = .red
    
        self.addSubview(self.formsTableView)
        
        self.addSubview(self.placesFoundLabel)
        self.addSubview(self.retryButton)
        self.addSubview(self.placesFoundCollection)
        
        self.addSubview(self.mapView)
        
        self.addSubview(self.emptyView)
        
        self.addSubview(self.suggestionPlaceView)
        
        self.setConstraints()
        
        self.setRetryButtonVisible(true)
        
        self.suggestionPlaceView.isHidden = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Define os textos e botões da tela
    public func setTitles(placeFoundText: LabelConfig) -> Void {
        self.placesFoundLabelText = placeFoundText.text
        self.placesFoundLabel.configureLabelText(with: placeFoundText)
        
        // Botões
        let configIcon = UIImage.SymbolConfiguration(pointSize: placeFoundText.sizeFont, weight: .semibold, scale: .large)
        
        self.retryButton.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configIcon), for: .normal)
    }
    
    
    /// Define a quantidade de locais encontrados
    public func setPlaceFoundCount(_ num: Int) -> Void {
        self.placesFoundLabel.text = "\(self.placesFoundLabelText): \(num)"
    }
    
    
    /// Define o número de participantes que foram selecionados
    public func setParticipantsCount(_ num: Int) -> Void {
        // Acessa a célula
        guard let cell = self.formsTableView.cellForRow(at: NSIndexPath(row: 1, section: 1) as IndexPath) as? NewMeetingTableParticipantsCell else {
            return
        }
        cell.setParticipantsCount(num: num)
    }
    
    
    /// Pega a célula selecionada
    public func getCellSelected() -> Int {
        let cell = self.placesFoundCollection.indexPathsForSelectedItems ?? []
        if cell.isEmpty {return -1}
        return cell[0].row
    }
    
    
    /// Define se o novo encontro veio da área de sugestões
    public func isSuggestionPlace(_ bool: Bool) -> Void {
        self.suggestionPlaceView.isHidden = !bool
        self.placesFoundCollection.isHidden = true
    }
    
    
    /// Pega o botão de navegação pra web
    public func getWebButton() -> UIButton {
        return self.suggestionPlaceView.getWebButton()
    }
    
    
    /// Define as informações do lugar escolhido pela sugestão
    public func setSuggestionInfo(title: LabelConfig, address: LabelConfig, tag: PlacesCategories) -> Void {
        self.suggestionPlaceView.setInfo(title: title, address: address, tag: tag)
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
    
    public override func activateEmptyView(num: Int) -> Void {
        var bool = true
        if num == 0 { bool = false }
        self.emptyView.isHidden = bool
        
        self.placesFoundLabel.isHidden = !bool
        self.placesFoundCollection.isHidden = !bool
        self.mapView.isHidden = !bool
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
        
        
        /* Lugares encontrados */
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
        NSLayoutConstraint.activate(placesFoundConstraints)
        
        
        /* Lugar da sugestão */
        let suggestionPlaceViewConstraints: [NSLayoutConstraint] = [
            self.suggestionPlaceView.topAnchor.constraint(equalTo: self.placesFoundLabel.bottomAnchor, constant: betweenSpace),
            self.suggestionPlaceView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.suggestionPlaceView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.suggestionPlaceView.heightAnchor.constraint(equalToConstant: 120),
        ]
        NSLayoutConstraint.activate(suggestionPlaceViewConstraints)
        
        
        /* EmptyView */
        let emptyViewConstraints: [NSLayoutConstraint] = [
            self.emptyView.topAnchor.constraint(equalTo: self.formsTableView.bottomAnchor),
            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(emptyViewConstraints)
    }
}
