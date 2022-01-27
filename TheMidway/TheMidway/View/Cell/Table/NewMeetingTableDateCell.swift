//
//  NewMeetingDateTableCell.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit

class NewMeetingTableDateCell: UITableViewCell {

    /* MARK: - Atributos */
    
    static let identifier = "IdNewMeetingTableDateCell"
    
    
    private var image: UIImageView
    
    private let label: UILabel
    
    private let date: UIDatePicker = {
        let dt = UIDatePicker()
        dt.translatesAutoresizingMaskIntoConstraints = false
        dt.preferredDatePickerStyle = .compact
        dt.datePickerMode = .dateAndTime
        dt.locale = .current
        dt.minuteInterval = 1
        return dt
    }()
    
    
    
    /* MARK: -  */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.image = NewMeetingTableDateCell.newImageView(color: UIColor(named: "AccentColor"))
        
        self.label = MainView.newLabel(color: UIColor.secondaryLabel)
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .secondarySystemBackground // UIColor(named: "BackgroundColor")
        self.separatorInset.left = 38
        
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.date)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setCellTitle(_ text: LabelConfig) -> Void {
        self.label.text = text.text
        self.label.font = .systemFont(ofSize: text.sizeFont, weight: text.weight)
        
        let configIcon = UIImage.SymbolConfiguration(pointSize: text.sizeFont-10, weight: .semibold, scale: .medium)
        self.image.image = UIImage(systemName: "calendar", withConfiguration: configIcon)
    }
    
    
    public func getTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: self.date.date)
    }
    
    
    public func getDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: self.date.date)
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
        let lateralSpace: CGFloat = 5
        let betweenSpace: CGFloat = 8
        
        let imageConstraints: [NSLayoutConstraint] = [
            self.image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: lateralSpace),
            self.image.topAnchor.constraint(equalTo: self.topAnchor, constant: betweenSpace),
            self.image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -betweenSpace),
            self.image.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.image.widthAnchor.constraint(equalToConstant: self.frame.height - betweenSpace*2)
        ]
        NSLayoutConstraint.activate(imageConstraints)


        let labelConstraints: [NSLayoutConstraint] = [
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leftAnchor.constraint(equalTo: self.image.rightAnchor, constant: betweenSpace),
            self.label.trailingAnchor.constraint(equalTo: self.centerXAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
        

        let dateConstraints: [NSLayoutConstraint] = [
            self.date.topAnchor.constraint(equalTo: self.topAnchor, constant: betweenSpace/2),
            self.date.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: -(lateralSpace*2)),
            self.date.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.date.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -lateralSpace),
            self.date.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -lateralSpace)
        ]
        NSLayoutConstraint.activate(dateConstraints)
    }
    
    
    /* MARK: - Configurações */
    
    static func newImageView(color: UIColor?) -> UIImageView {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = color ?? .blue
        
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        imgView.contentMode = .scaleAspectFit
        return imgView
    }

}
