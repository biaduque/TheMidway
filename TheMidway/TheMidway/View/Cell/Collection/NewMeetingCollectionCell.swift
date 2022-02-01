//
//  NewMeetingCollectionViewCell.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit

class NewMeetingCollectionCell: UICollectionViewCell {
    
    /* MARK: -  Atributos */
    
    static let identifier = "IdNewMeetingCollectionCell"
    
    private let titleLabel: UILabel
    
    private let checkButton: UIButton
    
    private let addressLabel: UILabel = {
        let lbl = MainViewTableCell.newLabelAjustable(color: .secondaryLabel)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let tagLabel: UILabel = {
        let lbl = MainView.newLabel(color: .secondaryLabel)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private let webButton: UIButton
    
    
    private var defaultButtonFontSize: CGFloat = 0
    
    
    
    /* MARK: -  */
    
    public override init(frame: CGRect) {
        self.titleLabel = MainViewTableCell.newLabelAjustable(color: UIColor(named: "TitleLabel"))
        self.checkButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        self.webButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: "BackgroundColor")
                
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.checkButton)
        self.contentView.addSubview(self.addressLabel)
        self.contentView.addSubview(self.tagLabel)
        self.contentView.addSubview(self.webButton)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setCellInfo(title: LabelConfig, address: LabelConfig, tag: PlacesCategories) -> Void {
        self.titleLabel.text = title.text
        self.titleLabel.font = .systemFont(ofSize: title.sizeFont, weight: title.weight)
        
        self.addressLabel.text = address.text
        self.addressLabel.font = .systemFont(ofSize: address.sizeFont, weight: address.weight)
        
        self.tagLabel.text = tag.localizedDescription
        self.tagLabel.backgroundColor = UIColor(named: tag.localizedDescription)?.withAlphaComponent(0.7)
        
        self.defaultButtonFontSize = title.sizeFont-2
        
        self.uncheckCell()
        //self.setIconButton(self.checkButton, icon: LabelConfig(text: "circle", sizeFont: self.defaultButtonFontSize, weight: .medium))
        self.setIconButton(self.webButton, icon: LabelConfig(text: "network", sizeFont: self.defaultButtonFontSize, weight: .medium))
    }
    
    
    public func hideNewMeetingViews(_ bool: Bool) -> Void {
        self.checkButton.isHidden = bool
        self.tagLabel.isHidden = bool
    }
    
    
    public func uncheckCell() -> Void {
        self.setIconButton(self.checkButton, icon: LabelConfig(text: "circle", sizeFont: self.defaultButtonFontSize, weight: .medium))
    }
    
    
    public func checkCell() -> Void {
        self.setIconButton(self.checkButton, icon: LabelConfig(text: "checkmark.circle.fill", sizeFont: self.defaultButtonFontSize, weight: .medium))
    }
    
    
    private func setIconButton(_ bt: UIButton, icon: LabelConfig) -> Void {
        let weight = UIImage.SymbolWeight(rawValue: Int(icon.weight.rawValue)) ?? .medium
        let configIcon = UIImage.SymbolConfiguration(pointSize: icon.sizeFont, weight: weight, scale: .large)
        bt.setImage(UIImage(systemName: icon.text, withConfiguration: configIcon), for: .normal)
    }
    
    
    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        let lateralSpace: CGFloat = 5
        let betweenSpace: CGFloat = 5
        
        let buttonSize: CGFloat = 25
        
        // Título do Lugar
        let titleLabelConstraints: [NSLayoutConstraint] = [
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: lateralSpace),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.titleLabel.rightAnchor.constraint(equalTo: self.checkButton.leftAnchor, constant: betweenSpace),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.addressLabel.topAnchor, constant: -lateralSpace)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        
        // Botão de seleção
        let checkButtonConstraints: [NSLayoutConstraint] = [
            self.checkButton.topAnchor.constraint(equalTo: self.titleLabel.topAnchor),
            self.checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            // self.checkButton.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
            self.checkButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.checkButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.checkButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        NSLayoutConstraint.activate(checkButtonConstraints)
        
        
        // Endereço
        let addressLabelConstraints: [NSLayoutConstraint] = [
            self.addressLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: betweenSpace),
            self.addressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.addressLabel.bottomAnchor.constraint(equalTo: self.tagLabel.topAnchor, constant: -betweenSpace),
            self.addressLabel.heightAnchor.constraint(equalToConstant: buttonSize*2)
        ]
        NSLayoutConstraint.activate(addressLabelConstraints)


        // Tag
        let tagLabelConstraints: [NSLayoutConstraint] = [
            self.tagLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor),
            self.tagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.tagLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -lateralSpace),
            self.tagLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -lateralSpace)
        ]
        NSLayoutConstraint.activate(tagLabelConstraints)


        // Botão para ir para web
        let webButtonConstraints: [NSLayoutConstraint] = [
            self.webButton.centerXAnchor.constraint(equalTo: self.checkButton.centerXAnchor),
            self.webButton.centerYAnchor.constraint(equalTo: self.tagLabel.centerYAnchor),
            self.webButton.bottomAnchor.constraint(equalTo: self.tagLabel.bottomAnchor),
            self.webButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.webButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ]
        NSLayoutConstraint.activate(webButtonConstraints)
    }
}
