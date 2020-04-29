//  gameSession.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/17/20.
//  Copyright © 2020 DB. All rights reserved.
//
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
    var mapView: MKMapView
    var flags: Array<UIImageView>
    
    init(timeAmount: Int, timer: Timer, locationManger: CLLocationManager, endGame: Array<MKPointAnnotation>, label: UILabel, result: UILabel, announcment: UIView, view: UIView, mapView: MKMapView, flags: Array<UIImageView>) {
        self.timeAmount = timeAmount
        self.timer = timer
        self.locationManger = locationManger
        self.endGame = endGame
        self.label = label
        self.result = result
        self.announcment = announcment
        self.view = view
        self.dispFlag = [Bool](repeating: false, count: 8)
        self.amountDisp = [Double](repeating: 0.0, count: 8)
        self.mapView = mapView
        self.flags = flags
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    
    // Checks the distance and updates them
    @objc func countDown() { // This was changed from test to countdown
        
        // Since we are importing the framework foundation,
        // It is best to use one of the functions provided from
        // the class DateComponentsFormatter to format the time left
        let formatTimeLeft = DateComponentsFormatter()
        let formatSec : String
        
        formatTimeLeft.unitsStyle = .abbreviated
        formatTimeLeft.allowedUnits = [.minute, .second]

        formatSec = formatTimeLeft.string(from: Double(timeAmount)) ?? "AA"
        
        label.text = formatSec
        
        if win() || timeAmount == 0 {
            timer.invalidate()
            showResults()
        }
        // Occurs last so that you have the total time
        timeAmount -= 1
    }
    
    func win() -> Bool {
        var result = true
        // Calculate the distance to check
        // if you have obtained any flags
        checkDist()
        
        // Checking if the user obtained all
        // the flags
        for x in 0...7 {
            
            if dispFlag[x] == false {
                result = false
            } else {
                flags[x].isHidden = false
            }
        }
        return result
    }
    
    func showResults() {
        // Under the condition that person
        // won , show that they have won
        if win() {
            result.textColor = UIColor.green
            result.text = "YOU WIN"
        } else {
            // else show that they have lost
            result.textColor = UIColor.red
            result.text = "YOU LOST"
        }
        // allowing to display the view
        announcment.center = view.center
        view.addSubview(announcment)
    }
}
