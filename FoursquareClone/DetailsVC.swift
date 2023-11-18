//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Александр Федоткин on 18.11.2023.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    @IBOutlet private weak var detailsImageView: UIImageView!
    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeTypeLabel: UILabel!
    @IBOutlet private weak var placeAtmosphereLabel: UILabel!
    @IBOutlet private weak var detailsMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
