//
//  VisualizaEncontroViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 07/12/21.
//

import UIKit
import MapKit
import EventKit
import EventKitUI

class VisualizaEncontroViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tituloEncontroLabel: UILabel?
    @IBOutlet weak var dataLabel: DataView?
    @IBOutlet weak var nomeDoLocalLabel: UILabel?
    @IBOutlet weak var enderecoLabel: UILabel?
    @IBOutlet weak var tagView: TagView!
    @IBOutlet weak var labelTagView: UILabel!
    @IBOutlet weak var collectionConvidados: UICollectionView!
    
    var latitude = -23.523580
    var longitude = -46.774770
    
    var encontro: Encontro?
    var amigos: [Pessoa]?
    
    let eventStore =  EKEventStore()
    let time = Date()
    
    override func viewWillAppear(_ animated: Bool) {
        amigos = try? PessoaData.getPessoa(encontro: encontro!)
        content()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionConvidados.delegate = self
        collectionConvidados.dataSource = self
        self.mapView.delegate = self
        DispatchQueue.main.async {
            self.createAnnotation()
        }
    }
    
    
    public func content(){
        tituloEncontroLabel?.text = encontro?.nome
        dataLabel?.style(dataEncontro: encontro?.data ?? Date())
        let hora = encontro?.hora
        let dataEhora = String((dataLabel?.text!)!) + " - " + String(hora!)
        dataLabel?.text = dataEhora
        nomeDoLocalLabel?.text = encontro?.nomeLocal
        enderecoLabel?.text = encontro?.endereco
        tagView.stilyze(categoria: "Shopping")
        labelTagView.text = "Shopping"
    }
    
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func shareAction(_ sender: Any) {
        
        let ac = UIAlertController(
            title: tituloEncontroLabel?.text ?? "Encontro",
            message: "Selecione a opção desejada",
            preferredStyle: .actionSheet
        )
        
        ac.addAction(
            UIAlertAction(
                title: "Compartilhar",
                style: .default,
                handler: {[] action in
                    self.share()
                }
            )
        )
        
        ac.addAction(
            UIAlertAction(
                title: "Abrir no Maps",
                style: .default,
                handler: {[] action in
                    self.openMaps()
                }
            )
        )
        ac.addAction(
            UIAlertAction(
                title: "Adicionar no calendário",
                style: .default,
                handler: {[] action in
                    self.openCalendar()
                }
            )
        )
        
        ac.addAction(
            UIAlertAction(
                title: "Cancelar",
                style: .cancel,
                handler: nil
            )
        )
        self.present(ac, animated: true)
        
       
        
        
    
    }
    
    func openMaps(){
                //let latitude = view.annotation?.coordinate.latitude ?? 0
                //let longitude = view.annotation?.coordinate.longitude ?? 0
                
                let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
                let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
                let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
                
                let googleItem = ("Google Map", URL(string:googleURL)!)
                let wazeItem = ("Waze", URL(string:wazeURL)!)
                var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
                
                if UIApplication.shared.canOpenURL(googleItem.1) {
                    installedNavigationApps.append(googleItem)
                }
                
                if UIApplication.shared.canOpenURL(wazeItem.1) {
                    installedNavigationApps.append(wazeItem)
                }
                
                let alert = UIAlertController(title: "Seleção", message: "Selecione o App que deseja abrir", preferredStyle: .actionSheet)
                for app in installedNavigationApps {
                    let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                        UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
                    })
                    alert.addAction(button)
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancel)
                present(alert, animated: true)
    }
    
    func share(){
        let vc = UIActivityViewController(activityItems: ["Olha esse TheMidway que encontrei para a gente: ", tituloEncontroLabel?.text, dataLabel?.text, enderecoLabel?.text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    
    func openCalendar(){
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
                   DispatchQueue.main.async {
                       if (granted) && (error == nil) {
                           let event = EKEvent(eventStore: self.eventStore)
                           event.title = self.tituloEncontroLabel?.text
                           event.startDate = self.encontro?.data
                           event.url = URL(string: "https://apple.com")
                           let eventController = EKEventEditViewController()
                           eventController.event = event
                           eventController.eventStore = self.eventStore
                           eventController.editViewDelegate = self
                           self.present(eventController, animated: true, completion: nil)
                           
                       }
                   }
               })
    }
    
}

// MARK: Calendar event
extension VisualizaEncontroViewController: EKEventEditViewDelegate{
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: MapView
extension VisualizaEncontroViewController: MKMapViewDelegate{
    
    func createAnnotation(){
        guard let endereco = encontro?.endereco else { return }

        NovoEncontroViewController.getCoordsByAddress(address: endereco) { point in
            switch point {
            case .failure(let error):
                print(error)
            case .success(let coords):
                let annotations = MKPointAnnotation()
                annotations.coordinate = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
                self.latitude = coords.latitude
                self.longitude = coords.longitude
                self.mapView.addAnnotation(annotations)
                
                let radiusArea: Double = 4000
                
                let region = MKCoordinateRegion(
                    center: annotations.coordinate,
                    latitudinalMeters: radiusArea,
                    longitudinalMeters: radiusArea
                )
                
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
}

extension VisualizaEncontroViewController: UICollectionViewDelegate{
    
}
extension VisualizaEncontroViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amigos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "amigosCell", for: indexPath) as! AmigosCollectionViewCell
        cell.stylize(nome: self.amigos?[indexPath.row].nome ?? "Convidado")
        return cell
    }
    
    
}
