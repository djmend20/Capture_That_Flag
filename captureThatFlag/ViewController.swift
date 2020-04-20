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
    
    
    let locationManager = CLLocationManager()
    
    
    var startGame = false
    
    var startingLocationX = 0.0
    var startingLocationY = 0.0
    var dest1 = MKPointAnnotation()
    
    var amountTime = 1800  //
    var timer = Timer()
    var gameRecord: gameSession!
    var stringtimeLeft = ""
    var nameFlags = ["black", "blue", "green", "pink", "purple", "red", "white", "yellow"]
    

    var landMark = Array<MKPointAnnotation>()
    
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
            startingLocationX = locationManager.location?.coordinate.latitude ?? 0.0
            startingLocationY = locationManager.location?.coordinate.longitude ?? 0.0
            let landMarkPoint = MKPointAnnotation()
            landMarkPoint.coordinate.latitude = startingLocationX
            landMarkPoint.coordinate.longitude = startingLocationY
            landMark.append(landMarkPoint)
            landMark = createAnnotation(startingLocationLat: startingLocationX, startingLocationLong: startingLocationY, destinationArray: landMark)
            
            mapkitView.setRegion(zoomIn(startingLocationX: startingLocationX, startingLocationY: startingLocationY), animated: !startGame)
        }
    }
    
    // easier to check if in ithe circle
    //https://developer.apple.com/documentation/corelocation/clcircularregion
    
    @IBAction func beginGame(_ sender: Any) {
        
        if !(startGame) {
                   // this block sets up the landmark you are going to
                   // zoomIn does what the name of the function suggests
            for x in 1...8 {
                mapkitView.addAnnotation(landMark[x])
            }
            //works  up until this point
            gameRecord = gameSession(timeAmount: amountTime, timer: timer, locationManger: locationManager, endGame: landMark, label: timeLeft, result: resultDisplay, announcment: announcment, view: view)
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
            }
            timeLeft.text = "?"
        }
        startGame = false
    }
    //https://stackoverflow.com/questions/41292565/how-to-detect-if-iphone-is-in-motion
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //https://www.youtube.com/watch?v=936-KHll9Ao
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var positionLandMark: Int = 0
        var positionColorFlag: Int = 0
        let annotationView: MKAnnotationView
        var transform = CGAffineTransform() // reason why not var bc it must be initialized
        // cant use a switch in this case because its type MKAnnotation
        // it was attempted
        if annotation.isEqual(landMark[1]) {
            positionLandMark = 1
            positionColorFlag = 0
        } else if annotation.isEqual(landMark[2]) {
            positionLandMark = 2
            positionColorFlag = 1
        } else if annotation.isEqual(landMark[3]) {
            positionLandMark = 3
            positionColorFlag = 2
        } else if annotation.isEqual(landMark[4]) {
            positionLandMark = 4
            positionColorFlag = 3
        } else if annotation.isEqual(landMark[5]) {
            positionLandMark = 5
            positionColorFlag = 4
        } else if annotation.isEqual(landMark[6]) {
            positionLandMark = 6
            positionColorFlag = 5
        } else if annotation.isEqual(landMark[7]) {
            positionLandMark = 7
            positionColorFlag = 6
        } else if annotation.isEqual(landMark[8]) {
            positionLandMark = 8
            positionColorFlag = 7
        } else {
            return nil
        }
        annotationView = MKAnnotationView(annotation: landMark[positionLandMark], reuseIdentifier: nameFlags[positionColorFlag])
        annotationView.image = UIImage(named: nameFlags[positionColorFlag])
    
        transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        annotationView.transform = transform
    
        return annotationView
    }

}



