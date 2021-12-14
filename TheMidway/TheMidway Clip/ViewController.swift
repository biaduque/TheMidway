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
        self.enderecoLabel.text = "Marque um Midway em sua localização atual"
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
        
        // titulo do encontro compartilhado
        let index = IndexPath(row: 0, section: 0)
        let cell: TextFieldCell = self.tableView.cellForRow(at: index) as! TextFieldCell
        self.encontroTitle = cell.textField.text!
        
        //data e hora compartilhados
        
        let index2 = IndexPath(row: 1, section: 0)
        let cell2: QuandoSeraTableViewCell = self.tableView.cellForRow(at: index2) as! QuandoSeraTableViewCell
        let comp = cell2.datePicker.calendar.dateComponents([.hour, .minute], from: cell2.datePicker.date)

        self.date = cell2.datePicker.date
        self.time = cell2.datePicker.date
        
        let formatter =  DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.dateString = formatter.string(from: cell2.datePicker.date)
        self.timeString = String(comp.hour!) + "h" + String(comp.minute!)
        
        
        let vc = UIActivityViewController(activityItems: ["Olha o The Midway que eu encontrei para nós!",
                                                          encontroTitle ?? "Meu novo encontro",
                                                          "Data e hora planejados:",
                                                          dateString ?? "Sem data definida",
                                                          timeString ?? "Sem horário definido"], applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func getHora(datePickerOutlet: UIDatePicker) -> String {
        let comp = datePickerOutlet.calendar.dateComponents([.hour, .minute], from: datePickerOutlet.date)
        let hora = String(comp.hour!) + "h" + String(comp.minute!)
        return hora
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .denied {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
                    //print("locations = \(locValue.latitude) \(locValue.longitude)")
                    self.latitude = locValue.latitude
                    self.longitude = locValue.longitude
                }
            }
        }
        self.createAnnotation()
        self.mapView.reloadInputViews()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.createAnnotation()
        self.mapView.reloadInputViews()
    }
    
    func createAnnotation(){
            let annotations = MKPointAnnotation()
            annotations.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.latitude)
            self.mapView.addAnnotation(annotations)
            let region = MKCoordinateRegion(center: annotations.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.createAnnotation()
        self.mapView.reloadInputViews()
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
