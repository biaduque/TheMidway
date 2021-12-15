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
    

    let names = ["Bakery", "Bar", "Cinema", "Coffee", "Restaurant", "Shopping", "Theater"]
    
    
    @IBOutlet weak var collectionSugestoes: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var encontroLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    var encontroTitle: String?
    
    let eventStore = EKEventStore()
    var time = Date()
    var date = Date()
    
    var timeString: String?
    var dateString: String?
    

    var actualLocal: String?
    var cellAnterior: SugestoesCollectionViewCell?
    var isFirstRun = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.collectionSugestoes.delegate = self
        self.collectionSugestoes.dataSource = self
      
        
    }

    
    @IBAction func actionAddInCalendar(_ sender: Any) {
        
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
    
    @IBAction func refresh(_ sender: Any) {
        
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

// MARK: - Collection View
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sugestoesCell", for: indexPath) as! SugestoesCollectionViewCell
        cell.stylize(index: indexPath.row)
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: SugestoesCollectionViewCell = self.collectionSugestoes.cellForItem(at: indexPath)as! SugestoesCollectionViewCell
        self.desativarOutras(cell: cell)
        cellAnterior = cell
        cell.didChange()
        self.actualLocal = names[indexPath.row]
        //collectionView.reloadData()
        print(indexPath.row)
    }
    
    func desativarOutras(cell: SugestoesCollectionViewCell){
        if cellAnterior != cell {
            cellAnterior?.desativate()
        }
    }
}

extension ViewController: SugestoesCollectionViewCellDelegate{
    func changeLocal(local: String) {
        self.actualLocal = local
    }
}
