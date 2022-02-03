//
//  SuggestionsCollectionDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import UIKit
import SwiftUI

class SuggestionsCollectionDelegate: NSObject, UICollectionViewDelegate {
    
    /* MARK: - Atributos */
    
    private weak var suggestionsDelegate: SuggestionsControllerDelegate!
        

    
    /* MARK: - Encapsulamento */
    
    public func setProtocol(_ delegate: SuggestionsControllerDelegate) -> Void {
        self.suggestionsDelegate = delegate
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Ação de quando clica em uma célula
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
        let places = self.suggestionsDelegate!.getSuggestionsPlaces()
        
        self.suggestionsDelegate!.createNewMeeting(with: places[indexPath.row])
    }
}
