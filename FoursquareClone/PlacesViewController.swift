//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Александр Федоткин on 16.11.2023.
//

import UIKit
import Parse

class PlacesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var placeNameArray = [String]()
    private var placeIdArray = [String]()
    private var selectedPlaceId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setup()
        customisationNC()
    }
    
}

//MARK: - setup table
private extension PlacesViewController {

    func setup(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - TableViewDelegate + TableViewDataSource
extension PlacesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var cellStyle = cell.defaultContentConfiguration()
        cellStyle.text = placeNameArray[indexPath.row]
        cell.contentConfiguration = cellStyle
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}

//MARK: - Navigation customisation
private extension PlacesViewController {
    
    func customisationNC(){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutButtonClicked))
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toAddPlacesVC", sender: nil)
    }
    
    @objc func logoutButtonClicked(){
        PFUser.logOutInBackground { error in
            if error != nil{
                self.makeAlert(title: "Error!", message: error?.localizedDescription as? String ?? "Error")
            } else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }
}

//MARK: - prepare to send
extension PlacesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.setChosenId(selectedId: selectedPlaceId)
        }
    }
}

//MARK: - Get data from server
private extension PlacesViewController {
    
    func getData(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil{
                self.makeAlert(title: "Error!", message: error?.localizedDescription as? String ?? "Error")
            } else{
                if objects != nil {
                    self.placeIdArray.removeAll()
                    self.placeNameArray.removeAll()
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId{
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - makeAlert function
private extension PlacesViewController{

    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
