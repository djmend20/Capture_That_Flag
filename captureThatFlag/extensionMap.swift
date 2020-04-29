//
//  extensionMap.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/20/20.
//  Copyright © 2020 DB. All rights reserved.
//

import UIKit
import MapKit

extension ViewController {
    
    //https://www.youtube.com/watch?v=936-KHll9Ao
    // code copy to change annotation is everything but lines 28-54
    // lines 24-50 allows us to select which annotation to give the flag since the scren constantly
    // updates as you move it else after you move the screen the annotations will revert back to the
    // ordinary annotations. Reason why this is not a switch formate is annotation can not be compared
    // to so annotation comes with a property to compare values as seen by these if block statements
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var positionLandMark: Int = 0
        var positionColorFlag: Int = 0
        let annotationView: MKAnnotationView
        var transform = CGAffineTransform()

        if annotation.isEqual(landMark[1]) {
            positionLandMark = 1
            positionColorFlag = 0
        } else if annotation.isEqual(landMark[2]) {
            positionLandMark = 2
            positionColorFlag = 1
        } else if annotation.isEqual(landMark[3]) {
            positionLandMark = 3
            positionColorFlag = 2
        } else if annotation.isEqual(landMark[4]) {
            positionLandMark = 4
            positionColorFlag = 3
        } else if annotation.isEqual(landMark[5]) {
            positionLandMark = 5
            positionColorFlag = 4
        } else if annotation.isEqual(landMark[6]) {
            positionLandMark = 6
            positionColorFlag = 5
        } else if annotation.isEqual(landMark[7]) {
            positionLandMark = 7
            positionColorFlag = 6
        } else if annotation.isEqual(landMark[8]) {
            positionLandMark = 8
            positionColorFlag = 7
        } else {
            return nil
        }
        
        annotationView = MKAnnotationView(annotation: landMark[positionLandMark], reuseIdentifier: nameFlags[positionColorFlag])
        annotationView.image = UIImage(named: nameFlags[positionColorFlag])
    
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        annotationView.transform = transform
    
        return annotationView
    }
}
