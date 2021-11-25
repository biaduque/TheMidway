//
//  NovoEncontroViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit
import MapKit

class NovoEncontroViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var localLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Os itens comecam escondidos até o calculo ser iniciado
        mapView.isHidden = true
        collectionView.isHidden = true
        localLabel.isHidden = true
        
        
        
        // Do any additional setup after loading the view.
        
        // Define o delegate do mapa
        self.mapView.delegate = self
        
        // Define o delegate das localizações
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "quemVai"){
            let quemVaiVC = segue.destination as! QuemVaiViewController
            quemVaiVC.delegate = self
        }
    }
    
    // MARK: MApView
    ///Atributos
    /// View da controller
    
    /// Tipods de lugares que queremos pra busca
    private let placesTypes: [MKPointOfInterestCategory] = [
        // Parques
        .amusementPark,
        .nationalPark,
        
        // Restaurantes
        .restaurant,
        .bakery,
        .cafe,
        .nightlife,
        
        // Transporte
//        .gasStation,
//        .parking,
//        .publicTransport,
        
        // Teatro e cinema
        .theater,
        .movieTheater,
        
        // Outros
//        .store,
//        .foodMarket,
    ]
    
    /// Locais encontrados
    private var nerbyPlaces: [MapPlace] = []
    
    
    private lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    
    /// Pontos adicionados como referência
    private let pointsExample: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: -23.713210, longitude: -46.536620),
        CLLocationCoordinate2D(latitude: -23.548230, longitude: -46.650400),
        CLLocationCoordinate2D(latitude: -23.597040, longitude: -46.577120)
    ]
    
    /// Coordenaa do ponto médio achado
    private var midpoint: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    /// Tamanho da área que vai ser desenhada pra fazer a busca
    private let radiusArea: CLLocationDistance = 2500
    
    /// Palavras que vão ser buscadas na hora de pesquisar os lugares
    private let searchWords: [String] = ["bar", "restaurant", "pizza", "shopping", "club", "park", "night", "party"]
        
    
    
    
    /* MARK: - Delegate */
    
    /// Autorização pra usar o mapa
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if manager.authorizationStatus == .authorizedWhenInUse || status == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    /// Todos os desenhos são configurados nessa função delegate. (OBS: caso faça algum outro desenho precisa específica com o if comentado)
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // if overlay is MKCircleRenderer {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.fillColor = UIColor(named: "Color4")?.withAlphaComponent(0.3)
            circle.strokeColor = UIColor(named: "Color4")
            circle.lineWidth = 1.0
            return circle
        // }
        // return overlay
    }
    
    
    
    
    /* MARK: - Ação dos botões */
    
    /// Ativa o único botão da tela
    @objc private func buttonAction() -> Void {
        
        if self.nerbyPlaces.isEmpty {
            self.midpoint = self.theMidpoint(coordinates: self.pointsExample)
            
            for coords in self.pointsExample {
                self.addPointOnMap(pin: self.createPin(name: "", coordinate: coords))
            }
            
            self.addPointOnMap(pin: self.createPin(name: "", coordinate: self.midpoint))
            self.addCircle(location: self.midpoint)
            self.setViewLocation(place: self.midpoint, radius: self.radiusArea)
        }
        
        for someWord in self.searchWords {
            self.getNerbyPlaces(someWord)
        }
    }
    
    
    
    
    /* MARK: - Gerenciamento do Mapa */
    
    /// Adicionar ponto no mapa
    private func addPointOnMap(pin: MKPointAnnotation) -> Void {
        self.mapView.addAnnotation(pin)
    }
    
    /// Cria um pin
    private func createPin(name: String, coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = name
        // pin.subtitle = ""
        
        return pin
    }
    
    /// Define a região que o mapa vai mostrar
    private func setViewLocation(place: CLLocationCoordinate2D, radius: CLLocationDistance) -> Void {
        // let radiusDistance = CLLocationDistance(exactly: radius)!
        let region = MKCoordinateRegion(center: place, latitudinalMeters: radius, longitudinalMeters: radius)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    /// Pega a cordenada a aprtir de um endereço escrito
    private func getCoordFromAdress(adress: String) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D()
    }
    
    
    
    /* MARK: - Ponto Médio */
    
    /// Calculo do ponto médio entre os pontos
    private func theMidpoint(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
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
    private func addCircle(location: CLLocationCoordinate2D) -> Void {
        let circle = MKCircle(center: location, radius: self.radiusArea as CLLocationDistance)
        
        self.mapView.addOverlay(circle)
    }
    
    
    
    
    /* MARK: - Locais */
    
    private func getNerbyPlaces(_ mainWord: String) -> Void {
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
                        address: location,
                        pin: pin,
                        type: type
                    )
                    
                    // Adiciona na lista
                    
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
    private func getDistance(place: CLLocationCoordinate2D) -> Double {
        let midpoint = CLLocation(latitude: self.midpoint.latitude, longitude: self.midpoint.longitude)
        let newPlace = CLLocation(latitude: place.latitude, longitude: place.longitude)
        
        return midpoint.distance(from: newPlace)
    }
    
    /// Verifica se já foi achado esse lugar
    private func findPlace(place: MapPlace) -> Bool {
        for places in self.nerbyPlaces {
            if place.name == places.name {
                return true
            }
        }
        return false
    }

}
// MARK: Table View
extension NovoEncontroViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///clique na celula
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}

extension NovoEncontroViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellBase = UITableViewCell()
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: IndexPath(index: indexPath.row)) as! TextFieldCell
            cell.editTable()
            cellBase = cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quandoSeraCell", for: IndexPath(index: indexPath.row)) as! QuandoSeraTableViewCell
            cell.stylize()
            cellBase = cell
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "quemVaiCell", for: IndexPath(index: indexPath.row)) as! QuemVaiTableViewCell
            cell.stylize()
            cellBase = cell
        }
        return cellBase

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

// MARK: Collection View
extension NovoEncontroViewController: UICollectionViewDelegate{
    
}

extension NovoEncontroViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "novoEncontroCollection", for: indexPath) as! NovoEncontroCollectionViewCell
        if nerbyPlaces.count != 0 {
            cell.stylize(nearbyPlace: nerbyPlaces[indexPath.row])
        }
        return cell
    }
    
    
}

// MARK: Delegate

extension NovoEncontroViewController: QuemVaiViewControllerDelegate{
    func didReload() {
        // Add ação do botão
        self.buttonAction()
        self.mapView.reloadInputViews()
        self.collectionView.reloadInputViews()
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.localLabel.isHidden = false
        self.mapView.isHidden = false
        self.collectionView.reloadData()

        //self.mapView.getButton().addTarget(self, action: #selector(self.buttonAction), for: .touchDown)
    }
}


