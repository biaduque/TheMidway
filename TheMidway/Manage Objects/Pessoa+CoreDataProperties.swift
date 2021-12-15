//
//  Pessoa+CoreDataProperties.swift
//  TheMidway
//
//  Created by Beatriz Duque on 15/12/21.
//
//

import Foundation
import CoreData


extension Pessoa {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pessoa> {
        return NSFetchRequest<Pessoa>(entityName: "Pessoa")
    }

    @NSManaged public var endereco: String?
    @NSManaged public var foto: String?
    @NSManaged public var nome: String?
    @NSManaged public var encontro: Encontro?

}
