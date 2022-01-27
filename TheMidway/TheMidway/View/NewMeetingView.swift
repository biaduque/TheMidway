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
    
//    private var scroll: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//
//        scroll.alwaysBounceHorizontal = true
//        scroll.alwaysBounceVertical = true
//        return scroll
//    }()
    
    
    public let infoButton: UIButton
    
    
    // Título
    
    private var titleViewLabel: UILabel
    
    
    // Informações de Cadastro
    
    public let formsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .red // UIColor(named: "BackgroundColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.alwaysBounceVertical = false
        table.alwaysBounceHorizontal = false
        
        table.isScrollEnabled = false
        
        // Tamanho da célula
        table.rowHeight = 40
    
        table.register(NewMeetingTableTitleCell.self, forCellReuseIdentifier: NewMeetingTableTitleCell.identifier)
        table.register(NewMeetingTableDateCell.self, forCellReuseIdentifier: NewMeetingTableDateCell.identifier)
        table.register(NewMeetingTableParticipantsCell.self, forCellReuseIdentifier: NewMeetingTableParticipantsCell.identifier)
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        
        let view = UIView(frame: frame)
        table.tableHeaderView = view
        table.tableFooterView = view
        
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
        self.infoButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        self.titleViewLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        
        self.placesFoundLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.retryButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        super.init(frame: .zero)
    
        self.backgroundColor = UIColor(named: "BackgroundColor")
                
        self.addSubview(self.infoButton)
        
        self.addSubview(self.titleViewLabel)
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
    
    public func setTitles(titleViewText: LabelConfig, placeFoundText: LabelConfig) -> Void {
        // Labels
        self.titleViewLabel.text = titleViewText.text
        self.titleViewLabel.font = .systemFont(ofSize: titleViewText.sizeFont, weight: titleViewText.weight)
        
        self.placesFoundLabel.text = placeFoundText.text
        self.placesFoundLabel.font = .systemFont(ofSize: placeFoundText.sizeFont, weight: placeFoundText.weight)
        
        // Botões
        let configIcon = UIImage.SymbolConfiguration(pointSize: titleViewText.sizeFont-10, weight: .semibold, scale: .large)
        
        self.infoButton.setImage(UIImage(systemName: "questionmark.circle", withConfiguration: configIcon), for: .normal)
        
        self.retryButton.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configIcon), for: .normal)
    }
    
    
    public func activateEmptyView(num: Int) -> Void {
        if num == 0 {
            self.emptyView.isHidden = false
            NSLayoutConstraint.activate(self.emptyViewConstraints)
            
            if !self.emptyView.isDescendant(of: self) {
                self.addSubview(self.emptyView)
            }
        
//            self.meetingsTableView.isHidden = true
//            NSLayoutConstraint.deactivate(self.meetingsTableViewConstraints)

        } else {
            self.emptyView.isHidden = true
            NSLayoutConstraint.deactivate(self.emptyViewConstraints)
            self.emptyView.removeFromSuperview()

//            self.meetingsTableView.isHidden = false
//            NSLayoutConstraint.activate(self.meetingsTableViewConstraints)
        }
    }
    
    
    public func setEmptyViewInfo(img: String, label: LabelConfig, button: LabelConfig) {
        self.emptyView.setEmptyViewInfo(img: img, text: label, button: button)
    }
    
    public func getEmptyViewButton() -> UIButton {
        return self.emptyView.getButton()
    }
    
    
    
    /* MARK: -  Constraints */
    
    private func setConstraints() -> Void {
        let lateralSpace: CGFloat = 25
        let betweenSpace: CGFloat = 20
        
        let buttonSize: CGFloat = 25
        
        // Label
        let titleViewLabelConstraints: [NSLayoutConstraint] = [
            self.titleViewLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            self.titleViewLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.titleViewLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.titleViewLabel.bottomAnchor.constraint(equalTo: self.formsTableView.topAnchor, constant: -betweenSpace)
        ]
        NSLayoutConstraint.activate(titleViewLabelConstraints)
        
        // Botão de Informação
        let infoButtonConstraints: [NSLayoutConstraint] = [
            self.infoButton.topAnchor.constraint(equalTo: self.titleViewLabel.topAnchor),
            self.infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.infoButton.centerYAnchor.constraint(equalTo: self.titleViewLabel.centerYAnchor),
            self.infoButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.infoButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        NSLayoutConstraint.activate(infoButtonConstraints)
        
        
        /* Formulário */
        
        let formsTableViewConstraints: [NSLayoutConstraint] = [
            self.formsTableView.topAnchor.constraint(equalTo: self.titleViewLabel.bottomAnchor, constant: betweenSpace*2),
            self.formsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.formsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.formsTableView.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(formsTableViewConstraints)
        
        
        /*  Lugares encotrados */
        
        // Label
        let placesFoundLabelConstraints: [NSLayoutConstraint] = [
            self.placesFoundLabel.topAnchor.constraint(equalTo: self.formsTableView.bottomAnchor, constant: betweenSpace),
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
