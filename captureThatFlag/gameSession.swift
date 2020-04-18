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
    var label:UILabel
    var locationManger: CLLocationManager
    var endGame: CLLocation
    var result:UILabel
    var announcment:UIView
    var view: UIView
    
    init(timeAmount: Int, timer: Timer, locationManger: CLLocationManager, endGame: CLLocation, label: UILabel, result: UILabel, announcment: UIView, view: UIView) {
        self.timeAmount = timeAmount
        self.timer = timer
        self.locationManger = locationManger
        self.endGame = endGame
        self.label = label
        self.result = result
        self.announcment = announcment
        self.view = view
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(test), userInfo: nil, repeats: true)
    }
    
    func stopTimer() -> Void{
        timer.invalidate()
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
        
        if (amountDist < 20 && timeAmount > 0) { // before 40
            result = true
        }
        return result
    }
    
    func showResults() {
        if win() {
            result.textColor = UIColor.green
            result.text = "YOU WIN"
        } else {
            result.textColor = UIColor.red
            result.text = "YOU LOST"
        }
        announcment.center = view.center
        view.addSubview(announcment)
    }
}
