//
//  ParticipantsTableCell.swift
//  TheMidway
//
//  Created by Gui Reis on 29/01/22.
//

import UIKit

class ParticipantsTableCell: UITableViewCell {
    
    /* MARK: - Atributos */
    
    static let identifier = "IdParticipantsTableCell"
    
    private let image: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private var titleLabel: UILabel
    
    private var subtitleLabel: UILabel = {
        let lbl =  MainView.newLabel(color: .secondaryLabel)
        lbl.numberOfLines = 2
        // lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .justified
        return lbl
    }()
    
    
    
    /* MARK: -  */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.titleLabel = MainView.newLabel(color: UIColor(named: "TitleLabel"))
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.backgroundColor = .secondarySystemBackground // UIColor(named: "BackgroundColor")
        
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)
    
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setCellTitle(titleText: LabelConfig, subtitleText: LabelConfig, image: Int) -> Void {
        self.titleLabel.text = titleText.text
        self.titleLabel.font = .systemFont(ofSize: titleText.sizeFont, weight: titleText.weight)
        
        self.subtitleLabel.text = subtitleText.text
        self.subtitleLabel.font = .systemFont(ofSize: subtitleText.sizeFont, weight: subtitleText.weight)
        
        self.image.image = UIImage(named: "Perfil 0\(image).png")
    }
    
    
    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        let betweenSpace: CGFloat = 4
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            self.image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.image.widthAnchor.constraint(equalToConstant: self.frame.height*1.5),
            self.image.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(imageConstraints)


        let titleLabelConstraints: [NSLayoutConstraint] = [
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: betweenSpace),
            self.titleLabel.leftAnchor.constraint(equalTo: self.image.rightAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(betweenSpace*2)),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        
        let subtitleLabelConstraints: [NSLayoutConstraint] = [
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: betweenSpace),
            self.subtitleLabel.leftAnchor.constraint(equalTo: self.image.rightAnchor),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(betweenSpace*2)),
            self.subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace)
        ]
        NSLayoutConstraint.activate(subtitleLabelConstraints)
    }
}
