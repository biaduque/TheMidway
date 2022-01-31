//
//  APIError.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import struct Foundation.URLError


/**
    Classe responsável pelo tratamento dos erros que podem acontecer na API.
 
    Todos os erros são categorizados e tratados, podendo ter acesso á eles pelo que é mostrado ao usuário
 (`localizedDescription` ) ou para o desenvolvedor (`description`).
*/
enum APIError:Error, CustomStringConvertible {
    case badURL
    case badData
    case badDecode
    case badResponse(statusCode:Int)
    case url(URLError?)
    case mkLocalSearchError(Error)
    case noResult

    /// Feedback para o usuário
    var localizedDescription:String {
        switch self {
        case .badURL, .badDecode, .badData:
            return "Desculpe mas algo deu errado :/"

        case .badResponse(_):
            return "Desculpe mas estamos com problemas na hora de se counicar com o servidor."

        case .url(let error):
            return error?.localizedDescription ?? "Erro com a URL passada"
        
        case .mkLocalSearchError(_):
            return "Não foi possível concluir a busca."
        
        case .noResult:
            return "Não foi achado um resultado."
        }
    }

    /// Feedback completo para desenvolver
    var description:String {
        switch self {
        case .badURL: return "URL inválida"
        case .badData: return "Erro nos dados recebidos"
        case .badDecode: return "Erro na hora de decodificar"
        case .noResult: return "Não foi encontrado um endereço. Há um erro no endereço passado."

        case .url(let error):
            return error?.localizedDescription ?? "Eror na sessão com URL"

        case .badResponse(statusCode: let statusCode):
            return "Erro na chamada, status: \(statusCode)"
            
        case .mkLocalSearchError(let error):
            return "Erro na api MKLocalSearch: \(error.localizedDescription)"
        }
    }
}

