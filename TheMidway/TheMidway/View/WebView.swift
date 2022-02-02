//
//  WebView.swift
//  TheMidway
//
//  Created by Gui Reis on 02/02/22.
//

import UIKit
import WebKit

class WebView: UIView {

    /* MARK: -  Atributos */
    
    private let webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    

    /* MARK: -  */

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(named: "BackgroundColor")
        
        self.addSubview(self.webView)
                
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    
    /* MARK: -  Encapsulamento */
    
    /// Define a URL que vai aparecer
    public func setUrl(at urlQuery: String) -> Void {
        if let url = URL(string: urlQuery) {
            let request = URLRequest(url: url)
            
            self.webView.load(request)
        } else {
            print("Não criei a URL: \(urlQuery)")
        }
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
    }
}
