//
//  MapViewDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 26/01/22.
//

import UIKit
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    
    /// Todos os desenhos são configurados nessa função delegate. (OBS: caso faça algum outro desenho precisa específica com o if comentado)
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // if overlay is MKCircle {
            print("Estou no delegate do círculo")
        
            let circle = MKCircleRenderer(overlay: overlay)
            circle.fillColor = UIColor(named: "Color4")?.withAlphaComponent(0.2)
            circle.strokeColor = UIColor(named: "Color4")
            circle.lineWidth = 1.0
            return circle
        // }
        // return overlay
    }
    
    
    /// Personaliza um pin
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "costumannotation")
        
        if annotation.subtitle!!.contains("The Midway") {
            annotationView.markerTintColor = UIColor(named: "AccentColor")
            // return self.createAnnotationView(annotation, imageName: "UserTheMidway.svg")
        }
        
//        if self.peopleSelected.keys.contains(annotation.title!!) {
//            let imgNumber = self.peopleSelected[annotation.title!!]?.image
//            return self.createAnnotationView(annotation, imageName: "Perfil\(imgNumber!).svg")
//        }
        
        return annotationView
    }
    
    
    
    /* MARK: - Criação */
    
    /// Cria um pin com uma imagem
    private func createAnnotationView(_ annotation: MKAnnotation, imageName: String) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "costumannotation")
        // annotationView.canShowCallout = true
        annotationView.image =  UIImage(named: imageName) // self.resizeImage(imageName: imageName, newSize: CGSize(width: 30, height: 30))
        return annotationView
    }
    
}
