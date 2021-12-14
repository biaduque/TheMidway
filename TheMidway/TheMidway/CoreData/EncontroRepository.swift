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
    
    func addEncontro(novoNome: String, nomeLocal: String, novoEndereco: String, novoData: Date, hora: String, pessoas: [PessoaBase]) {
        let encontro = Encontro(context: self.persistentContainer.viewContext)
        encontro.nomeLocal = nomeLocal
        encontro.nome = novoNome
        encontro.endereco = novoEndereco
        encontro.hora = hora
        encontro.data = novoData
        
        //for pessoa in pessoas{
            //PessoaData.shared.addPessoa(novo: pessoa)
        //}
        //let newPessoas = PessoaData.shared.getPessoa()
        //encontro.amigos = NSSet(array: newPessoas)
        self.saveContext()
        
    }
    
    func deleta(item: Encontro) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }
}
