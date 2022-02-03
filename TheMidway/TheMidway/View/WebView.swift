//
//  WebView.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import UIKit
import WebKit

class WebView: UIViewWithEmptyView {

    /* MARK: -  Atributos */
    
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    

    /* MARK: -  */

    override init() {
        super.init()
        
        self.emptyView.setStyle(style: .justVisualisation)
        
        self.addSubview(self.webView)
                
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    /// Define a URL que vai aparecer
    public func setUrl(at urlQuery: String) -> Bool {
        if let url = URL(string: urlQuery) {
            let request = URLRequest(url: url)
            
            self.webView.load(request)
            return true
        }
        return false
    }
    
    
    override public func activateEmptyView(num: Int) -> Void {
        var bool = true
        if num == 0 { bool = false }
        self.emptyView.isHidden = bool
        self.webView.isHidden = !bool
    }
    
    
    
    /* MARK: -  Constraints */
    
    private func setConstraints() -> Void {
        let safeArea: CGFloat = 50
        
        let webViewConstraints: [NSLayoutConstraint] = [
            self.webView.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(webViewConstraints)
        
        
        // Empty View
        let emptyViewConstraints: [NSLayoutConstraint] = [
            self.emptyView.topAnchor.constraint(equalTo: self.topAnchor, constant: safeArea),
            self.emptyView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.emptyView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.emptyView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(emptyViewConstraints)
    }
}
