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
            
            amountDisp[x] = calcDist(position: x+1)
            if (amountDisp[x] < 20 && timeAmount > 0) { // before 40
                dispFlag[x] = true
                mapView.removeAnnotation(endGame[x+1])
            }
        }
    }
    func calcDist(position: Int) -> Double {
        //https://www.movable-type.co.uk/scripts/latlong.html
        // https://stackoverflow.com/questions/26324050/how-to-get-mathemical-pi-constant-in-swift
        
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
    
    @objc func test() {
        
        timeAmount -= 1
        
        let minute = Int(timeAmount / 60)
        let minute_floatVal = Double(Double(timeAmount) / 60.0)
        let seconds = Int(Double((minute_floatVal - Double(timeAmount / 60)) * 60.0).rounded())
        
        if minute == 0 && timeAmount != 0 {
            label.text = String(1) + String(seconds)
        } else {
            label.text = String(minute) + ":" + String(seconds)
        }
        
        if win() || timeAmount == 0 {
            timer.invalidate()
            showResults()
        }
        
    }
}
