//
//  MainCollectionDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 27/01/22.
//

import UIKit

class MainCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    private let suggestionTypes: [String] = MainCollectionDataSource.sugestionTypes
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print("\(self.suggestionTypes[indexPath.row]) selecionado.")
    }
}
