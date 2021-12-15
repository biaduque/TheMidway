//
//  UserDefaultManager.swift
//  TheMidway
//
//  Created by Anninha e on 13/12/21.
//
import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    var nomeLocal: String? {
        didSet {
            //UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.set(nomeLocal, forKey: "nomeLocal")
        }
    }
    var endEncontro: String? {
        didSet {
            //UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.set(endEncontro, forKey: "endEncontro")
        }
    }
    var horaEncontro: String? {
        didSet {
            //UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.set(horaEncontro, forKey: "horaEncontro")
        }
    }
    var dataEncontro: String? {
        didSet {
            //UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.set(dataEncontro, forKey: "dataEncontro")
        }
    }
    var tituloEncontro: String? {
        didSet {
            //UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.set(tituloEncontro, forKey: "tituloEncontro")
        }
    }
    private init() {
        self.nomeLocal = UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.object(forKey: "nomeLocal") as? String
        self.endEncontro = UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.object(forKey: "endEncontro") as? String
        self.horaEncontro = UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.object(forKey: "horaEncontro") as? String
        self.dataEncontro = UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.object(forKey: "dataEncontro") as? String
        self.tituloEncontro = UserDefaults(suiteName: "group.com.midwayappclip.herokuapp.TheMidway")?.object(forKey: "tituloEncontro") as? String
    }
}
