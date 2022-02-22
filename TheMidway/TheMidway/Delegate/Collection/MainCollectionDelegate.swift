//
//  MainCollectionDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 27/01/22.
//

import UIKit

class MainCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    /* MARK: - Atributos */
    
    private let suggestionTypes: [String] = MainCollectionDataSource.sugestionTypes
    
    private weak var mainDelegate: MainControllerDelegate?
        

    
    /* MARK: - Encapsulamento */
    
    public func setProtocol(_ delegate: MainControllerDelegate) -> Void {
        self.mainDelegate = delegate
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.mainDelegate?.openSuggestionsAction(name: self.suggestionTypes[indexPath.row])
    }
}
