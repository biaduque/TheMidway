//
//  NewMeetingParticipantsTableCell.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit

class NewMeetingTableParticipantsCell: UITableViewCell {

    /* MARK: - Atributos */
    
    static let identifier = "IdNewMeetingTableParticipantsCell"
        
    private var leftImage: UIImageView
    
    private let leftLabel: UILabel
    
    
    private var rightImage: UIImageView
    
    private let rightLabel: UILabel = {
        let lbl = MainView.newLabel(color: .secondaryLabel)
        lbl.textAlignment = .right
        return lbl
    }()
    
    /* MARK: -  */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.leftLabel = MainView.newLabel(color: .secondaryLabel)
        self.leftImage = NewMeetingTableDateCell.newImageView(color: UIColor(named: "AccentColor"))
        
        self.rightImage = NewMeetingTableDateCell.newImageView(color: .secondarySystemFill)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.backgroundColor = UIColor(named: "BackgroundColor")
        
        self.contentView.addSubview(self.leftImage)
        self.contentView.addSubview(self.leftLabel)
        self.contentView.addSubview(self.rightImage)
        self.contentView.addSubview(self.rightLabel)
        
        // self.accessoryType = .disclosureIndicator
        
        self.separatorInset.left = 38
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setCellTitle(leftText: LabelConfig, rightText: LabelConfig) -> Void {
        self.leftLabel.text = leftText.text
        self.leftLabel.font = .systemFont(ofSize: leftText.sizeFont, weight: leftText.weight)
        
        let configIcon = UIImage.SymbolConfiguration(pointSize: leftText.sizeFont-10, weight: .semibold, scale: .medium)
        self.leftImage.image = UIImage(systemName: "person.2.fill", withConfiguration: configIcon)
        
        self.rightLabel.text = rightText.text
        self.rightLabel.font = .systemFont(ofSize: rightText.sizeFont, weight: rightText.weight)
        
        let configRightImage = UIImage.SymbolConfiguration(pointSize: leftText.sizeFont-10, weight: .medium, scale: .default)
        self.rightImage.image = UIImage(systemName: "chevron.forward", withConfiguration: configRightImage)
    }
    
    
    public func setParticipantsCount(num: Int) -> Void {
        self.leftLabel.text = String(num)
    }
    
    
    
    /* MARK: - Configurações */
    
    public override func awakeFromNib() -> Void {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) -> Void{
        super.setSelected(selected, animated: animated)
    }
    
    
    
    /* MARK: - Constraints */
    
    private func setConstraints() -> Void {
        let betweenSpace: CGFloat = 8
        
        let leftImageConstraints: [NSLayoutConstraint] = [
            self.leftImage.topAnchor.constraint(equalTo: self.topAnchor, constant: betweenSpace),
            self.leftImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.leftImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace),
            self.leftImage.widthAnchor.constraint(equalToConstant: self.frame.height - betweenSpace*2)
        ]
        NSLayoutConstraint.activate(leftImageConstraints)


        let leftLabelConstraints: [NSLayoutConstraint] = [
            self.leftLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.leftLabel.leftAnchor.constraint(equalTo: self.leftImage.rightAnchor, constant: betweenSpace),
            self.leftLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            self.leftLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(leftLabelConstraints)
        
        
        let rightImageConstraints: [NSLayoutConstraint] = [
            self.rightImage.topAnchor.constraint(equalTo: self.topAnchor, constant: betweenSpace+2),
            self.rightImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.rightImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace-2),
            self.rightImage.widthAnchor.constraint(equalToConstant: self.frame.height - betweenSpace*2)
        ]
        NSLayoutConstraint.activate(rightImageConstraints)


        let rightLabelConstraints: [NSLayoutConstraint] = [
            self.rightLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.rightLabel.rightAnchor.constraint(equalTo: self.rightImage.leftAnchor),
            self.rightLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            self.rightLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(rightLabelConstraints)
    }
    
    
}
