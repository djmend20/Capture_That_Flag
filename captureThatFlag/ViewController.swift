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
    @IBOutlet var label: UILabel!
    @IBOutlet var resultDisplay: UILabel!
    @IBOutlet var announcment: UIView!
    
    @IBOutlet var timeLeft: UITextField!
    
    

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
    
    var userIsSpeeding = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !(startGame) {
            beforeGame()
        } else if userIsSpeeding{
            print("BOI")
            gameStarted()
            checkAcceeleration()
            viewDidLoad()
        } else {
            checkAcceeleration()
            viewDidLoad()
            print("BOI#2")
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
        }
    }
    
    func gameStarted() {
        //
        if startGame {
            print("if of gamstarted")
            amountTime = gameRecord.timeAmount
            timeLeft.text = String(amountTime)
            if gameRecord.win() {
                print("in gameRecord.win")
                resultDisplay.textColor = UIColor.green
                resultDisplay.text = "YOU WON"
                announcment.center = view.center
                view.addSubview(announcment)
            } else {
                if gameRecord.timeAmount == 0 {
                    print("in gameRecord.timeAmount")
                    gameRecord.stopTimer()
                    resultDisplay.textColor = UIColor.red
                    resultDisplay.text = "YOU LOST"
                    announcment.center = view.center
                    view.addSubview(announcment)
                } else {
                    //https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift/27517642
                    //https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/sleep.3.html
                    super.viewDidLoad()
                }
            }
            
        }
    }
    // easier to check if in ithe circle
    //https://developer.apple.com/documentation/corelocation/clcircularregion
    
    @IBAction func startGame(_ sender: Any) {
        print("outer StartGame")
        timeLeft.text = String(amountTime)
        if !(startGame) {
            // this block sets up the landmark you are going to
            let resultAnnotation = createAnnotation(locationManager: locationManager)
            startingLocationX = resultAnnotation.0
            startingLocationY = resultAnnotation.1
            mapkitView.addAnnotation(resultAnnotation.2)
            
            // zoomIn does what the name of the function suggests
            DispatchQueue.main.async {
                self.mapkitView.setRegion(zoomIn(startingLocationX: self.startingLocationX, startingLocationY: self.startingLocationY), animated: !self.startGame)
            }
            print("before GameRecord")
            
            
            gameRecord = gameSession(timeAmount: amountTime, timer: timer, timeLeft: stringtimeLeft, locationManger: locationManager, endGame: CLLocation(latitude: resultAnnotation.2.coordinate.latitude, longitude: resultAnnotation.2.coordinate.longitude))
            amountTime = gameRecord.timeAmount
//            startGame = true
            print("starting gameStarted")

            checkAcceeleration()
            viewDidLoad()
        }
    }
    
    func checkAcceeleration() {
        let userSpeed = locationManager.location?.speed ?? -1.0
        print(userSpeed)
        
        if userSpeed > 0.0 {
            userIsSpeeding = true
            startGame = true
        } else {
            userIsSpeeding = false
        }
    }
    
    @IBAction func exitView(_ sender: Any) {
        self.announcment.removeFromSuperview()
    }
    @IBAction func resetGame(_ sender: Any) {
        startGame = false
        mapkitView.removeAnnotation(dest1)
    }
    //https://stackoverflow.com/questions/41292565/how-to-detect-if-iphone-is-in-motion
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

