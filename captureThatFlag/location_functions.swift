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
    var randomX = Double.random(in: 0.0 ..< 0.1)
    var randomY = Double.random(in: 0.0 ..< 0.1)
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

func createAnnotation(startingLocationLat: Double, startingLocationLong: Double, destinationArray: Array<MKPointAnnotation>) -> Array<MKPointAnnotation> {
    
    var destinations = destinationArray
    var aDestination = MKPointAnnotation()
    
    var randomXY = (0.0, 0.0)
    
    for _ in 1...8 {
        randomXY = randomPositionForLoc(latitude: startingLocationLat, longitude: startingLocationLong)
        aDestination.coordinate.latitude = randomXY.0
        aDestination.coordinate.longitude = randomXY.1
        
        destinations.append(aDestination)
        aDestination = MKPointAnnotation()
    }
    
    return destinations
}

// zoom in to display a birds eye view of the infrastructure you are around
func zoomIn(startingLocationX: Double, startingLocationY: Double) -> MKCoordinateRegion {
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: startingLocationX, longitude: startingLocationY), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
    
    return region
}
