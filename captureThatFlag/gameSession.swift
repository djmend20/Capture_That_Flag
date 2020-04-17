//  gameSession.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/17/20.
//  Copyright © 2020 DB. All rights reserved.
//
import Foundation
import MapKit
import UIKit

class gameSession  {
    var timeAmount: Int
    var timer: Timer
    var timeLeft: String
    var locationManger: CLLocationManager
    var endGame: CLLocation
    
    init(timeAmount: Int, timer: Timer, timeLeft: String, locationManger: CLLocationManager, endGame: CLLocation) {
        self.timeAmount = timeAmount
        self.timer = timer
        self.timeLeft = timeLeft
        self.locationManger = locationManger
        self.endGame = endGame
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(test), userInfo: nil, repeats: true)
    }
    
    func stopTimer() -> Void{
        timer.invalidate()
    }

    @objc func test() {
        print("Yes")
        timeAmount -= 1
        timeLeft = String(timeAmount)
        if timeAmount == 0 {
            timer.invalidate()
        }
    }
    func checkDis() -> Double {
        //https://www.movable-type.co.uk/scripts/latlong.html
        // https://stackoverflow.com/questions/26324050/how-to-get-mathemical-pi-constant-in-swift
        
        let currLocationLat = self.locationManger.location?.coordinate.latitude ?? 0.0
        let currLocationLong = self.locationManger.location?.coordinate.longitude ?? 0.0
        
        let endLocationLat = self.endGame.coordinate.latitude
        let endLocationLong = self.endGame.coordinate.longitude

        
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
    
    func win() -> Bool {
        var result = false
        let amountDist = checkDis()
        if (amountDist < 40 && timeAmount > 0) {
            timeLeft = String(timeAmount)
            print("The current value of amountDist is \(amountDist)")
            result = true
        }
        
        return result
    }
    
    func resetGameVariables(newLocation: CLLocation) {
        timeAmount = 720
        timeLeft = String(timeAmount)
        endGame = newLocation
    }
}
