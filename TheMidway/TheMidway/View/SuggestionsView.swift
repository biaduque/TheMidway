//
//  SuggestionsView.swift
//  TheMidway
//
//  Created by Leticia Utsunomiya on 01/02/22.
//

import UIKit

class SuggestionsView: UIViewWithEmptyView {
    
    /* MARK: -  Atributos */
    
    private let image: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
     
        return imgView
    }()
    
    private let suggestionCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 350, height: 120)   // Define o tamanho da célula
        layout.minimumLineSpacing = 10                      // Espaço entre as células
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(SuggestionsCollectionCell.self, forCellWithReuseIdentifier: SuggestionsCollectionCell.identifier)
        cv.backgroundColor = UIColor(named: "BackgroundColor")
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()
    

    

    /* MARK: -  */

    override init() {
        super.init()
        
        self.emptyView.setStyle(style: .justVisualisation)
        
        self.addSubview(self.image)
        self.addSubview(self.suggestionCollection)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    // Configuração da View
    public func setImage(name: String) -> Void {
        self.image.image = UIImage(named: "\(name) Cover.png")
    }
    
    
    // Delegate & Datasource
    
    public func setSuggestionsCollectionDelegate(_ delegate: SuggestionsCollectionDelegate) -> Void {
        self.suggestionCollection.delegate = delegate
    }
    
    public func setSuggestionsCollectionDataSource(_ dataSource: SuggestionsCollectionDataSource) -> Void {
        self.suggestionCollection.dataSource = dataSource
    }
    
    
    // Atualizando dados da Collection
    public func updateSuggestionsCollectionData() -> Void { self.suggestionCollection.reloadData() }
    
    
    // EmptyView
    
    public override func activateEmptyView(num: Int) -> Void {
        var bool = true
        if num == 0 { bool = false }
        self.emptyView.isHidden = bool

        self.suggestionCollection.isHidden = !bool
    }
    
    
   
    /* MARK: -  Constraints */
    
    private func setConstraints() -> Void {
        let lateralSpace: CGFloat = 15
        let betweenSpace: CGFloat = 20
   
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.image.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.image.heightAnchor.constraint(equalToConstant: 180),
            
            
            self.suggestionCollection.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: betweenSpace),
            self.suggestionCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.suggestionCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.suggestionCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
       
        // Empty View
        let emptyViewConstraints: [NSLayoutConstraint] = [
            self.emptyView.topAnchor.constraint(equalTo: self.image.bottomAnchor),
            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(emptyViewConstraints)
    }
}
