//
//  NewMeetingCollectionViewCell.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit

class NewMeetingCollectionCell: UICollectionViewCell {
    
    /* MARK: -  Atributos */
    
    static var identifier = "IdNewMeetingCollectionCell"
    
    private var myView = PlaceVisualization()
    
    private var checked: Bool = false
    
    
    override var isSelected: Bool {
        didSet {
            self.setBorderWhen(isChecked: self.isSelected)
        }
    }
    
    
    
    /* MARK: -  */
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(named: "BackgroundColor")
                
        self.contentView.addSubview(self.myView)
        
        self.setBorderWhen(isChecked: self.checked)
        
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
    
    
    /// Define a borda de acordo
    public func setBorderWhen(isChecked bool: Bool) -> Void {
        var borderWidth: CGFloat = 0
        var borderColor: UIColor = UIColor(named: "BackgroundColor")!
        
        if bool {
            borderWidth = 1.5
            borderColor = UIColor(named: "AccentColor")!
        }
        
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        self.myView.isSelected(bool)
    }

        
    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        let lateralSpace: CGFloat = 5
        
        let viewConstraints: [NSLayoutConstraint] = [
            self.myView.topAnchor.constraint(equalTo: self.topAnchor, constant: lateralSpace),
            self.myView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -lateralSpace),
            self.myView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.myView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
}
