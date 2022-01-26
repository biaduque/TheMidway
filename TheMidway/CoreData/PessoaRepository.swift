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
    
   
    
    static var context: NSManagedObjectContext =  EncontroData.context
    
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
    static func getPessoa(encontro: Encontro) throws -> [Pessoa] {
        let allPessoas = try context.fetch(Pessoa.fetchRequest()) as? [Pessoa]
        let encontroPessoas = allPessoas?.filter({
                $0.encontro == encontro
        })
        
        var amigos: [Pessoa] = []
        if let safePessoas = encontroPessoas{
            amigos = safePessoas
        }
    
        return amigos
    }
    
    static func addPessoa(novo: PessoaBase, encontro: Encontro) throws -> Pessoa {
        let pessoa = Pessoa(context: context)
        
        pessoa.nome = novo.nome
        pessoa.endereco = novo.endereco
        pessoa.foto = novo.icone
        
        encontro.addToAmigos(pessoa)
        
        self.saveContext()
        return pessoa 
        
    }
    
    static func deleta(item: Pessoa) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }

}
