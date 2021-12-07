//
//  VisualizaEncontroViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 07/12/21.
//

import UIKit
import MapKit

class VisualizaEncontroViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tituloEncontroLabel: UILabel?
    @IBOutlet weak var dataLabel: DataView?
    @IBOutlet weak var nomeDoLocalLabel: UILabel?
    @IBOutlet weak var enderecoLabel: UILabel?
    @IBOutlet weak var tagView: UIView?
    
    var encontro: Encontro?
    
    override func viewWillAppear(_ animated: Bool) {
        content()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public func content(){
        tituloEncontroLabel?.text = encontro?.nome
        dataLabel?.style(dataEncontro: encontro?.data ?? Date())
        nomeDoLocalLabel?.text = encontro?.endereco
        enderecoLabel?.text = encontro?.endereco
    }
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func shareAction(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: ["Olha esse TheMidway que encontrei para a gente: ", tituloEncontroLabel?.text, dataLabel?.text, enderecoLabel?.text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
}
