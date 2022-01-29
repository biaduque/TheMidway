//
//  MainView.swift
//  TheMidway
//
//  Created by Gui Reis on 18/01/22.
//

import UIKit

class MainView: UIView {
    
    /* MARK: -  Atributos */
    private lazy var emptyView = EmptyView()
    
    private var emptyViewConstraints: [NSLayoutConstraint] = []
    
    
    private let infoButton: UIButton
    
    
    // Sugestão
    
    private var suggestionLabel: UILabel
    
    private let suggestionCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal                // Direção da rolagem (se é horizontal ou vertical)
        layout.itemSize = CGSize(width: 200, height: 230)   // Define o tamanho da célula
        layout.minimumLineSpacing = 20                      // Espaço entre as células
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MainViewCollectionCell.self, forCellWithReuseIdentifier: MainViewCollectionCell.identifier)
        cv.backgroundColor = UIColor(named: "BackgroundColor")
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()
    
    
    // Encontros
    
    private var meetingsLabel: UILabel
    
    public let newMeetingButton: UIButton
    
    private let meetingsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor(named: "BackgroundColor")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.alwaysBounceVertical = false
        table.alwaysBounceHorizontal = false
        
        // Tamanho da célula
        table.rowHeight = 80
    
        table.register(MainViewTableCell.self, forCellReuseIdentifier: MainViewTableCell.identifier)
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        table.tableHeaderView = UIView(frame: frame)
        
        return table
    }()
    
    private var meetingsTableViewConstraints: [NSLayoutConstraint] = []
    
    

    /* MARK: -  */

    init() {
        self.infoButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        self.suggestionLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        
        self.meetingsLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.newMeetingButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(named: "BackgroundColor")
                
        self.addSubview(self.infoButton)
        
        self.addSubview(self.suggestionLabel)
        self.addSubview(self.suggestionCollection)
        
        self.addSubview(self.meetingsLabel)
        self.addSubview(self.newMeetingButton)
        self.addSubview(self.meetingsTableView)
        
        self.addSubview(self.emptyView)
                
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    // Configuração da View
    public func setTitles(suggestionText: String, meetingText: String, sizeFont:CGFloat, w:UIFont.Weight) -> Void {
        // Labels
        self.suggestionLabel.text = suggestionText
        self.suggestionLabel.font = .systemFont(ofSize: sizeFont, weight: w)
        
        self.meetingsLabel.text = meetingText
        self.meetingsLabel.font = .systemFont(ofSize: sizeFont, weight: w)
        
        // Botões
        let configIcon = UIImage.SymbolConfiguration(pointSize: sizeFont-10, weight: .semibold, scale: .large)
        self.newMeetingButton.setImage(UIImage(systemName: "plus", withConfiguration: configIcon), for: .normal)
        
        self.infoButton.setImage(UIImage(systemName: "questionmark.circle", withConfiguration: configIcon), for: .normal)
    }
    
    
    // Delegate & Datasource
    
    public func setSuggestionsCollectionDelegate(_ delegate: MainCollectionDelegate) -> Void {
        self.suggestionCollection.delegate = delegate
    }
    
    public func setSuggestionsCollectionDataSource(_ dataSource: MainCollectionDataSource) -> Void {
        self.suggestionCollection.dataSource = dataSource
    }
    
    
    public func setMeetingsTableDelegate(_ delegate: MainTableDelegate) -> Void {
        self.meetingsTableView.delegate = delegate
    }
    
    public func setMeetingsTableDataSource(_ dataSource: MainTableDataSource) -> Void {
        self.meetingsTableView.dataSource = dataSource
    }
    
    
    // Atualizando dados da Table
    public func updateMeetingsTableData() -> Void { self.meetingsTableView.reloadData() }
    
    
    // EmptyView
    
    public func activateEmptyView(num: Int) -> Void {
        if num == 0 {
            self.emptyView.isHidden = false
            NSLayoutConstraint.activate(self.emptyViewConstraints)
            
            if !self.emptyView.isDescendant(of: self) {
                self.addSubview(self.emptyView)
                print("Entrei aqui")
            }
            
            
            self.meetingsTableView.isHidden = true
            NSLayoutConstraint.deactivate(self.meetingsTableViewConstraints)

        } else {
            self.emptyView.isHidden = true
            NSLayoutConstraint.deactivate(self.emptyViewConstraints)
            self.emptyView.removeFromSuperview()

            self.meetingsTableView.isHidden = false
            NSLayoutConstraint.activate(self.meetingsTableViewConstraints)
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
        
        // Botão de Informação
        let infoButtonConstraints: [NSLayoutConstraint] = [
            self.infoButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            self.infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.infoButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.infoButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        NSLayoutConstraint.activate(infoButtonConstraints)
        
        
        
        /* Sugestão */
        
        // Label
        let suggestionsLabelConstraints: [NSLayoutConstraint] = [
            self.suggestionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50+35),
            self.suggestionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.suggestionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.suggestionLabel.bottomAnchor.constraint(equalTo: self.suggestionCollection.topAnchor)
        ]
        NSLayoutConstraint.activate(suggestionsLabelConstraints)
        
        
        // Collection
        let suggestionCollectionConstraints: [NSLayoutConstraint] = [
            self.suggestionCollection.topAnchor.constraint(equalTo: self.suggestionLabel.bottomAnchor, constant: betweenSpace),
            self.suggestionCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.suggestionCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.suggestionCollection.bottomAnchor.constraint(equalTo: self.meetingsLabel.topAnchor, constant: -betweenSpace)
            self.suggestionCollection.heightAnchor.constraint(equalToConstant: 250)
        ]
        NSLayoutConstraint.activate(suggestionCollectionConstraints)
        
        
        
        /*  Encontros */
        
        // Label
        let meetingsLabelConstraints: [NSLayoutConstraint] = [
            self.meetingsLabel.topAnchor.constraint(equalTo: self.suggestionCollection.bottomAnchor, constant: betweenSpace),
            self.meetingsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.meetingsLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(meetingsLabelConstraints)
        
        
        // Botão de novo encontro
        let newMeetingBtConstraints: [NSLayoutConstraint] = [
            self.newMeetingButton.topAnchor.constraint(equalTo: self.meetingsLabel.topAnchor),
            self.newMeetingButton.centerYAnchor.constraint(equalTo: self.meetingsLabel.centerYAnchor),
            self.newMeetingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.newMeetingButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.newMeetingButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        NSLayoutConstraint.activate(newMeetingBtConstraints)
        
        
        // TableView
        let meetingsTableConstraints: [NSLayoutConstraint] = [
            self.meetingsTableView.topAnchor.constraint(equalTo: self.meetingsLabel.bottomAnchor, constant: betweenSpace),
            self.meetingsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.meetingsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace)
        ]

        self.meetingsTableViewConstraints = meetingsTableConstraints
        
        
        
        /*  EmptyView */
        
        let emptyViewConstraints: [NSLayoutConstraint] = [
            self.emptyView.topAnchor.constraint(equalTo: self.meetingsLabel.bottomAnchor),
            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        
        self.emptyViewConstraints = emptyViewConstraints
        
    }
    
    
    
    /* MARK: -  Criação de Elementos */

    static func newLabel(color: UIColor?) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        // lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = color ?? .blue
        return lbl
    }
    
    
    static func newButton(color: UIColor?) -> UIButton {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        
        bt.tintColor = color ?? .blue
        return bt
    }
}
