//
//  NovoEncontroViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit
import MapKit


protocol NovoEncontroViewControllerDelegate: AnyObject {
    func didReload()
}


class NovoEncontroViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var localLabel: UILabel!
    
    // MARK: Private vars
    private var enderecos: [String] = []
    private var encontroTitle: String = "Novo Encontro"
    private var encontroEndereco: String = "Rua batata"
    private var date = Date()
    
    
    
    @IBOutlet weak var refreshButton: UIButton!
    
    weak var delegate: NovoEncontroViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
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
        refreshButton.isHidden = true
        
        
        /* MapKit */
        
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
    
    
    
    // MARK: - MapView

    /// Tipos de lugares que queremos pra busca
    public let placesTypes: [MKPointOfInterestCategory] = [
        // Parques
        .amusementPark,
        .nationalPark,
        
        // Restaurantes
        .restaurant,
        .bakery,
        .cafe,
        .nightlife,
        
        // Teatro e cinema
        .theater,
        .movieTheater,
    ]
    
    /// Locais encontrados
    public var nerbyPlaces: [MapPlace] = []
    
    /// Lidando com a localização
    public lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    /// Pontos adicionados como referência
    public let pointsExample: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: -23.495480, longitude: -46.868080),    // Muza
        CLLocationCoordinate2D(latitude: -23.545580, longitude: -46.651860),    // Feh
        CLLocationCoordinate2D(latitude: -23.523580, longitude: -46.774770),    // Bia
        CLLocationCoordinate2D(latitude: -23.627600, longitude: -46.637000),    // Leh
        CLLocationCoordinate2D(latitude: -23.741880, longitude: -46.661870),    // Oliver
        CLLocationCoordinate2D(latitude: -23.713213, longitude: -46.536622),    // Gui
    ]
    
    /// Coordenaa do ponto médio achado
    public var midpoint: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    /// Tamanho da área que vai ser desenhada pra fazer a busca
    public let radiusArea: CLLocationDistance = 2500
    
    /// Palavras que vão ser buscadas na hora de pesquisar os lugares
    public let searchWords: [String] = ["bar", "restaurant", "pizza", "shopping", "club", "park", "night", "party"]
        
    /// Pontos encotrados por um endereço como string
    public var coordFound: [CLLocationCoordinate2D] = []
    
    
    
    
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
        // if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
            circle.strokeColor = .red
            circle.lineWidth = 1.0
            return circle
        // }
        // return overlay
    }
    
    
    /// Personaliza um pin
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title!! == " " {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = UIColor.blue
            // annotationView.glyphImage = UIImage()    // Colocando uma imagem
            return annotationView
        }
        return MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
    }
    

    
    /* MARK: - Ação dos botões */
    
    /// Ativa o único botão da tela
    func buttonAction(enderecos: [String]) -> Void {
        
        if self.nerbyPlaces.isEmpty {
            // Pega o ponto central
            self.midpoint = self.theMidpoint(coordinates: self.pointsExample)

            // Adiciona os pontos exemplos
            for coords in self.pointsExample {
                self.addPointOnMap(pin: self.createPin(name: " ", coordinate: coords))
            }

            // Adiciona o ponto central
            self.addPointOnMap(pin: self.createPin(name: " ", coordinate: self.midpoint))

            // Cria um cículo
            self.addCircle(location: self.midpoint)

            // Define a região que vai ser focada no mapa: o ponto dentral
            self.setViewLocation(place: self.midpoint, radius: self.radiusArea)
        }

        // Faz a busca por locasi a partr das palavras chaves.
        for someWord in self.searchWords {
            self.getNerbyPlaces(someWord)
        }
        //fazer as conversoes de enderecos ai
        // self.getCoordsByAddress(address: "Rua Nicola Spinelli, 469")
    }
    
    // MARK: Done button
    
    @IBAction func doneButton(_ sender: Any) {
        
        ///titulo
        let index = IndexPath(row: 0, section: 0)
        let cell: TextFieldCell = self.tableView.cellForRow(at: index) as! TextFieldCell
        self.encontroTitle = cell.textField.text!
        
        
        ///data
        self.date = Date()
        
        ///local
    
        
        ///adicionando no core data
        EncontroData.shared.addEncontro(novoNome: self.encontroTitle, novoEndereco: self.encontroEndereco, novoData: self.date)
        EncontroData.shared.saveContext()
        delegate?.didReload()
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelButton(_ sender: Any) {
        
    }
    
    @IBAction func reload(_ sender: Any) {
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
        self.mapView.isHidden = false
    }
}


// MARK: - Table View
extension NovoEncontroViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///clique na celula
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}



extension NovoEncontroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellBase = UITableViewCell()
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: IndexPath(index: indexPath.row)) as! TextFieldCell
            cell.editTable()
            encontroTitle = cell.textField.text ?? "Novo Encontro"
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



// MARK: - Collection View
extension NovoEncontroViewController: UICollectionViewDelegate {
    
}

extension NovoEncontroViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "novoEncontroCollection", for: indexPath) as! NovoEncontroCollectionViewCell
        if self.nerbyPlaces.count != 0 {
            cell.stylize(nearbyPlace: self.nerbyPlaces[indexPath.row])
        }
        return cell
    }
    
    
}


// MARK: Delegate

extension NovoEncontroViewController: QuemVaiViewControllerDelegate{
    
    //funcao para pegar as strings
    func getAdress(endFriends: [String]){
        self.enderecos = endFriends
    }
    
    func didReload() {
        // Add ação do botão
        self.mapView?.reloadInputViews()
        self.collectionView?.reloadInputViews()
        self.collectionView?.reloadData()
        //self.mapView.getButton().addTarget(self, action: #selector(self.buttonAction), for: .touchDown)
    }
    
    func getLocations() {
        self.buttonAction(enderecos: self.enderecos)
        self.refreshButton?.isHidden = false
        self.localLabel.isHidden = false
    
    }
}





