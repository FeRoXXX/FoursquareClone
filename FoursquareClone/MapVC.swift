//
//  MapVC.swift
//  
//
//  Created by Александр Федоткин on 18.11.2023.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    private var chosenLatitude = ""
    private var chosenLongitude = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseNavigationButton()
        setup()
        addRecognizer()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}

//MARK: - Init location
extension MapVC : MKMapViewDelegate, CLLocationManagerDelegate {
    func setup(){
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

//MARK: - add recognizer + choseLocation
private extension MapVC {

    func addRecognizer(){
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(choseLocation(gestureRecognizer: )))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }

    @objc func choseLocation(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            self.chosenLatitude = String(coordinates.latitude)
            self.chosenLongitude = String(coordinates.longitude)
        }
    }
}

//MARK: - style for navigationController
private extension MapVC{

    func initialiseNavigationButton(){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
    }

    @objc func saveButtonClicked(){
        
    }

    @objc func backButtonClicked(){
        self.dismiss(animated: true)
    }
}
