//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Александр Федоткин on 16.11.2023.
//

import UIKit
import PhotosUI

class AddPlaceVC: UIViewController {
    
    @IBOutlet weak var placesNameText: UITextField!
    @IBOutlet weak var placesTypeText: UITextField!
    @IBOutlet weak var placesAtmosphereText: UITextField!
    @IBOutlet weak var loadImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapOnImageView()
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if placesNameText.text != "" && loadImage.image != UIImage(systemName: "square.and.arrow.up") && placesTypeText.text != "" && placesAtmosphereText.text != ""{
            let placeModel = PlaceModel.sharedInstance
            placeModel.placeAtmosphere = placesAtmosphereText.text!
            placeModel.placeImage = loadImage.image!
            placeModel.placeName = placesNameText.text!
            placeModel.placeType = placesTypeText.text!
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else{
            makeAlert(title: "Error!", message: "Place Name/Type/Atmosphere??")
        }
    }
}

//MARK: - GestureRecognizer + SelectImage
extension AddPlaceVC : PHPickerViewControllerDelegate{
    
    func tapOnImageView(){
        loadImage.isUserInteractionEnabled = true
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        loadImage.addGestureRecognizer(gestureRecogniser)
    }
    
    @objc func changeImage(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (image, error) in
                    if error != nil{
                        self.makeAlert(title: "Error", message: error?.localizedDescription as? String ?? "Error")
                    } else{
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                self.loadImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - makeAlert function
private extension AddPlaceVC{

    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
