//
//  SuggestionsView.swift
//  TheMidway
//
//  Created by Leticia Utsunomiya on 01/02/22.
//

import UIKit

class SuggestionsView: UIView {
    
    /* MARK: -  Atributos */
    
    private let image: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private let suggestionCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical                // Direção da rolagem (se é horizontal ou vertical)
        layout.itemSize = CGSize(width: 400, height: 120)   // Define o tamanho da célula
        layout.minimumLineSpacing = 20                      // Espaço entre as células
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NewMeetingCollectionCell.self, forCellWithReuseIdentifier: NewMeetingCollectionCell.identifier)
        cv.backgroundColor = UIColor(named: "BackgroundColor")
        cv.translatesAutoresizingMaskIntoConstraints = false

        return cv
    }()
    

    

    /* MARK: -  */

    init() {
      
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "BackgroundColor")
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
    
    public func setSuggestionsCollectionDelegate(_ delegate: MainCollectionDelegate) -> Void {
        self.suggestionCollection.delegate = delegate
    }
    
    public func setSuggestionsCollectionDataSource(_ dataSource: MainCollectionDataSource) -> Void {
        self.suggestionCollection.dataSource = dataSource
    }
    
    
//     Atualizando dados da Collection
    public func updateSuggestionsCollectionData() -> Void { self.suggestionCollection.reloadData() }
    
    
   
    /* MARK: -  Constraints */
    
    private func setConstraints() -> Void {
        let lateralSpace: CGFloat = 25
        let betweenSpace: CGFloat = 20
   
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.image.heightAnchor.constraint(equalToConstant: 180)
        ]
        NSLayoutConstraint.activate(imageConstraints)
        
       
        // Collection
        let suggestionCollectionConstraints: [NSLayoutConstraint] = [
            self.suggestionCollection.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: betweenSpace),
            self.suggestionCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.suggestionCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
             self.suggestionCollection.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace)
       
        ]
        NSLayoutConstraint.activate(suggestionCollectionConstraints)
        
    }

}
