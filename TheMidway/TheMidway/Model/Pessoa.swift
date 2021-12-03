//
//  Pessoa.swift
//  TheMidway
//
//  Created by Gui Reis on 30/11/21.
//

/// Informações sobre uma pessoa
struct PessoaBase {
    var nome: String
    var endereco: String
    var icone: String
    
    init(nome: String, endereco:String, icone:String){
        self.nome = nome
        self.endereco = endereco
        self.icone = icone
    }
}
