//
//  APIManeger.swift
//  TheMidway
//
//  Created by Gui Reis on 03/02/22.
//

import Foundation
import CoreLocation


class ApiManeger {
    
    /* MARK: - Atributos */
    
    private let suggetionsLink: String = "https://themidway-dev.herokuapp.com/suggestions"
    
    private let meetingsLink: String = "https://themidway-dev.herokuapp.com/meetingsCreated"

    /**
        Faz a chamda da API para os métodos GET e POST..
     
        - Parametros:
            - type: Tipo do método
            - urlPost: parâmetros para serem passados para API
 
        - CompletionHandler:
            - Result: lista com os encontros recebidos
            - Error: erro caso tenha algum
    */
    private func communicateWithAPI(type: HTTPVerbs, _ urlParameters: String = "", _ completionHandler: @escaping (Result<[MapPlace], APIError>) -> Void) -> Void {
        
        var urlRequest: String = ""
        var verbHttp: String = ""
        
        switch type {
        case .GET:
            urlRequest = self.suggetionsLink + urlParameters
            verbHttp = "GET"
        case .POST:
            urlRequest = self.meetingsLink + urlParameters
            verbHttp = "POST"
        }
        

        // Erro na URL
        guard let url = URL(string: urlRequest) else {
            completionHandler(.failure(APIError.badURL))
            return
        }


        var request = URLRequest(url: url)
        request.httpMethod = verbHttp

        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Erro da sessão
            if let error = error {
                completionHandler(.failure(APIError.url(error as? URLError)))
                return
            }

            // Não fez conexão com a API: servidor ou internet off
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completionHandler(.failure(APIError.badResponse(statusCode: response.statusCode)))
                return
            }

            // Erro na hora de pagar os dados
            guard let data = data else {
                completionHandler(.failure(APIError.badData))
                return
            }


            // Método post vai até aqui!
            if type == .POST {
                completionHandler(.success([]))
                return
            }


            // Erro na hora de decodificar
            guard let meeting = try? JSONDecoder().decode(Itens.self, from: data) else {
                completionHandler(.failure(APIError.badDecode))
                return
            }


            completionHandler(.success(self.compactInfo(itens: meeting)))
        }
        task.resume()
    }


    /// Método POST: manda informações pro banco de dados
    public func postMeetingCreated(urlData: [String:String], _ completionHandler: @escaping (Result<HTTPVerbs, APIError>) -> Void) -> Void {
        let parameters = self.getPostParameters(urlData)

        self.communicateWithAPI(type: .POST, parameters) { result in
            switch result {
            case .success(_):
                completionHandler(.success(.POST))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    
    /// Método GET: recebe informações do banco de dados
    public func getSuggetions(with word: String, _ completionHandler: @escaping (Result<[MapPlace], APIError>) -> Void) -> Void {
        let mainWord = "mainWord=\(word)"
        
        self.communicateWithAPI(type: .GET, mainWord) { result in
            switch result {
            case .success(let meetings):
                completionHandler(.success(meetings))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }



    /**
        Pega os dados recebidos e coloca na struct padrão: EncontroMarcado
     
        - Parâmetros:
            - items: Struct com as informações recebidas da API
    */
    private func compactInfo(itens:Itens) -> [MapPlace] {
        var suggestionsPlaces: [MapPlace] = []
        
        if let items = itens.itens {
            for info in items {
                let coords = CLLocationCoordinate2D(
                    latitude: Double(info.latitude),
                    longitude: Double(info.longitude)
                )
                
                let addressInfo = AddressInfo(
                    postalCode: info.postalCode ?? "",
                    country: info.country ?? "",
                    city: info.city ?? "",
                    district: info.district ?? "",
                    address: info.address ?? "",
                    number: info.number ?? ""
                )
                
                let mapPlace = MapPlace(
                    name: info.name,
                    coordinates: coords,
                    pin: nil,
                    type: MapViewManeger.categoryType(with: info.type),
                    addressInfo: addressInfo
                )
                
                suggestionsPlaces.append(mapPlace)
            }
        }
        return suggestionsPlaces
    }


    
    /* MARK: - Métodos auxiliares */

    private func getPostParameters (_ urlData: [String:String]) -> String {
        // URL gerada: ?data=&hora=&nome=&tipo=&latitude=&longitude=&pais=&cidade=&bairro=&endereco=&numero=
        
        let colunas: [String] = ["data", "hora", "nome", "tipo", "longitude", "latitude", "pais", "cidade", "bairro", "endereco", "numero"]

        var url: String = "?"
        for col in colunas {
            url += "\(col)=\(urlData[col] ?? "")"

            if col != "numero" {
                url += "&"
            }
        }

        return url.replacingOccurrences(of: " ", with: "%20")
    }
}
