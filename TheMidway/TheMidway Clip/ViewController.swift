//
//  ViewController.swift
//  TheMidway Clip
//
//  Created by Beatriz Duque on 09/12/21.
//

import UIKit
import MapKit
import EventKit
import EventKitUI
import CoreLocation
import CoreLocation


class ViewController: UIViewController, EKEventEditViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
        
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var encontroLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    var encontroTitle: String?
    
    let eventStore = EKEventStore()
    var time = Date()
    var date = Date()
    
    var timeString: String?
    var dateString: String?
    
    var locationManager: CLLocationManager?
    var latitude = 0.0
    var longitude = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.mapView.delegate = self
        
        // Define o delegate das localizações
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        // Criando anotação do mapa
        createAnnotation()
    }

    
    @IBAction func actionAddInCalendar(_ sender: Any) {
//        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
//                   DispatchQueue.main.async {
//                       if (granted) && (error == nil) {
//                           let event = EKEvent(eventStore: self.eventStore)
//                           event.title = self.encontroTitle ?? "Novo encontro TheMidway"
//                           #warning("LEMBRAR DE COLOCAR O TIME COM O COISO DO DATE PICKER")
//                           event.startDate = self.time
//                           event.url = URL(string: "https://apple.com")
//                           event.endDate = self.time
//                           let eventController = EKEventEditViewController()
//                           eventController.event = event
//                           eventController.eventStore = self.eventStore
//                           eventController.editViewDelegate = self
//                           self.present(eventController, animated: true, completion: nil)
//                       }
//                   }
//            })
        
        let vc = UIActivityViewController(activityItems: ["Olha o The Midway que eu encontrei para nós!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
                    //print("locations = \(locValue.latitude) \(locValue.longitude)")
                    self.latitude = locValue.latitude
                    self.longitude = locValue.longitude
                }
            }
        }
        self.mapView.reloadInputViews()
        self.createAnnotation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.mapView.reloadInputViews()
        self.createAnnotation()
    }
    
    func createAnnotation(){
            let annotations = MKPointAnnotation()
            annotations.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.latitude)
            self.mapView.addAnnotation(annotations)
            self.enderecoLabel.text = String(self.latitude) + String(self.longitude)
    }
    
}


extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///clique na celula
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadInputViews()
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
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
            let comp = cell.datePicker.calendar.dateComponents([.hour, .minute], from: cell.datePicker.date)

            self.date = cell.datePicker.date
            self.time = cell.datePicker.date
            
            let formatter =  DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            self.dateString = formatter.string(from: cell.datePicker.date)
            self.timeString = String(comp.hour!) + "h" + String(comp.minute!)
            
            cellBase = cell
            
        }
        return cellBase
    }
}
