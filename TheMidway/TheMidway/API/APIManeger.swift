//
//  APIManeger.swift
//  TheMidway
//
//  Created by Gui Reis on 15/12/21.
//

import Foundation

class ApiManeger {
    let mainLink: String = "https://themidway-dev.herokuapp.com/encontros"


    /**
        Faz a chamda da API para os métodos GET e POST..
     
        - Parametros:
            - type: Tipo do método
            - urlPost: parâmetros para serem passados para API
 
        - CompletionHandler:
            - Result: lista com os encontros recebidos
            - Error: erro caso tenha algum
    */
    private func getMeetings(type: HTTPVerbs, _ urlPost: String = "", _ completionHandler: @escaping (Result<[EncontroMarcado], APIError>) -> Void) -> Void {

        let urlRequest = self.mainLink + urlPost

        // Erro na URL
        guard let url = URL(string: urlRequest) else {
            completionHandler(.failure(APIError.badURL))
            return
        }


        var request = URLRequest(url: url)

        switch type {
        case .GET:
            request.httpMethod = "GET"
        case .POST:
            request.httpMethod = "POST"
        }

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
    public func postMethod(urlData: [String:String], _ completionHandler: @escaping (Result<HTTPVerbs, APIError>) -> Void) -> Void {
        let parameters = self.getPostParameters(urlData)

        self.getMeetings(type: .POST, parameters) { result in
            switch result {
            case .success(_):
                completionHandler(.success(.POST))

            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    /// Método GET: recebe informações do banco de dados
    public func getMethod(_ completionHandler: @escaping (Result<[EncontroMarcado], APIError>) -> Void) -> Void {
        self.getMeetings(type: .GET) { result in
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
    private func compactInfo(itens:Itens) -> [EncontroMarcado] {
        var meetings:[EncontroMarcado] = []

        if let items = itens.itens {
            for info in items {
                meetings.append(
                    EncontroMarcado(
                        address: info.address ?? "",
                        city: info.city ?? "",
                        country: info.country ?? "",
                        date: info.date,
                        district: info.district ?? "",
                        hour: info.hour,
                        latitude: info.latitude,
                        longitude: info.longitude,
                        name: info.name,
                        number: info.number ?? "",
                        type: info.type)
                )
            }
        }
        return meetings
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
