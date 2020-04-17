//
//  location_functions.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/16/20.
//  Copyright © 2020 DB. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// generates a random location to be added 
func randomPositionForLoc(latitude: Double, longitude: Double) -> (latRandom: Double, longRandom: Double)  {
    var randomX = Double.random(in: 0.0 ..< 0.10)
    var randomY = Double.random(in: 0.0 ..< 0.10)
    var determine = Double.random(in: 0 ..< 2)
    
    while randomX == 0 && randomY == 0 {
        randomX = Double.random(in: 0.0 ..< 0.1)
        randomY = Double.random(in: 0.0 ..< 0.1)
    }
    
    if determine <= 1 {
        randomX *= -1
    }
    determine = Double.random(in: 0 ..< 2)
    if determine <= 1 {
        randomY *= -1
    }
    randomX = (((latitude) * 69) - randomX) / 69
    randomY = (((longitude) * 69) - randomY) / 69
    return (randomX, randomY)
}

// create the landmark to add onto the map

func createAnnotation(locationManager: CLLocationManager) -> (Double, Double, MKPointAnnotation) {
    let startingLocation = locationManager.location?.coordinate
    let startingLocationX = startingLocation?.latitude ?? 0.0
    let startingLocationY = startingLocation?.longitude ?? 0.0
      
      
    let randomXY = randomPositionForLoc(latitude: startingLocationX, longitude: startingLocationY)
    
    let dest1 = MKPointAnnotation()
    dest1.coordinate.latitude = randomXY.latRandom
    dest1.coordinate.longitude = randomXY.longRandom
    
    return (startingLocationX, startingLocationY, dest1)
}

// zoom in to display a birds eye view of the infrastructure you are around
func zoomIn(startingLocationX: Double, startingLocationY: Double) -> MKCoordinateRegion {
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: startingLocationX, longitude: startingLocationY), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
    
    return region
}
