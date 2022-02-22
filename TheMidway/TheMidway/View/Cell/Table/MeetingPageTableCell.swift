//
//  MeetingPageTableCell.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import UIKit

class MeetingPageTableCell: UITableViewCell {

    /* MARK: - Atributos */
    
    static let identifier = "IdMeetingPageTableCell"
    
    private let image: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        // imgView.backgroundColor = .red
        return imgView
    }()
    
    private var nameLabel: UILabel = {
        let lbl =  MainView.newLabel(color: .secondaryLabel)
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private var distanceLabel: UILabel = {
        let lbl =  MainView.newLabel(color: .secondaryLabel)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .right
        return lbl
    }()
    
    
    
    /* MARK: -  */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.backgroundColor = .secondarySystemBackground // UIColor(named: "BackgroundColor")
        
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.distanceLabel)
    
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setCellInfo(image: Int, name: LabelConfig, distance: LabelConfig) -> Void {
        self.image.image = UIImage(named: "Perfil 0\(image).png")
        
        self.nameLabel.text = name.text
        self.nameLabel.font = .systemFont(ofSize: name.sizeFont, weight: name.weight)
        
        self.distanceLabel.text = distance.text
        self.distanceLabel.font = .systemFont(ofSize: distance.sizeFont, weight: distance.weight)
    }
    
    
    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        let betweenSpace: CGFloat = 4
        
        let constraints: [NSLayoutConstraint] = [
            self.image.topAnchor.constraint(equalTo: self.topAnchor),
            self.image.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.image.widthAnchor.constraint(equalToConstant: self.frame.height),
            self.image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            
            self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: betweenSpace),
            self.nameLabel.leftAnchor.constraint(equalTo: self.image.rightAnchor),
            self.nameLabel.rightAnchor.constraint(equalTo: self.distanceLabel.leftAnchor, constant: -betweenSpace),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace),
            self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            
            self.distanceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: betweenSpace),
            self.distanceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -betweenSpace*2),
            self.distanceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace),
            self.distanceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.distanceLabel.widthAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
