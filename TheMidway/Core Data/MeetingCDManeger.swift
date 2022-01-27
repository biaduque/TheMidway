//
//  MeetingCDManeger.swift
//  TheMidway
//
//  Created by Gui Reis on 20/01/22.
//

import CoreData
import Foundation

class MeetingCDManeger {

    static let shared: MeetingCDManeger = MeetingCDManeger()
    
    private var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    
    // MARK: - Core Data stack
    
    private lazy var container: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "TheMidway")
        container.loadPersistentStores() {_, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()


    
    // MARK: - Core Data Saving support
    
    public func saveContext() -> Void {

        if self.mainContext.hasChanges {
            do {
                try self.mainContext.save()
            } catch(let errorGenerated) {
                print("Erro na hora de salvar \(errorGenerated)")
                fatalError("Unresolved error \(errorGenerated)")
            }
        }
    }
    
    
    
    /// Pega todos os encontros criados
    public func getMeetingsCreated() -> [Meetings] {
        let fr = NSFetchRequest<Meetings>(entityName: "Meetings")
        do {
            return try self.mainContext.fetch(fr)
        }catch {
            print(error)
        }
        return []
    }
    
    
    /// Adiciona um novo encontro no core data
    public func newMeeting(data: MeetingCreated) throws -> Meetings {
        let meeting = Meetings(context: self.mainContext)
        
        meeting.address = data.placeInfo.address
        meeting.city = data.placeInfo.city
        meeting.country = data.placeInfo.country
        meeting.date = data.date
        meeting.district = data.placeInfo.district
        meeting.hour = data.hour
        meeting.latitude = Float(data.placeInfo.coordinates.latitude)
        meeting.longitude = Float(data.placeInfo.coordinates.longitude)
        meeting.placeName = data.placeInfo.name
        meeting.meetingName = data.meetingName
        meeting.addressNumber = data.placeInfo.number
        meeting.categorie = data.placeInfo.type.localizedDescription
        
        self.saveContext()
        return meeting
    }
}


