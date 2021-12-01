//
//  PessoaData.swift
//  TheMidway
//
//  Created by Anna Carolina Costa Andrade on 01/12/21.
//

import Foundation
import CoreData

class PessoaData {
    static let shared:PessoaData = PessoaData()
    
   
    
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
    func getPessoa() -> [Pessoa] {
        let fr = NSFetchRequest<Pessoa>(entityName: "Pessoa")
        do {
            return try self.persistentContainer.viewContext.fetch(fr)
        }catch {
            print(error)
        }
        
        return []
    }
    
    func addPessoa(novo: Pessoa) {
        let pessoa = Pessoa(context: self.persistentContainer.viewContext)
        
        pessoa.nome = novo.nome
        pessoa.endereco = novo.endereco
        pessoa.foto = novo.foto
       
        
 
            self.saveContext()
        
    }
    
    func deleta(item: Pessoa) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }

}
