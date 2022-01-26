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
    
    // MARK: vars
    private var enderecos: [String] = []
    public var pessoas: [PessoaBase] = []
    private var encontroTitle: String = "Novo Encontro"
    private var localTitle: String = "Nome Locallllll"
    private var encontroEndereco: String = "Rua batata"
    private var date = Date()
    private var hora = "Sem horário definido"
    private var categoria = "Sem categoria"
    
    
    @IBOutlet weak var refreshButton: UIButton!
    var cellAnterior: NovoEncontroCollectionViewCell?

    
    weak var delegate: NovoEncontroViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Os itens comecam escondidos até o calculo ser iniciado
        mapView.isHidden = true
        mapView.layer.cornerRadius = 8
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
    public let pointsExamplee: [CLLocationCoordinate2D] = [
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
    
    /// Quantidade de pontos adicionados no mapa
    public var pinAdded: Int = 0
    
    
    
    
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
            circle.fillColor = UIColor(named: "Color4Principal")?.withAlphaComponent(0.3)
            circle.strokeColor = UIColor(named: "Color4Principal")
            circle.lineWidth = 1.0
            return circle
        // }
        // return overlay
    }
    
    
    /// Personaliza um pin
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        
        if annotation.title!! == "The Midway" {
            annotationView.markerTintColor = UIColor(named: "Color4Principal")
        } else if annotation.title!! == " " {
            annotationView.markerTintColor = UIColor(named: "Color2Principal")
        }
        return annotationView
    }
    
    
    /* MARK: - Ação dos botões */
    
    /// Ativa o único botão da tela
    public func theMidwayMapUpdate(enderecos: [String]) -> Void {
        self.coordFound = []
        self.nerbyPlaces = []
        
        if enderecos.count != 0 {
            let group = DispatchGroup()
            
            for end in enderecos {
                group.enter()
                NovoEncontroViewController.getCoordsByAddress(address: end) { point in
                    defer {group.leave()}

                    switch point {
                    case .failure(let error):
                        print(error)
                    case .success(let coords):
                        self.coordFound.append(coords)
                        self.addPointOnMap(pin: self.createPin(name: " ", coordinate: coords))
                    }
                }
            }

            
            group.notify(queue: .main) {
                // Pega o ponto central
                self.midpoint = self.theMidpoint(coordinates: self.coordFound)

                // Adiciona o ponto central
                self.addPointOnMap(pin: self.createPin(name: "The Midway", coordinate: self.midpoint))
                
                // Cria um cículo
                self.addCircle(location: self.midpoint)
                
                // Define a região que vai ser focada no mapa: o ponto dentral
                self.setViewLocation(place: self.midpoint, radius: self.radiusArea+3000)
                
                // Faz a busca por locais a partr das palavras chaves.
                for someWord in self.searchWords {
                    self.getNerbyPlaces(someWord)
                }
            }
        }
    }
    
    // MARK: Done button
    
    @IBAction func doneButton(_ sender: UIButton) {
        
        // Título
        let index = IndexPath(row: 0, section: 0)
        let cell: TextFieldCell = self.tableView.cellForRow(at: index) as! TextFieldCell
        if cell.textField.text == ""{
            self.encontroTitle = "Novo Encontro"
        }
        else{
            self.encontroTitle = cell.textField.text!
        }
        
        //data
        let index2 = IndexPath(row: 1, section: 0)
        let cell2: QuandoSeraTableViewCell = self.tableView.cellForRow(at: index2) as! QuandoSeraTableViewCell
        self.date = cell2.datePicker.date
        self.hora = self.getHora(datePickerOutlet: cell2.datePicker)
            
        // Adicionando no core data
        let novoEncontro = try? EncontroData.addEncontro(
            novoNome: self.encontroTitle,
            nomeLocal: self.localTitle,
            novoEndereco: self.encontroEndereco,
            novoData: self.date,
            hora: self.hora,
            categoria: self.categoria
        )
        
        // Adicionando pessoas no encontro
        for pessoa in self.pessoas{
            _ = try? PessoaData.addPessoa(novo: pessoa, encontro: novoEncontro!)
        }
        
        EncontroData.saveContext()
        
        // Atualiza
        self.delegate?.didReload()
        
        // Fecha tela
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        let ac = UIAlertController(
            title: "Cancelar encontro",
            message: "Tem certeza que deseja descartar esse encontro? Essa ação não poderá ser desfeita!",
            preferredStyle: .actionSheet
        )
        
        ac.addAction(
            UIAlertAction(
                title: "Ignorar alterações",
                style: .destructive,
                handler: {[] action in
                    self.dismiss(animated: true, completion: nil)
                }
            )
        )
        
        ac.addAction(
            UIAlertAction(
                title: "Continuar editando",
                style: .cancel,
                handler: nil
            )
        )
        
        self.present(ac, animated: true)
    }
    
    
    
    @IBAction func reload(_ sender: Any) {
        self.collectionView.isHidden = false
        self.collectionView.reloadInputViews()
        self.collectionView.reloadData()
        self.mapView.isHidden = false
    }
    
    
    func getHora(datePickerOutlet: UIDatePicker) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: datePickerOutlet.date)
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
            date = cell.datePicker.date
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
extension NovoEncontroViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if nerbyPlaces.count > 20{
            return 20
        }
        return nerbyPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "novoEncontroCollection", for: indexPath) as! NovoEncontroCollectionViewCell
        if self.nerbyPlaces.count != 0 {
            cell.stylize(nearbyPlace: self.nerbyPlaces[indexPath.row])
            cell.delegate = self
        }
        return cell
    }
    
    
}

extension NovoEncontroViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: NovoEncontroCollectionViewCell = self.collectionView.cellForItem(at: indexPath)as! NovoEncontroCollectionViewCell
        self.desativarOutras(cell: cell)
        cellAnterior = cell
        cell.clickCheck()
        
        let bairro = String(nerbyPlaces[indexPath.row].district)
        let rua = String(nerbyPlaces[indexPath.row].address)
        let numero = String(nerbyPlaces[indexPath.row].number)
        
        let newAddress = "\(rua), \(numero) - \(bairro)"
        self.encontroEndereco = newAddress
        self.localTitle = String(nerbyPlaces[indexPath.row].name)
        
        self.categoria = nerbyPlaces[indexPath.row].type.localizedDescription
 
    }
    
    func desativarOutras(cell: NovoEncontroCollectionViewCell){
        if cellAnterior != cell {
            cellAnterior?.desative()
        }
    }
}

// MARK: Delegate

extension NovoEncontroViewController: QuemVaiViewControllerDelegate{
    
    //funcao para pegar as strings
    func getAdress(endFriends: [String]){
        self.enderecos = endFriends
    }
    
    func getPessoas(newPessoas: [PessoaBase]){
        self.pessoas = newPessoas
        for i in 0..<pessoas.count{
            self.enderecos[i] = pessoas[i].endereco
        }
        print("enderecosTeste",self.enderecos)
    }
    
    func didReload() {
        // Add ação do botão
        self.mapView?.reloadInputViews()
        self.collectionView?.reloadInputViews()
        self.collectionView?.reloadData()
    }
    
    func getLocations() {
        self.theMidwayMapUpdate(enderecos: self.enderecos)
        self.refreshButton?.isHidden = false
        self.localLabel.isHidden = false
    }
}

extension NovoEncontroViewController: NovoEncontroCollectionViewCellDelegate{
    func newLocation(nearbyPlace: MapPlace) {
        self.localTitle = nearbyPlace.name
        self.encontroEndereco = "Endereco do local encontrado"
    }
}



