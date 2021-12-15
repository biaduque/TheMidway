//
//  NovoEncontroViewController+Mapkit.swift
//  TheMidway
//
//  Created by Gui Reis on 30/11/21.
//

import MapKit
import CoreLocation


// MARK: - MapKit

extension NovoEncontroViewController {
    
    /* MARK: - Pins */
    
    /// Adicionar ponto no mapa
    public func addPointOnMap(pin: MKPointAnnotation) -> Void {
        self.mapView.addAnnotation(pin)
    }
    
    /// Cria um pin
    public func createPin(name: String, coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = name
        // pin.subtitle = ""
        
        return pin
    }
    
    
    
    
    /* MARK: - Gerenciamento do Mapa */
    
    /// Define a região que o mapa vai mostrar
    public func setViewLocation(place: CLLocationCoordinate2D, radius: CLLocationDistance) -> Void {
        // let radiusDistance = CLLocationDistance(exactly: radius)!
        let region = MKCoordinateRegion(center: place, latitudinalMeters: radius, longitudinalMeters: radius)
        
        self.mapView.setRegion(region, animated: true)
    }
        
    
    
    
    /* MARK: - Ponto Médio */
    
    /// Calculo do ponto médio entre os pontos
    public func theMidpoint(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        let coordsCount = Double(coordinates.count)
        
        guard coordsCount > 1 else {
            return coordinates.first ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }

        var x: Double = 0.0
        var y: Double = 0.0
        var z: CGFloat = 0.0

        for coordinate in coordinates {
            let lat: CGFloat = self.toRadian(angle: coordinate.latitude)
            let lon: CGFloat = self.toRadian(angle: coordinate.longitude)
            
            x += cos(lat) * cos(lon)
            y += cos(lat) * sin(lon)
            z += sin(lat)
        }
                
        x /= coordsCount
        y /= coordsCount
        z /= coordsCount

        let lon = atan2(y, x)
        let hyp = sqrt(x*x + y*y)
        let lat = atan2(z, hyp)

        return CLLocationCoordinate2D(latitude: self.toDegree(radian: lat), longitude: self.toDegree(radian: lon))
    }
    
    /* Degrees to Radian */
    public func toRadian(angle: CLLocationDegrees) -> CGFloat {
        return CGFloat(angle) / 180.0 * CGFloat(Double.pi)
    }

    /* Radians to Degrees */
    public func toDegree(radian: CGFloat) -> CLLocationDegrees {
        return CLLocationDegrees(radian * CGFloat(180.0 / Double.pi))
    }
    
    
    
    
    /* MARK: - Desenhar */
    
    /// Adiciona um cículo
    public func addCircle(location: CLLocationCoordinate2D) -> Void {
        let circle = MKCircle(center: location, radius: self.radiusArea as CLLocationDistance)
        
        self.mapView.addOverlay(circle)
    }
    
    
    
    
    /* MARK: - Locais */
    
    /// Pega os lugares próximos a partir
    public func getNerbyPlaces(_ mainWord: String) -> Void {
        // Cria a pesquisa:
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = mainWord
        
        // Coloca os pontos que deseja
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: self.placesTypes)
        
        // Define a regiao da pesquisa (a mesma do mapa)
        request.region = MKCoordinateRegion(center: self.midpoint, latitudinalMeters: 400, longitudinalMeters: 400)
                
        // Realiza a pesquisa
        let search = MKLocalSearch(request: request)
        
        search.start() { response, error in
            
            if let erro = error {
                print("Erro achado: \(erro)")
                return
            }
            
            guard let response = response else {
                // Lidar com o erro aqui!
                print("Estou no erro.")
                return
            }
            
            print("Itens encontrados para \(mainWord): \(response.mapItems.count). \n\n")
                        
            for item in response.mapItems {
                if let name = item.name, let location = item.placemark.location, let type = item.pointOfInterestCategory {
                    // Cria a cordenada
                    let coords = CLLocationCoordinate2D(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                    
                    // Cria o pin
                    let pin = self.createPin(name: name, coordinate: coords)
                    
                    // Guarda as informações
                    let newItem: MapPlace = MapPlace(
                        name: name,
                        coordinates: coords,
                        pin: pin,
                        type: type.rawValue,
                        country: item.placemark.isoCountryCode ?? "",
                        city: item.placemark.administrativeArea ?? "",
                        district: item.placemark.subLocality ?? "",
                        address: item.placemark.thoroughfare ?? "",
                        number: item.placemark.subThoroughfare ?? "",
                        site: String(describing: item.url),
                        contact: item.phoneNumber ?? ""
                    )
                    
                    // Verifica se está dentor do raio E se já não foi adicionado.
                    if self.getDistance(place: coords) <= self.radiusArea+500 && !self.findPlace(place: newItem){
                        self.nerbyPlaces.append(newItem)
                        
                        print("Lugar: \(newItem.name)")
                        print("Site: \(String(describing: item.url))")
                        print("Tipo: \(String(describing: item.pointOfInterestCategory!))\n")
                        
                        // Add no mapa
                        self.addPointOnMap(pin: pin)
                    }
                }
            }
            
            print("\n\n Locais no mapa: \(self.nerbyPlaces.count) \n\n")
        }
    }
    
    /// Calcula a distancia entre dois pontos em metros
    public func getDistance(place: CLLocationCoordinate2D) -> Double {
        let midpoint = CLLocation(latitude: self.midpoint.latitude, longitude: self.midpoint.longitude)
        let newPlace = CLLocation(latitude: place.latitude, longitude: place.longitude)
        
        return midpoint.distance(from: newPlace)
    }
    
    /// Verifica se já foi achado esse lugar
    public func findPlace(place: MapPlace) -> Bool {
        for places in self.nerbyPlaces {
            if place.name == places.name {
                return true
            }
        }
        return false
    }
    
    
    /// Pega a cordenada a partir de um endereço
    public func getCoordsByAddress(address: String, _ completionHandler: @escaping (Result< CLLocationCoordinate2D, Error>) -> Void) -> Void {
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            
            // Lidando com o erro.
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            // Caso tenha algum resultado um resultado
            if (placemarks?.count ?? 0 > 0) {
                // Pega o primeiro resultado
                let topResult: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                
                let point = CLLocationCoordinate2D(
                    latitude: (placemark.location?.coordinate.latitude)!,
                    longitude: (placemark.location?.coordinate.longitude)!)
                
                completionHandler(.success(point))
                
            } else {
                print("Não foi achado nenhum endereço.")
            }
        }
    }
}
