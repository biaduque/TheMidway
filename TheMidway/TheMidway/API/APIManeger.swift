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
    
    
    private var postParameters: [String:String] = [:]
    
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
            print("POST: Url criada \(urlRequest)")
            completionHandler(.failure(APIError.badURL))
            return
        }
        
        print("Deu: Url criada \(url)")

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
            
            print("Deu: Arquivos encontrados \(meeting)")

            completionHandler(.success(self.compactInfo(itens: meeting)))
        }
        task.resume()
    }


    /// Método POST: manda informações pro banco de dados
    public func postMeetingCreated(data: MeetingCreated, _ completionHandler: @escaping (Result<HTTPVerbs, APIError>) -> Void) -> Void {
        let parameters = self.getPostParameters(self.createDict(with: data))

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
        let mainWord = "?keyWord=\(word.capitalized)"
        
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
    private func compactInfo(itens: Itens) -> [MapPlace] {
        var suggestionsPlaces: [MapPlace] = []
        
        if let items = itens.items {
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
                    number: info.addressNumber ?? ""
                )
                
                let mapPlace = MapPlace(
                    name: info.placeName,
                    coordinates: coords,
                    pin: nil,
                    type: MapViewManeger.categoryType(with: info.category),
                    addressInfo: addressInfo
                )
                
                suggestionsPlaces.append(mapPlace)
            }
        }
        return suggestionsPlaces
    }


    
    /* MARK: - Métodos auxiliares */

    private func getPostParameters (_ urlData: [String:String]) -> String {
        // URL gerada: ?meetingName=&date=time=&placeName=&category=&longitude=&latitude=&postalCode=&country=&city=&address=&addressNumber=
        
        let colunas: [String] = ["meetingName", "date", "time", "placeName", "category", "longitude", "latitude", "postalCode", "country", "city", "district", "address", "addressNumber"]

        var url: String = "?"
        for col in colunas {
            url += "\(col)=\(urlData[col] ?? "")"

            if col != "addressNumber" {
                url += "&"
            }
        }

        return url.replacingOccurrences(of: " ", with: "%20")
    }
    
    
    private func createDict(with data: MeetingCreated) -> [String:String] {
        let dict: [String:String] = [
            "meetingName" : data.meetingInfo.meetingName,
            "date" : data.meetingInfo.date,
            "time" : data.meetingInfo.hour,
            "placeName" : data.placeInfo.name,
            "category" : data.placeInfo.type.localizedDescription,
            "longitude" : String(data.placeInfo.coordinates.longitude),
            "latitude" : String(data.placeInfo.coordinates.latitude),
            "postalCode" : data.placeInfo.addressInfo.postalCode.replacingOccurrences(of: "-", with: ""),
            "country" : data.placeInfo.addressInfo.country,
            "city" : data.placeInfo.addressInfo.city,
            "district" : data.placeInfo.addressInfo.district,
            "address" : data.placeInfo.addressInfo.address,
            "addressNumber" : data.placeInfo.addressInfo.number
        ]
        
        self.postParameters = dict
        return dict
    }
}
