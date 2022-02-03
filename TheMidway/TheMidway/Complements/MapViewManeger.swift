//
//  MapViewManeger.swift
//  TheMidway
//
//  Created by Gui Reis on 24/01/22.
//

import MapKit
import CoreLocation

class MapViewManeger {
    
    /* MARK: - Atributos */
    
    /// View da controller
    private var mapView: MKMapView!
    
    /// Lidando com a localização
    public lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    
    /// Locais encontrados
    private var nerbyPlaces: [MapPlace] = []
        
    /// Tamanho da área que vai ser desenhada pra fazer a busca
    private var radiusArea: CLLocationDistance = 2500
    
    
    
    /* MARK: - */
    
    init(mapView: MKMapView, locationDelegate: CLLocationManagerDelegate, mapDelegate: MKMapViewDelegate) {
        self.mapView = mapView
        self.mapView.delegate = mapDelegate
                
        self.locationManager.delegate = locationDelegate
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    
    
    /* MARK: - Encapsulamento */
    
    public func clearVariable() -> Void {
        self.nerbyPlaces = []
    }
    
    public func setRadiusViewDefault(_ radius: CLLocationDistance) -> Void {
        self.radiusArea = radius
    }
    
    

    /* MARK: - Pins */
    
    /// Adicionar ponto no mapa
    public func addPointOnMap(pin: MKPointAnnotation) -> Void {
        self.mapView.addAnnotation(pin)
    }
    
    
    /// Remove todos os pins no mapa
    public func removeAllPins() -> Void {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    
    /// Cria um pin
    public func createPin(name: String, coordinate: CLLocationCoordinate2D, type: String) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = name
        pin.subtitle = type
    
        return pin
    }
    
    
    /// Verifica qual é o tipo do pin
    private func pinType(type: String, name: String) -> PlacesCategories {
        if name.contains("padaria") || name.contains("panificadora") {
            return .bakery
        } else if name.contains("shopping") {
            return .shopping
        } else if name.contains("cafe") || name.contains("café") {
            return .cafe
        }
        
        switch type {
        case "MKPOICategoryAmusementPark":  return .amusementPark
        case "MKPOICategoryPark":           return .nationalPark
        case "MKPOICategoryRestaurant":     return .restaurant
        case "MKPOICategoryBakery":         return .bakery
        case "MKPOICategoryTheater":        return .theater
        case "MKPOICategoryMovietheater":   return .movieTheater
        case "MKPOICategoryCafe":           return .cafe
        case "MKPOICategoryNightlife":      return .nightlife
        default: return .restaurant
        }
    }
    
    
    
    /* MARK: - Gerenciamento do Mapa */
    
    /// Define a região que o mapa vai mostrar
    public func setMapFocus(at place: CLLocationCoordinate2D, radius: CLLocationDistance) -> Void {
        // let radiusDistance = CLLocationDistance(exactly: radius)!
        let region = MKCoordinateRegion(center: place, latitudinalMeters: radius, longitudinalMeters: radius)
        
        self.mapView.setRegion(region, animated: true)
    }
        
    
    
    /* MARK: - Ponto Médio */
    
    /// Cria o pin e a área do TheMidway
    public func getTheMidwayArea(with coordinates: [CLLocationCoordinate2D], _ withCircleOn: Bool = true) -> CLLocationCoordinate2D {
        let midwayPoint = self.midpointCalculate(coordinates: coordinates)
        let pin = self.createPin(name: "The Midway", coordinate: midwayPoint, type: "The Midway")
    
        self.addPointOnMap(pin: pin)
        
        if withCircleOn {
            self.addCircle(at: midwayPoint)
        }
       
        self.setMapFocus(at: midwayPoint, radius: self.radiusArea*2)
        
        return midwayPoint
    }
    
    
    /// Calculo do ponto médio entre os pontos
    private func midpointCalculate(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
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
    private func toRadian(angle: CLLocationDegrees) -> CGFloat {
        return CGFloat(angle) / 180.0 * CGFloat(Double.pi)
    }

    /* Radians to Degrees */
    private func toDegree(radian: CGFloat) -> CLLocationDegrees {
        return CLLocationDegrees(radian * CGFloat(180.0 / Double.pi))
    }
    
    
    
    /* MARK: - Desenhar */
    
    /// Adiciona um cículo
    public func addCircle(at location: CLLocationCoordinate2D) -> Void {
        let circle = MKCircle(center: location, radius: self.radiusArea as CLLocationDistance)
        
        self.mapView.addOverlay(circle)
    }
    
    
    
    /* MARK: - Locais */
    
    /// Pega os lugares próximos a partir
    public func getNerbyPlaces(at location: CLLocationCoordinate2D, mainWord: String, pointsFilter: [MKPointOfInterestCategory], _ completionHandler: @escaping (Result<[MapPlace], APIError>) -> Void) -> Void {
        
        // Cria a pesquisa:
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = mainWord
        
        // Coloca os pontos que deseja
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: pointsFilter)
        
        // Define a regiao da pesquisa (a mesma do mapa)
        request.region = MKCoordinateRegion(center: location, latitudinalMeters: 400, longitudinalMeters: 400)
                
        // Realiza a pesquisa
        let search = MKLocalSearch(request: request)
        
        var placesFound: [MapPlace] = []
        
        let group = DispatchGroup()
        group.enter()
        
        search.start() { response, error in
            defer {group.leave()}
            
            // Erro com a comunicação com o servidor
            if let error = error {
                completionHandler(.failure(APIError.mkLocalSearchError(error)))
                return
            }
            
            guard let response = response else {
                completionHandler(.failure(APIError.badResponse(statusCode: 502)))
                return
            }
            
        
            for item in response.mapItems {
                if let name = item.name, let coords = item.placemark.location?.coordinate, let type = item.pointOfInterestCategory {
                    // Cria o pin
                    let pin = self.createPin(name: name, coordinate: coords, type: "")
                    
                    // Endereço
                    let addressInfo = AddressInfo(
                        postalCode: item.placemark.postalCode ?? "",
                        country: item.placemark.isoCountryCode ?? "",
                        city: item.placemark.administrativeArea ?? "",
                        district: item.placemark.subLocality ?? "",
                        address: item.placemark.thoroughfare ?? "",
                        number: item.placemark.subThoroughfare ?? ""
                    )
                    
                    // Guarda as informações
                    let newItem: MapPlace = MapPlace(
                        name: name,
                        coordinates: coords,
                        pin: pin,
                        type: self.pinType(type: type.rawValue, name: name.lowercased()),
                        addressInfo: addressInfo
                    )
                    
                    // Verifica se está dentro do raio E se já não foi adicionado.
                    if self.getDistance(from: location, to: coords) <= self.radiusArea && !self.findPlace(place: newItem) {
                        placesFound.append(newItem)
                        self.nerbyPlaces.append(newItem)
                        
                        self.addPointOnMap(pin: pin)
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completionHandler(.success(placesFound))
        }
    }
    
    /// Calcula a distância entre dois pontos em metros
    public func getDistance(from place1: CLLocationCoordinate2D, to place2: CLLocationCoordinate2D) -> Double {
        let place01 = CLLocation(latitude: place1.latitude, longitude: place1.longitude)
        let place02 = CLLocation(latitude: place2.latitude, longitude: place2.longitude)
        
        return place01.distance(from: place02)
    }
    
    /// Verifica se já foi achado o lugar p
    private func findPlace(place: MapPlace) -> Bool {
        for places in self.nerbyPlaces {
            if place.name == places.name {
                return true
            }
        }
        return false
    }
    
    
    /// Pega a cordenada a partir de um endereço
    static func getCoordsByAddress(address: String, _ completionHandler: @escaping (Result< CLLocationCoordinate2D, APIError>) -> Void) -> Void {

        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            
            // Lidando com o erro.
            if let _ = error {
                completionHandler(.failure(.badResponse(statusCode: 500)))
                return
            }
            
            // Caso tenha algum resultado um resultado
            if (placemarks?.count ?? 0 > 0) {
                // Pega o primeiro resultado
                let placemark: MKPlacemark = MKPlacemark(placemark: (placemarks?[0])!)
                
                let point = CLLocationCoordinate2D(
                    latitude: (placemark.location?.coordinate.latitude)!,
                    longitude: (placemark.location?.coordinate.longitude)!
                )
                completionHandler(.success(point))
            } else {
                completionHandler(.failure(.noResult))
            }
        }
    }
}

