//
//  NewMeetingTitleTableCell.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import UIKit

class NewMeetingTableTitleCell: UITableViewCell {

    /* MARK: - Atributos */
    
    static let identifier = "IdNewMeetingTableTitleCell"
    
    private var textField: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.adjustsFontSizeToFitWidth = true
        txt.autocapitalizationType = .words
        
        txt.font = .systemFont(ofSize: txt.font!.pointSize, weight: .semibold)
        txt.textColor = UIColor(named: "TitleLabel")!
        return txt
    }()
    
    
    
    /* MARK: -  */
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .secondarySystemBackground// UIColor(named: "BackgroundColor")
//        self.layoutMargins = .zero
//        self.separatorInset = .zero
        self.separatorInset.left = 38
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
        self.contentView.layer.masksToBounds = true
        
        
        self.contentView.addSubview(self.textField)
        
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setTextBackground(_ text: String) -> Void {
        self.textField.placeholder = text
    }
    
    public func setTextFieldDelegate(delegate: UITextFieldDelegate) -> Void {
        self.textField.delegate = delegate
    }
    
    public func getText() -> String {
        return self.textField.text ?? ""
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
        // let lateralSpace: CGFloat = 5
        
        let textFieldConstraints: [NSLayoutConstraint] = [
            self.textField.topAnchor.constraint(equalTo: self.topAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(textFieldConstraints)
    }
}
