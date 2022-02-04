//
//  PlaceVisualization.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit

class PlaceVisualization: UIView {
    
    /* MARK: -  Atributos */
    
    private let titleLabel: UILabel
    
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
    
    
    private var style: PlaceVisualizationStyle = .complete
    
    
    
    /* MARK: -  */
    
    init(style: PlaceVisualizationStyle = .complete) {
        self.titleLabel = MainViewTableCell.newLabelAjustable(color: UIColor(named: "TitleLabel"))
    
        self.webButton = MainView.newButton(color: UIColor(named: "AccentColor"))
        self.webButton.tag = 0
        
        super.init(frame: .zero)
        
        if style != self.style {
            self.setStyle(style: style)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.cornerRadius = 10
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.addressLabel)
        self.addSubview(self.tagLabel)
        self.addSubview(self.webButton)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Encapsulamento */
    
    /// Configura as informações das views
    public func setInfo(title: LabelConfig, address: LabelConfig, tag: PlacesCategories) -> Void {
        self.titleLabel.configureLabelText(with: title)
        
        self.addressLabel.configureLabelText(with: address)
        
        self.tagLabel.text = tag.localizedDescription
        self.tagLabel.backgroundColor = UIColor(named: tag.localizedDescription)?.withAlphaComponent(0.6)
        
        self.setIconButton(self.webButton, icon: LabelConfig(text: "safari", sizeFont: title.sizeFont, weight: .medium))
    }
    
    
    public func getWebButton() -> UIButton { return self.webButton }
    
    
    /// Define o estilo da célula
    public func setStyle(style: PlaceVisualizationStyle) -> Void {
        switch style {
        case .complete:
            self.tagLabel.isHidden = false
            self.webButton.isHidden = false
        case .withoutTag:       self.tagLabel.isHidden = true
        case .withoutWebButton: self.webButton.isHidden = true
        }
        
        self.style = style
    }
    
    
    /// Altera a cor da label caso ela for selecionada (células de collection)
    public func isSelected(_ bool: Bool) -> Void {
        if bool {
            self.backgroundColor = .secondarySystemBackground
        } else {
            self.backgroundColor = UIColor(named: "BackgroundColor")
        }
    }
        
    

    /* MARK: - Constraints */
        
    public override func layoutSubviews() -> Void {
        let lateralSpace: CGFloat = 5
        let betweenSpace: CGFloat = 4
        
        let buttonSize: CGFloat = 25
            
        
        let viewConstraints: [NSLayoutConstraint] = [
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: addressLabel.topAnchor),
        
            
            self.addressLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: betweenSpace),
            self.addressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.addressLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.addressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.addressLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.addressLabel.heightAnchor.constraint(equalToConstant: self.frame.height/3),
            
            
            self.tagLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: betweenSpace),
            self.tagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tagLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -lateralSpace),
            self.tagLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace),
            
            
            self.webButton.centerYAnchor.constraint(equalTo: self.tagLabel.centerYAnchor),
            self.webButton.bottomAnchor.constraint(equalTo: self.tagLabel.bottomAnchor),
            self.webButton.heightAnchor.constraint(equalToConstant: buttonSize),
            self.webButton.widthAnchor.constraint(equalToConstant: buttonSize),
            self.webButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    
    
    /* MARK: - Configurações */
    
    private func setIconButton(_ bt: UIButton, icon: LabelConfig) -> Void {
        let weight = UIImage.SymbolWeight(rawValue: Int(icon.weight.rawValue)) ?? .medium
        let configIcon = UIImage.SymbolConfiguration(pointSize: icon.sizeFont, weight: weight, scale: .large)
        bt.setImage(UIImage(systemName: icon.text, withConfiguration: configIcon), for: .normal)
    }
}
