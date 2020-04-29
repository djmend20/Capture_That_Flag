//
//  location_functions.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/16/20.
//  Copyright © 2020 DB. All rights reserved.
//

import UIKit
import MapKit

// generates a random location to be added 
func randomPositionForLoc(latitude: Double, longitude: Double) -> (latRandom: Double, longRandom: Double)  {
    // This block of code selects a random number
    // that represents the miles we want exclusively
    // in the latitude and longitude.
    // We know that the max distance is approximatly 0.13 miles
    // from prior calculations of the distance using the latiude and longitude
    // of the new location.
    var determine: Double
    var randomX = Double.random(in: 0.0 ..< 0.1)
    var randomY = Double.random(in: 0.0 ..< 0.1)
    
    
    while randomX == 0 && randomY == 0 { // In the unlikely but possible case  that both random values are zero repeat the random process
        randomX = Double.random(in: 0.0 ..< 0.1)
        randomY = Double.random(in: 0.0 ..< 0.1)
    }
    
    determine = Double.random(in: 0 ..< 2) // random double number of 0 to 2 to select if distance is + or - distance
                                          // done to avoid distance to be exactly zero for both latiude and longitude
    // Selecting whether to add onto the starting location
    if determine <= 1 {
        randomX *= -1
    }
    
    // Selection repeated again for randomness
    determine = Double.random(in: 0 ..< 2)
    if determine <= 1 {
        randomY *= -1
    }
    
    //https://www.google.com/search?q=degrees+to+miles&rlz=1C5CHFA_enUS783US783&oq=degrees+to+mile&aqs=chrome.0.0j69i57j0l6.2792j0j7&sourceid=chrome&ie=UTF-8
    // As the link informs us that latitude and longitude are in terms of degrees
    // Then we must first multiply by 69 then after subtracting random distance we must convert back to degrees
    randomX = (((latitude) * 69) - randomX) / 69
    randomY = (((longitude) * 69) - randomY) / 69
    
    return (randomX, randomY) // tuple of a new location's latitude and longitude 
}

// Create the landmark to be placed on the map which are an array of MKPointAnnotations
func createAnnotation(startingLocationLat: Double, startingLocationLong: Double, destinationArray: Array<MKPointAnnotation>) -> Array<MKPointAnnotation> {
    
    var destinations = destinationArray
    var aDestination = MKPointAnnotation()
    var randomXY = (0.0, 0.0)
    
    aDestination.coordinate.latitude = startingLocationLat
    aDestination.coordinate.longitude = startingLocationLong
    destinations[0] = aDestination
    
    for position in 1...8 {
        aDestination = MKPointAnnotation()
        
        randomXY = randomPositionForLoc(latitude: startingLocationLat, longitude: startingLocationLong)
        aDestination.coordinate.latitude = randomXY.0
        aDestination.coordinate.longitude = randomXY.1
        destinations[position] = aDestination
        
    }
    
    return destinations
}

// Since the flags are pictures as seen before
// the UIImageView comes with a property to hide the image
func hideFlag(flags: Array<UIImageView>) {
    for x in 0...7 {
      flags[x].isHidden = true
    }
}

// Zoom in to display a birds eye view of the infrastructure you are around
// This it was learned here: https://www.youtube.com/watch?v=8m-duJ9X_Hs&t=4536s
// Title is: MapKit: Turn-By-Turn Navigation | Swift 4, Xcode 9
func zoomIn(startingLocationX: Double, startingLocationY: Double) -> MKCoordinateRegion {
    
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: startingLocationX, longitude: startingLocationY), span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
    
    return region
}
