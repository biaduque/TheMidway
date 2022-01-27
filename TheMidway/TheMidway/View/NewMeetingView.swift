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
    
    public let formsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor(named: "BackgroundColor") // .secondarySystemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.alwaysBounceVertical = false
        table.alwaysBounceHorizontal = false
        
        table.isScrollEnabled = false
        
        table.clipsToBounds = true
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 7
        
        // Tamanho da célula
        table.rowHeight = 45
    
        table.register(NewMeetingTableTitleCell.self, forCellReuseIdentifier: NewMeetingTableTitleCell.identifier)
        table.register(NewMeetingTableDateCell.self, forCellReuseIdentifier: NewMeetingTableDateCell.identifier)
        table.register(NewMeetingTableParticipantsCell.self, forCellReuseIdentifier: NewMeetingTableParticipantsCell.identifier)
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        
        let view = UIView(frame: frame)
        table.tableHeaderView = view
        table.tableFooterView = view
         table.sectionHeaderHeight = .leastNormalMagnitude
         table.sectionFooterHeight = 20
        
        table.contentInset = .zero
        
        return table
    }()
    
    
    // Lugares encontrados
    
    private var placesFoundLabel: UILabel
    
    public let retryButton: UIButton
    
    public let placesFoundCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal                // Direção da rolagem (se é horizontal ou vertical)
        layout.itemSize = CGSize(width: 300, height: 120)   // Define o tamanho da célula
        layout.minimumLineSpacing = 15                      // Espaço entre as células

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NewMeetingCollectionCell.self, forCellWithReuseIdentifier: NewMeetingCollectionCell.identifier)
        cv.backgroundColor = UIColor(named: "BackgroundColor")
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
        
        // self.addSubview(self.emptyView)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    public func setTitles(placeFoundText: LabelConfig) -> Void {
        self.placesFoundLabel.text = placeFoundText.text
        self.placesFoundLabel.font = .systemFont(ofSize: placeFoundText.sizeFont, weight: placeFoundText.weight)
        
        // Botões
        let configIcon = UIImage.SymbolConfiguration(pointSize: placeFoundText.sizeFont, weight: .semibold, scale: .large)
        
        self.retryButton.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configIcon), for: .normal)
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
        let placesFoundLabelConstraints: [NSLayoutConstraint] = [
            self.placesFoundLabel.topAnchor.constraint(equalTo: self.formsTableView.bottomAnchor, constant: betweenSpace*1.2),
            self.placesFoundLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.placesFoundLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.placesFoundLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(placesFoundLabelConstraints)
        
        
        // Botão de novo encontro
        let retryButtonConstraints: [NSLayoutConstraint] = [
            self.retryButton.topAnchor.constraint(equalTo: self.placesFoundLabel.topAnchor),
            self.retryButton.centerYAnchor.constraint(equalTo: self.placesFoundLabel.centerYAnchor),
            self.retryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.retryButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.retryButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        NSLayoutConstraint.activate(retryButtonConstraints)
        
        
        // Collection
        let placesFoundCollectionConstraints: [NSLayoutConstraint] = [
            self.placesFoundCollection.topAnchor.constraint(equalTo: self.placesFoundLabel.bottomAnchor, constant: betweenSpace/2),
            self.placesFoundCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.placesFoundCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.placesFoundCollection.heightAnchor.constraint(equalToConstant: 140)
        ]
        NSLayoutConstraint.activate(placesFoundCollectionConstraints)
        
        
        // Mapa
        let mapConstraints: [NSLayoutConstraint] = [
            self.mapView.topAnchor.constraint(equalTo: self.placesFoundCollection.bottomAnchor, constant: betweenSpace/2),
            self.mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 2)
            // self.mapView.heightAnchor.constraint(equalToConstant: 140)
        ]
        NSLayoutConstraint.activate(mapConstraints)
        
        
        /* EmptyView */
        
//        let emptyViewConstraints: [NSLayoutConstraint] = [
//            self.emptyView.topAnchor.constraint(equalTo: self.formsTableView.bottomAnchor),
//            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
//            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
//            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//        ]
//
//        self.emptyViewConstraints = emptyViewConstraints
    }
}
