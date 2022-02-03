//
//  UIViewWithEmptyView.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit

class UIViewWithEmptyView: UIView {
    
    /* MARK: -  Atributos */
    
    internal lazy var emptyView = EmptyView()
        
    
    
    /* MARK: -  */

    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(named: "BackgroundColor")
                
        self.addSubview(self.emptyView)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    /// Ativa/desativa a empty view da tela
    public func activateEmptyView(num: Int) -> Void {
    }
    
    
    /// Define as informações da empty view
    public func setEmptyViewInfo(img: String, label: LabelConfig, button: LabelConfig) {
        self.emptyView.setEmptyViewInfo(img: img, text: label, button: button)
    }
    
    
    /// Define apenas o texto (caso precise atualizar)
    public func setEmptyViewText(_ text: String) {
        self.emptyView.setText(text)
    }
 
    
    /// Acessa o botão da empty view
    public func getEmptyViewButton() -> UIButton {
        return self.emptyView.getButton()
    }
}
