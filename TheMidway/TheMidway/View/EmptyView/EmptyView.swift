//
//  EmptyView.swift
//  TheMidway
//
//  Created by Gui Reis on 20/01/22.
//

import UIKit

class EmptyView: UIView {
    
    /* MARK: - Atributos */
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()


    private let image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.clipsToBounds = true
        img.layer.masksToBounds = true
        return img
    }()

    private var infoLabel: UILabel = {
        let lbl = MainView.newLabel(color: UIColor(named: "AccentColor"))
        
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.textAlignment = .center
        lbl.sizeToFit()
        lbl.numberOfLines = 2
        return lbl
    }()


    private let button: UIButton = {
        let bt = MainView.newButton(color: .none)
        bt.backgroundColor = UIColor(named: "Button")?.withAlphaComponent(0.4)
        bt.clipsToBounds = true
        bt.layer.cornerRadius = 10
        return bt
    }()
    
    
    
    /* MARK: -  */
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
                
        self.addSubview(self.container)
        self.container.addSubview(self.image)
        self.container.addSubview(self.infoLabel)
        self.container.addSubview(self.button)
        
        // self.setBackgroundColors()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func didMoveToSuperview() -> Void {
        super.didMoveToSuperview()
        
        self.setConstraints()
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setEmptyViewInfo(img: String, text: LabelConfig, button: LabelConfig) {
        self.image.image = UIImage(named: img)
        
        self.infoLabel.text = text.text
        self.infoLabel.font = UIFont.systemFont(ofSize: text.sizeFont, weight: text.weight)
        
        self.button.setTitle(button.text, for: .normal)
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: button.sizeFont, weight: button.weight)
    }
    
    
    public func getButton() -> UIButton {
        return self.button
    }
    
    
    private func setBackgroundColors() -> Void {
        self.backgroundColor = .blue
        self.container.backgroundColor = .cyan
        self.image.backgroundColor = .red
    }
    
    
    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        
        let lateralSpace: CGFloat = 35
        let betweenSpace: CGFloat = 20
        
        let viewsHeight: CGFloat = 50
        
        let totalHeightUsed: CGFloat = 135 + betweenSpace*2 + viewsHeight*2

        let completeViewConstraints: [NSLayoutConstraint] = [
            self.container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.container.heightAnchor.constraint(equalToConstant: totalHeightUsed),
            
            
            self.image.topAnchor.constraint(equalTo: self.container.topAnchor),
            self.image.centerXAnchor.constraint(equalTo: self.container.centerXAnchor),
            self.image.heightAnchor.constraint(equalToConstant: 110),
            self.image.widthAnchor.constraint(equalToConstant: viewsHeight*3.3),
            
            self.infoLabel.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: betweenSpace),
            self.infoLabel.centerXAnchor.constraint(equalTo: self.container.centerXAnchor),
            self.infoLabel.rightAnchor.constraint(equalTo: self.self.container.rightAnchor),
            self.infoLabel.leftAnchor.constraint(equalTo: self.self.container.leftAnchor),
            self.infoLabel.heightAnchor.constraint(equalToConstant: viewsHeight),
            
            
            self.button.topAnchor.constraint(equalTo: self.infoLabel.bottomAnchor, constant: betweenSpace),
            self.button.centerXAnchor.constraint(equalTo: self.container.centerXAnchor),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace*2),
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace*2),
            self.button.heightAnchor.constraint(equalToConstant: viewsHeight)
        ]
        NSLayoutConstraint.activate(completeViewConstraints)
    }
    
}
