//
//  MainViewCollectionCell.swift
//  TheMidway
//
//  Created by Gui Reis on 20/01/22.
//

import UIKit

class MainViewCollectionCell: UICollectionViewCell {
    
    // MARK: - Atributos
    
    static let identifier = "IdMainViewCollectionCell"
    
    private let image: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private var label: UILabel
    
    
    // MARK: -
    
    public override init(frame: CGRect) {
        self.label = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        
        super.init(frame: frame)
        
        self.addSubview(self.image)
        self.addSubview(self.label)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    // MARK: - Encapsulamento
    
    public func setContentView(text: String, sizeFont:CGFloat, w:UIFont.Weight) -> Void {
        self.label.text = text
        self.label.font = .systemFont(ofSize: sizeFont, weight: w)
        
        self.image.image = UIImage(named: "\(text) Icon.png")
    }
    
    
    
    
    // MARK: - Constraints
    public func setConstraints() -> Void {
        
        // Image View
        let collectionConstraints: [NSLayoutConstraint] = [
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.image.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.image.heightAnchor.constraint(equalToConstant: 200)
        ]
        NSLayoutConstraint.activate(collectionConstraints)
        
        
        // Label
        let labelConstraints: [NSLayoutConstraint] = [
            self.label.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 5),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    // MARK: - Configurações
    
    public override func prepareForReuse() -> Void {
        super.prepareForReuse()
        
        self.label.text = nil
        self.image.image = nil
    }
    
}
