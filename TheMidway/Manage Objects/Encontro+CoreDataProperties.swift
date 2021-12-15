//
//  Encontro+CoreDataProperties.swift
//  TheMidway
//
//  Created by Beatriz Duque on 15/12/21.
//
//

import Foundation
import CoreData


extension Encontro {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Encontro> {
        return NSFetchRequest<Encontro>(entityName: "Encontro")
    }

    @NSManaged public var data: Date?
    @NSManaged public var endereco: String?
    @NSManaged public var hora: String?
    @NSManaged public var nome: String?
    @NSManaged public var nomeLocal: String?
    @NSManaged public var amigos: NSSet?

}

// MARK: Generated accessors for amigos
extension Encontro {

    @objc(addAmigosObject:)
    @NSManaged public func addToAmigos(_ value: Pessoa)

    @objc(removeAmigosObject:)
    @NSManaged public func removeFromAmigos(_ value: Pessoa)

    @objc(addAmigos:)
    @NSManaged public func addToAmigos(_ values: NSSet)

    @objc(removeAmigos:)
    @NSManaged public func removeFromAmigos(_ values: NSSet)

}
