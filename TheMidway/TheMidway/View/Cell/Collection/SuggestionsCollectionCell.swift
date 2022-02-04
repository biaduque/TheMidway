//
//  SuggestionsCollectionCell.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit

class SuggestionsCollectionCell: UICollectionViewCell {
    
    /* MARK: -  Atributos */
    
    static var identifier = "IdSuggestionsCollectionCell"
    
    private var myView = PlaceVisualization(style: .withoutTag)
    
    
    
    /* MARK: -  */
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(named: "BackgroundColor")
                
        self.contentView.addSubview(self.myView)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setCellInfo(title: LabelConfig, address: LabelConfig, tag: PlacesCategories) -> Void {
        self.myView.setInfo(title: title, address: address, tag: tag)
    }
    
    
    public func getWebButton() -> UIButton {
        return self.myView.getWebButton()
    }
    

    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        let lateralSpace: CGFloat = 4
        
        let viewConstraints: [NSLayoutConstraint] = [
            self.myView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: lateralSpace),
            self.myView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -lateralSpace),
            self.myView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: lateralSpace),
            self.myView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -lateralSpace),
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
}
