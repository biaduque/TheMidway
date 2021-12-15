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
    
   
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    ///var privada ja que nao vai ser acessada
    static var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "TheMidway")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
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
    static func getEncontro() -> [Encontro] {
        let fr = NSFetchRequest<Encontro>(entityName: "Encontro")
        do {
            return try self.persistentContainer.viewContext.fetch(fr)
        }catch {
            print(error)
        }
        
        return []
    }
    
    static func addEncontro(novoNome: String, nomeLocal: String, novoEndereco: String, novoData: Date, hora: String) throws -> Encontro {
        let encontro = Encontro(context: self.persistentContainer.viewContext)
        encontro.nomeLocal = nomeLocal
        encontro.nome = novoNome
        encontro.endereco = novoEndereco
        encontro.hora = hora
        encontro.data = novoData
        
        ///formatando a data para string
        let formatter =  DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let textData = formatter.string(from: encontro.data ?? Date())
               

        UserDefaults().set(encontro.nomeLocal, forKey: "nomeLocal")
        UserDefaults().set(encontro.endereco, forKey: "endEncontro")
        UserDefaults().set(textData, forKey: "dataEncontro")
        UserDefaults().set(encontro.hora, forKey: "horaEncontro")
        UserDefaults().set(encontro.nome, forKey: "tituloEncontro")
        
        self.saveContext()
        return encontro
    }
    
    static func deleta(item: Encontro) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }
}
