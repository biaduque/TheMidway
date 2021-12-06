//
//  Pessoa.swift
//  TheMidway
//
//  Created by Gui Reis on 30/11/21.
//

import Contacts

/// Informações sobre uma pessoa
struct PessoaBase {
    var nome: String
    var endereco: String
    var icone: String
    var source: CNContact
    
    init(nome: String, endereco:String, icone:String, source: CNContact){
        self.nome = nome
        self.endereco = endereco
        self.icone = icone
        self.source = source
    }
}
