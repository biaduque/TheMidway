//
//  ParticipantsView.swift
//  TheMidway
//
//  Created by Gui Reis on 29/01/22.
//

import UIKit

class ParticipantsView: UIViewWithEmptyView {
    
    /* MARK: - Atributos */

    public let addPersonButton: UIButton
    
    private var confirmedLabel: UILabel
    private let confirmedTableView: UITableView
    
    private var notFoundLabel: UILabel
    private let notFoundTableView: UITableView
    
    
    private let cellHeight: CGFloat = 70
    
    
    
    /* MARK: - */
    
    override init() {
        self.addPersonButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        self.confirmedLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.confirmedTableView = ParticipantsView.newTable(cellHeight: self.cellHeight, backgroundColor: .secondarySystemBackground)
        
        self.notFoundLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        self.notFoundTableView = ParticipantsView.newTable(cellHeight: self.cellHeight, backgroundColor: .secondarySystemBackground)
        
        
        super.init()
        
        // Registrando as células
        self.confirmedTableView.register(ParticipantsTableCell.self, forCellReuseIdentifier: ParticipantsTableCell.identifier)
        
        self.notFoundTableView.register(ParticipantsTableCell.self, forCellReuseIdentifier: ParticipantsTableCell.identifier)
        
        
        self.addSubview(self.confirmedLabel)
        self.addSubview(self.addPersonButton)
        self.addSubview(self.confirmedTableView)
        
        self.addSubview(self.notFoundLabel)
        self.addSubview(self.notFoundTableView)
        
        
        self.setConstraints()
        
        self.activateEmptyView(num: 0)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    // Configuração da View
    
    public func setTitles(confirmedText: String, notFoundText: String, sizeFont:CGFloat, w:UIFont.Weight) -> Void {
        // Labels
        self.confirmedLabel.text = confirmedText
        self.confirmedLabel.font = .systemFont(ofSize: sizeFont, weight: w)
        
        self.notFoundLabel.text = notFoundText
        self.notFoundLabel.font = .systemFont(ofSize: sizeFont, weight: w)
        
        // Botões
        let configIcon = UIImage.SymbolConfiguration(pointSize: sizeFont-10, weight: .semibold, scale: .large)
        self.addPersonButton.setImage(UIImage(systemName: "person.fill.badge.plus", withConfiguration: configIcon), for: .normal)
    }
    
    
    /// Retorna a tag da tableview (variávle usada para identificar qual célula foi selecionada da tabela)
    public func getTagTableNotFound() -> Int {
        return self.notFoundTableView.tag
    }
    
    
    // Delegate & Datasource
    
    public func setConfirmedTableDelegate(_ delegate: ParticipantsTableDelegate) -> Void {
        self.confirmedTableView.delegate = delegate
    }

    public func setConfirmedTableDataSource(_ dataSource: ParticipantsTableDataSource) -> Void {
        self.confirmedTableView.dataSource = dataSource
    }


    public func setNotFoundTableDelegate(_ delegate: ParticipantsTableDelegate) -> Void {
        self.notFoundTableView.delegate = delegate
    }

    public func setNotFoundTableDataSource(_ dataSource: ParticipantsTableDataSource) -> Void {
        self.notFoundTableView.dataSource = dataSource
    }
    
    
    // Atualizando dados das tabelas
    
    public func updateTableDatas() -> Void {
        self.confirmedTableView.reloadData()
        self.notFoundTableView.reloadData()
    }
    
    
    public func setNotFoundVisibility(bool: Bool) -> Void {
        self.notFoundLabel.isHidden = bool
        self.notFoundTableView.isHidden = bool
    }
    
    
    public func setConfirmedVisibility(bool: Bool) -> Void {
        self.confirmedLabel.isHidden = bool
        self.confirmedTableView.isHidden = bool
    }
    
    
    // EmptyView
    
    /// Ativa/desativa a empty view da tela
    public override func activateEmptyView(num: Int) -> Void {
        var bool = true
        if num == 0 { bool = false }
        self.emptyView.isHidden = bool
        
        
        self.addPersonButton.isHidden = !bool
        
        self.confirmedLabel.isHidden = !bool
        self.confirmedTableView.isHidden = !bool
        
        self.notFoundLabel.isHidden = !bool
        self.notFoundTableView.isHidden = !bool
    }
    
    
    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        let safeArea: CGFloat = 60
        
        let lateralSpace: CGFloat = 25
        let betweenSpace: CGFloat = 15
        
        let buttonSize: CGFloat = 25
        let labelSize: CGFloat = 30
        
        
        // Botão adicionar novas pessoas
        let viewConstraints: [NSLayoutConstraint] = [
            self.addPersonButton.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.addPersonButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.addPersonButton.centerYAnchor.constraint(equalTo: self.confirmedLabel.centerYAnchor),
            self.addPersonButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.addPersonButton.widthAnchor.constraint(equalToConstant: buttonSize),
            
            
            // Confirmados
            self.confirmedLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.confirmedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.confirmedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.confirmedLabel.heightAnchor.constraint(equalToConstant: labelSize),
            
        
            self.confirmedTableView.topAnchor.constraint(equalTo: self.confirmedLabel.bottomAnchor, constant: betweenSpace),
            self.confirmedTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.confirmedTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.confirmedTableView.heightAnchor.constraint(equalToConstant: self.cellHeight*4),
            
            
            // Não confirmados
            self.notFoundLabel.topAnchor.constraint(equalTo: self.confirmedTableView.bottomAnchor, constant: betweenSpace),
            self.notFoundLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.notFoundLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.notFoundLabel.heightAnchor.constraint(equalToConstant: labelSize),
            
            
            self.notFoundTableView.topAnchor.constraint(equalTo: self.notFoundLabel.bottomAnchor, constant: betweenSpace),
            self.notFoundTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.notFoundTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.notFoundTableView.heightAnchor.constraint(equalToConstant: self.cellHeight*4)
        ]
        NSLayoutConstraint.activate(viewConstraints)
        

        // Empty View
        let emptyViewConstraints: [NSLayoutConstraint] = [
            self.emptyView.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(emptyViewConstraints)
    }
    
    
    
    /* MARK: - Criação de Elementos */
    
    static func newTable(cellHeight: CGFloat, backgroundColor: UIColor) -> UITableView {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = backgroundColor
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.alwaysBounceVertical = false
        table.alwaysBounceHorizontal = false
        
        // Tamanho da célula
        table.rowHeight = cellHeight
        
        // Tirando o espaço do topo
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        table.tableHeaderView = UIView(frame: frame)
        
        return table
    }
}
