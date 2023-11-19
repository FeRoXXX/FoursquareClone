//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Александр Федоткин on 18.11.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController {
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
