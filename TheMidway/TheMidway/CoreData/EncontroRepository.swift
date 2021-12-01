//
//  EncontroRepository.swift
//  TheMidway
//
//  Created by Anna Carolina Costa Andrade on 01/12/21.
//

import Foundation
import CoreData

class EncontroData {
    static let shared:EncontroData = EncontroData()
    
   
    
    var contenxt: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    ///var privada ja que nao vai ser acessada
    private lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "TheMidway")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Buscar todas as reuniões no banco de dados
    func getEncontro() -> [Encontro] {
        let fr = NSFetchRequest<Encontro>(entityName: "Encontro")
        do {
            return try self.persistentContainer.viewContext.fetch(fr)
        }catch {
            print(error)
        }
        
        return []
    }
    
    func addEncontro(novo: Encontro) {
        let encontro = Encontro(context: self.persistentContainer.viewContext)
        
        encontro.nome = novo.nome
        encontro.endereco = novo.endereco
        encontro.data = novo.data
       
        
 
            self.saveContext()
        
    }
    
    func deleta(item: Encontro) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }

}
