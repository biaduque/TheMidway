//
//  PeopleCDManeger.swift
//  TheMidway
//
//  Created by Gui Reis on 28/01/22.
//

import CoreData
import Foundation

class ParticipantsCDManeger {
    
    /* MARK: - Atributos */

    static let shared: ParticipantsCDManeger = ParticipantsCDManeger()
    
    private var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
        
    private lazy var container: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "TheMidway")
        container.loadPersistentStores() {_, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()


    
    /* MARK: - Acessando o Core Data (Encapsulamento) */
    
    /// Salvando e atualizando alterações que tiveram no core data
    private func saveContext() -> Void {

        if self.mainContext.hasChanges {
            do {
                try self.mainContext.save()
            } catch(let errorGenerated) {
                print("Erro na hora de salvar \(errorGenerated)")
                fatalError("Unresolved error \(errorGenerated)")
            }
        }
    }
    
    
    /// Pega todos os participantes a partir de um id
    public func getParticipants(at meetingId: Int) -> [Participants] {
        let fr = NSFetchRequest<Participants>(entityName: "Participants")
        
        do {
            let allParticipants = try self.mainContext.fetch(fr)
            
            // Filtra a tabela (select com where em SQL)
            var listFiltred: [Participants] = []
            
            for person in allParticipants {
                if person.meetingId == meetingId {
                    listFiltred.append(person)
                }
            }
            return listFiltred
        } catch {
            print(error)
        }
        
        return []
    }
    
    
    /// Adiciona um novo encontro no core data
    public func newParticipant(data: Person) throws -> Participants {
        let person = Participants(context: self.mainContext)
        
        let address = NewMeetingViewController.creatAddressVisualization(place: data.contactInfo.address)
        
        person.name = data.contactInfo.name
        person.image = Int16(data.image)
        
        person.address = address
        person.latitude = Float(data.coordinate.latitude)
        person.longitude = Float(data.coordinate.longitude)
        
        person.meetingId = Int16(data.meetingId)
        
        
        self.saveContext()
        return person
    }
    
    
    /// Remove um participante no Core Data
    public func deleteParticipant(at item: Participants) throws {
        self.mainContext.delete(item)
        self.saveContext()
    }
    
    
    /// Remove uma lista de usuários
    public func deleteParticipants(at item: [Participants]) throws {
        for person in item {
            self.mainContext.delete(person)
        }
        self.saveContext()
    }
}



