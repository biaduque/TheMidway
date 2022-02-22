//
//  MapViewDelegate.swift
//  TheMidway
//
//  Created by Gui Reis on 26/01/22.
//

import UIKit
import MapKit

class MapViewDelegate: NSObject, MKMapViewDelegate {
    
    /* MARK: - Atributos */
    
    private var participants: [Person] = []
    
    private let imageSize: CGFloat = 45
    
    
    
    /* MARK: - Encapsulamento */
    
    public func setParticipantsSelected(_ list: [Person]) -> Void {
        self.participants = list
    }
    
    
    
    /* MARK: - Delegate */
    
    /// Todos os desenhos são configurados nessa função delegate. (OBS: caso faça algum outro desenho precisa específica com o if comentado)
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.fillColor = UIColor(named: "Color4")?.withAlphaComponent(0.18)
        circle.strokeColor = UIColor(named: "Color4")
        circle.lineWidth = 1.0
        return circle
    }
    
    
    /// Personaliza um pin
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "costumannotation")
        
        // Define a cor do ponto médio
        if annotation.subtitle!!.contains("The Midway") {
            annotationView.markerTintColor = UIColor(named: "AccentColor")
        }
        
        // Define o ícone do participante
        let ind = self.isParticipant(with: annotation.title!!)
        if ind != -1 {
            let imgNumber = self.participants[ind].image
            return self.createAnnotationView(annotation, imageName: "Perfil 0\(imgNumber).png")
        }
        
        return annotationView
    }
    
        
    
    /* MARK: - Outros */
    
    /// Verifica se é um participante e retorna a posição da lista
    private func isParticipant(with title: String) -> Int {
        for index in 0..<self.participants.count {
            if self.participants[index].contactInfo.name == title {
                return index
            }
        }
        return -1
    }
    
    
    /// Cria um pin com uma imagem
    private func createAnnotationView(_ annotation: MKAnnotation, imageName: String) -> MKAnnotationView {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "costumannotation")
        annotationView.canShowCallout = true
        annotationView.image = self.resizeImage(imageName: imageName)
        annotationView.accessibilityLabel = annotation.title!!
        return annotationView
    }
    
    
    /// Redimensiona uma imagem
    private func resizeImage(imageName: String) -> UIImage {
        let image = UIImage(named: imageName)
        UIGraphicsBeginImageContext(CGSize(width: self.imageSize, height: self.imageSize))
        image?.draw(in: CGRect(x: 0, y: 0, width: self.imageSize, height: self.imageSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
