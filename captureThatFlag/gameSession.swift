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
    var timeAmount: Int // stays the same
    var timer: Timer // the same
    var label:UILabel // the same
    var locationManger: CLLocationManager // stays the same
    var endGame: Array<MKPointAnnotation> // needs to be an array
    var result:UILabel // only once all are done
    var announcment:UIView // stays the same
    var view: UIView // stays the same
    var dispFlag: Array<Bool>
    var amountDisp: Array<Double>
    
    init(timeAmount: Int, timer: Timer, locationManger: CLLocationManager, endGame: Array<MKPointAnnotation>, label: UILabel, result: UILabel, announcment: UIView, view: UIView) {
        self.timeAmount = timeAmount
        self.timer = timer
        self.locationManger = locationManger
        self.endGame = endGame
        self.label = label
        self.result = result
        self.announcment = announcment
        self.view = view
        self.dispFlag = [Bool](repeating: false, count: 7)
        self.amountDisp = [Double](repeating: 0.0, count: 7)
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
    
    // checks the distance and updates them
    func checkDist() {
        
        for x in 0...6 {
            
            amountDisp[x] = calcDist(position: x+1)
            if (amountDisp[x] < 20 && timeAmount > 0) { // before 40
                dispFlag[x] = true
            }
        }
    }
    
    func win() -> Bool {
        let result = true
        checkDist()
        for x in 0...7 {
            if dispFlag[x] == false {
                return false
            }
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
