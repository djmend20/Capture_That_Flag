//
//  ViewController.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/16/20.
//  Copyright © 2020 DB. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapkitView: MKMapView!
    @IBOutlet var resultDisplay: UILabel!
    @IBOutlet var announcment: UIView!
    
    
    @IBOutlet var timeLeft: UILabel!
    
    
    let locationManager = CLLocationManager()
    
    
    var startGame = false
    var gameSpot: Array<MKPlacemark>?
    var optainAddr = "610 Washington St, Brighton, MA 02135"
    var startingLocationX = 0.0
    var startingLocationY = 0.0
    var dest1 = MKPointAnnotation()
 
    var amountTime = 720
    var timer = Timer()
    var gameRecord: gameSession!
    var stringtimeLeft = ""
    

    var landMark = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !(startGame) {
            beforeGame()
        } else {
            gameRecord.startTimer()
        }
        
        
        
        // let startingLocation = locationManager.location?.coordinate
        
    }
    func beforeGame() {
        mapkitView.delegate = self
        mapkitView.showsUserLocation = true
        
        
        // this allows the app to gain access to your location
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        
        
        // this makes sure we have access so we can continue
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            // setting the region so it can zoom in
            
            let resultAnnotation = createAnnotation(locationManager: locationManager)
            landMark = createAnnotation(locationManager: locationManager).2
            startingLocationX = resultAnnotation.0
            startingLocationY = resultAnnotation.1
            mapkitView.setRegion(zoomIn(startingLocationX: startingLocationX, startingLocationY: startingLocationY), animated: !startGame)
        }
    }
    
    // easier to check if in ithe circle
    //https://developer.apple.com/documentation/corelocation/clcircularregion
    
    @IBAction func startGame(_ sender: Any) {
        
        
        if !(startGame) {
            // this block sets up the landmark you are going to
            // zoomIn does what the name of the function suggests
            
            mapkitView.addAnnotation(landMark)
            
            gameRecord = gameSession(timeAmount: amountTime, timer: timer, locationManger: locationManager, endGame: CLLocation(latitude: 42.355900, longitude: -71.159920), label: timeLeft, result: resultDisplay, announcment: announcment, view: view)
            startGame = true
            viewDidLoad()
            //landMark.coordinate.latitude
            //landMark.coordinate.longitude
        }
    }

    
    @IBAction func exitView(_ sender: Any) {
        self.announcment.removeFromSuperview()
    }
    @IBAction func resetGame(_ sender: Any) {
    
        if gameRecord != nil {
            // basically for some reason its still going
            // so we stop the timer and reset the amount
            if gameRecord.timer.isValid {
                gameRecord.timer.invalidate()
            }
            //swift will get rid of the instance according to
            // https://stackoverflow.com/questions/51582916/delete-an-instance-of-a-class-in-swift
            gameRecord = nil
            mapkitView.removeAnnotation(landMark)
        }
        startGame = false
    }
    //https://stackoverflow.com/questions/41292565/how-to-detect-if-iphone-is-in-motion
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

