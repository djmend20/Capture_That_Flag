//
//  ViewController.swift
//  captureThatFlag
//
//  Created by David Mendoza on 4/16/20.
//  Copyright © 2020 DB. All rights reserved.
//
import UIKit
import MapKit
import Darwin


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapkitView: MKMapView!
    
    @IBOutlet var resultDisplay: UILabel!
    @IBOutlet var announcment: UIView!
    @IBOutlet var timeLeft: UILabel!
    @IBOutlet var textFlagRecievd: UILabel! // not modified
    
    @IBOutlet var blackFlag: UIImageView!
    @IBOutlet var blueFlag: UIImageView!
    @IBOutlet var greenFlag: UIImageView!
    @IBOutlet var pinkFlag: UIImageView!
    @IBOutlet var purpleFlag: UIImageView!
    @IBOutlet var redFlag: UIImageView!
    @IBOutlet var whiteFlag: UIImageView!
    @IBOutlet var yellowFlag: UIImageView!
    //
    var flags = [UIImageView]()
    let locationManager = CLLocationManager()
    
    
    var startGame = false
    
    
    var dest1 = MKPointAnnotation()
    
    var amountTime = 1800  //
    var timer = Timer()
    var gameRecord: gameSession!
    var stringtimeLeft = ""
    var nameFlags = ["black", "blue", "green", "pink", "purple", "red", "white", "yellow"]
    

    var landMark = Array<MKPointAnnotation>(repeating: MKPointAnnotation(), count: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if !(startGame) {
            mapkitView.delegate = self
            mapkitView.showsUserLocation = true
            
            // this allows the app to gain access to your location
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            
            beforeGame()
        } else {
            gameRecord.startTimer()
        }
        
        // let startingLocation = locationManager.location?.coordinate
    }
    
    func beforeGame() {
        
        // this makes sure we have access so we can continue
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            // setting the region so it can zoom in
            landMark = createAnnotation(startingLocationLat: (locationManager.location?.coordinate.latitude ?? 0.0), startingLocationLong: (locationManager.location?.coordinate.longitude ?? 0.0), destinationArray: landMark)
            mapkitView.setRegion(zoomIn(startingLocationX: landMark[0].coordinate.latitude, startingLocationY: landMark[0].coordinate.longitude), animated: !startGame)
        }
    }
    
    // easier to check if in ithe circle
    //https://developer.apple.com/documentation/corelocation/clcircularregion
    
    @IBAction func beginGame(_ sender: Any) {
        
        if !(startGame) {
            flags = [blackFlag, blueFlag, greenFlag, pinkFlag, purpleFlag, redFlag, whiteFlag, yellowFlag]
            hideFlag(flags: flags)
            
            for x in 1...8 {
                mapkitView.addAnnotation(landMark[x])
            }
            //works  up until this point
            gameRecord = gameSession(timeAmount: amountTime, timer: timer, locationManger: locationManager, endGame: landMark, label: timeLeft, result: resultDisplay, announcment: announcment, view: view, mapView: mapkitView, flags: flags)
            startGame = true
            viewDidLoad()
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
            
            for x in 1...8 {
                
                mapkitView.removeAnnotation(landMark[x])
                flags[x-1].isHidden = false
            }
            timeLeft.text = "?"
        }
        
        startGame = false
        beforeGame()
    }
    //https://stackoverflow.com/questions/41292565/how-to-detect-if-iphone-is-in-motion
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
