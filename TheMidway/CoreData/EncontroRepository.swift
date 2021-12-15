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
        container.loadPersistentStores() {storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
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
        let dateToString = formatter.string(from: encontro.data ?? Date())
               
        // Informações para o Widget
        UserDefaults().set(encontro.nomeLocal, forKey: "nomeLocal")
        UserDefaults().set(encontro.endereco, forKey: "endEncontro")
        UserDefaults().set(dateToString, forKey: "dataEncontro")
        UserDefaults().set(encontro.hora, forKey: "horaEncontro")
        UserDefaults().set(encontro.nome, forKey: "tituloEncontro")
        
        
        // Informações para a API + Banco de Dados
        let dict: [String:String] = [
            "data" : dateToString,
            "hora" : hora,
            "nome" : nomeLocal,
            "tipo" : "",
            "longitude" : "0",
            "latitude" : "0",
            "pais" : "",
            "cidade" : "",
            "bairro" : "",
            "endereco" : novoEndereco,
            "numero" : ""
        ]
        
        // Chama a instancia da api
        let api = ApiManeger()

        // Faz um POST
        api.postMethod(urlData: dict) { result in
            switch result {
            case .success(let status):
                // Entra aqui quando da certo!
                print("\n\nFoi dado um POST: \(status)\n\n")

            case .failure(let error):
                print("\n\nErro: \(error.description)\n\n")
            }
        }
        
        
        self.saveContext()
        return encontro
    }
    
    
    static func deleta(item: Encontro) throws{
        self.persistentContainer.viewContext.delete(item)
        self.saveContext()
    }
}
