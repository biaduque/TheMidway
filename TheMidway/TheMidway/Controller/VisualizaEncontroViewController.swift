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
    
    var latitude = -23.523580
    var longitude = -46.774770
    
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
        nomeDoLocalLabel?.text = encontro?.nomeLocal
        enderecoLabel?.text = encontro?.endereco
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
}
