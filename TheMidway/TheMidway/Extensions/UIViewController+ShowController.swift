//
//  UIViewController+ShowController.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit


extension UIViewController {

    /// Mostra uma nova tela com a Navbar
    internal func showViewController(with controller: UIViewController, _ isModal: Bool = true) -> Void {
        if isModal { controller.modalPresentationStyle = .popover }
        
        let navBar = UINavigationController(rootViewController: controller)
        self.present(navBar, animated: true)
    }
}
