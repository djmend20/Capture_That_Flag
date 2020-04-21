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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(test), userInfo: nil, repeats: true)
    }
    
    func stopTimer() -> Void{
        timer.invalidate()
    }
    
    // checks the distance and updates them
    
    func win() -> Bool {
        var result = true
        
        checkDist()
        
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
