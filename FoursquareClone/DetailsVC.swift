//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Александр Федоткин on 18.11.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController{
    @IBOutlet private weak var detailsImageView: UIImageView!
    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeTypeLabel: UILabel!
    @IBOutlet private weak var placeAtmosphereLabel: UILabel!
    @IBOutlet private weak var detailsMapView: MKMapView!
    
    private var chosenPlacesId = ""
    private var chosenLatitude : Double = 0
    private var chosenLongitude : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromParse()
        setup()
    }
    
}

//MARK: - get data from server
private extension DetailsVC {

    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlacesId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription as? String ?? "Error", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            } else {
                if objects != nil {
                    for object in objects! {
                        //OBJECTS
                        
                        if let placeName = object["name"] as? String {
                            self.placeNameLabel.text = placeName
                        }
                        if let placeType = object["type"] as? String {
                            self.placeTypeLabel.text = placeType
                        }
                        if let placeAtmosphere = object["atmosphere"] as? String {
                            self.placeAtmosphereLabel.text = placeAtmosphere
                        }
                        if let placeLatitude = object["latitude"] as? String {
                            if let placeLongitude = object["longitude"] as? String{
                                self.chosenLatitude = Double(placeLatitude)!
                                self.chosenLongitude = Double(placeLongitude)!
                            }
                        }
                        if let imageData = object["image"] as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.detailsImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        // MAPS
                        self.settingMap()
                    }
                }
            }
        }
    }
}

//MARK: - setup mapDelegate
extension DetailsVC : MKMapViewDelegate {
    func setup(){
        detailsMapView.delegate = self
    }
}

//MARK: - Maps zoom and annotation
private extension DetailsVC{

    func settingMap(){
        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location, span: span)
        self.detailsMapView.setRegion(region, animated: true)
        addAnotation(location: location)
    }
    
    func addAnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = self.placeNameLabel.text
        annotation.subtitle = self.placeTypeLabel.text
        self.detailsMapView.addAnnotation(annotation)
    }
}

//MARK: - Add pin button and open maps
extension DetailsVC {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placeNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}

//MARK: - set privat variables
extension DetailsVC {

    func setChosenId(selectedId: String){
        chosenPlacesId = selectedId
    }
}
