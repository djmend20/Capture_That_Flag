//
//  helpGameSession.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/20/20.
//  Copyright © 2020 DB. All rights reserved.
//

import Foundation

extension gameSession {
    
    func checkDist() {
        
        for x in 0...7 {
            // Calculating the distance of all flags from your location
            amountDisp[x] = calcDist(position: x+1)
            if (amountDisp[x] < 20 && timeAmount > 0) { 
                dispFlag[x] = true
                mapView.removeAnnotation(endGame[x+1])
            }
        }
    }
    func calcDist(position: Int) -> Double {
        //https://www.movable-type.co.uk/scripts/latlong.html
        // https://stackoverflow.com/questions/26324050/how-to-get-mathemical-pi-constant-in-swift
        // The links from the above code informs us of the formula and how to get pi. By using the information we found out what framework has the other math functions by trial and error 
        let currLocationLat = self.locationManger.location?.coordinate.latitude ?? 0.0
        let currLocationLong = self.locationManger.location?.coordinate.longitude ?? 0.0
        
        let endLocationLat = self.endGame[position].coordinate.latitude
        let endLocationLong = self.endGame[position].coordinate.longitude

        
        let R = 6378137 // metres
        let lat1 = (currLocationLat * Double.pi) / 180
        let lat2 = (endLocationLat * Double.pi) / 180
        let difflat = ((endLocationLat-currLocationLat) * Double.pi) / 180
        let differLong = ((endLocationLong-currLocationLong) * Double.pi) / 180

        
        let a = sin(difflat/2) * sin(difflat/2) +
                cos(lat1) * cos(lat2) *
                sin(differLong/2) * sin(differLong/2);
        let c = 2 * atan2(sqrt(a), sqrt(1-a));
        let distance = Double(R) * c;
        
        return distance
    }

}
