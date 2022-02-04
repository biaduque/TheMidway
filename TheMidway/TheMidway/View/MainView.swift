//
//  MainView.swift
//  TheMidway
//
//  Created by Gui Reis on 18/01/22.
//

import UIKit

class MainView: UIViewWithEmptyView {
    
    /* MARK: -  Atributos */
    
    private let infoButton: UIButton
    
    // Sugestão
    
    private var suggestionLabel: UILabel
    
    private let suggestionCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 230)
        layout.minimumLineSpacing = 20
        
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
        
        table.rowHeight = 80
    
        table.register(MainViewTableCell.self, forCellReuseIdentifier: MainViewTableCell.identifier)
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        table.tableHeaderView = UIView(frame: frame)
        
        return table
    }()
        
    

    /* MARK: -  */

    override init() {
        self.infoButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        self.suggestionLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        
        self.meetingsLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.newMeetingButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        super.init()
    
        self.addSubview(self.infoButton)
        
        self.addSubview(self.suggestionLabel)
        self.addSubview(self.suggestionCollection)
        
        self.addSubview(self.meetingsLabel)
        self.addSubview(self.newMeetingButton)
        self.addSubview(self.meetingsTableView)
                        
        self.setConstraints()
        
        self.infoButton.isHidden = true     // Inativo até ser implementado o OnBoarding
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    /// Configuração da View
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
    
    
    /// Atualiza os dados da Table
    public func updateMeetingsTableData() -> Void {
        self.meetingsTableView.reloadData()
    }
    
    
    // Delegate & Datasource
    
    // Collection
    public func setSuggestionsCollectionDelegate(_ delegate: MainCollectionDelegate) -> Void {
        self.suggestionCollection.delegate = delegate
    }
    
    public func setSuggestionsCollectionDataSource(_ dataSource: MainCollectionDataSource) -> Void {
        self.suggestionCollection.dataSource = dataSource
    }
    
    
    // Table
    public func setMeetingsTableDelegate(_ delegate: MainTableDelegate) -> Void {
        self.meetingsTableView.delegate = delegate
    }
    
    public func setMeetingsTableDataSource(_ dataSource: MainTableDataSource) -> Void {
        self.meetingsTableView.dataSource = dataSource
    }
    
    
    // EmptyView
    
    /// Ativa/desativa a empty view da tela
    public override func activateEmptyView(num: Int) -> Void {
        var bool = true
        if num == 0 { bool = false }
        self.emptyView.isHidden = bool
        self.meetingsTableView.isHidden = !bool
    }

    
    
    /* MARK: -  Constraints */
    
    private func setConstraints() -> Void {
        let safeArea: CGFloat = 50
        let lateralSpace: CGFloat = 25
        let betweenSpace: CGFloat = 20
        
        let buttonSize: CGFloat = 25
        
        
        // Botão de Informação (inativo até ter o onboarding)
        let infoButtonConstraints: [NSLayoutConstraint] = [
            self.infoButton.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.infoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.infoButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.infoButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        NSLayoutConstraint.activate(infoButtonConstraints)
        

        let viewConstraints: [NSLayoutConstraint] = [
            // Sugestões
            self.suggestionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea), // +35
            self.suggestionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.suggestionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.suggestionLabel.bottomAnchor.constraint(equalTo: self.suggestionCollection.topAnchor),
            
            
            self.suggestionCollection.topAnchor.constraint(equalTo: self.suggestionLabel.bottomAnchor, constant: betweenSpace),
            self.suggestionCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.suggestionCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.suggestionCollection.heightAnchor.constraint(equalToConstant: 250),
            
            
            // Encontros
            
            self.meetingsLabel.topAnchor.constraint(equalTo: self.suggestionCollection.bottomAnchor, constant: betweenSpace),
            self.meetingsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.meetingsLabel.heightAnchor.constraint(equalToConstant: 50),
            
            
            self.newMeetingButton.topAnchor.constraint(equalTo: self.meetingsLabel.topAnchor),
            self.newMeetingButton.centerYAnchor.constraint(equalTo: self.meetingsLabel.centerYAnchor),
            self.newMeetingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.newMeetingButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.newMeetingButton.widthAnchor.constraint(equalToConstant: buttonSize),
            
            
            self.meetingsTableView.topAnchor.constraint(equalTo: self.meetingsLabel.bottomAnchor, constant: betweenSpace),
            self.meetingsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.meetingsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.meetingsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace),
        ]
        NSLayoutConstraint.activate(viewConstraints)
        
                
        /*  EmptyView */
        
        let emptyViewConstraints: [NSLayoutConstraint] = [
            self.emptyView.topAnchor.constraint(equalTo: self.meetingsLabel.bottomAnchor),
            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(emptyViewConstraints)
    }
    
    
    
    /* MARK: - Criação de Elementos */

    static func newLabel(color: UIColor?) -> UILabel {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
