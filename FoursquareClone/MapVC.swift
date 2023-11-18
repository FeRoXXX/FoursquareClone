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

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseNavigationButton()
        setup()
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
