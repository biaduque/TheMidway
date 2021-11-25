//
//  NovoEncontroViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit
import MapKit

class NovoEncontroViewController: UIViewController {

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
        //mapView.isHidden = true
        //collectionView.isHidden = true
        //localLabel.isHidden = true
        
        
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "quemVai"){
            let displayVC = segue.destination as! QuemVaiViewController
            displayVC.delegate = self
        }
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "novoEncontroCollection", for: indexPath) as! NovoEncontroCollectionViewCell
        cell.stylize()
        return cell
    }
    
    
}

// MARK: Delegate

extension NovoEncontroViewController: QuemVaiViewControllerDelegate{
    func didReload() {
        self.collectionView.reloadData()
        self.mapView.reloadInputViews()
    }
}
