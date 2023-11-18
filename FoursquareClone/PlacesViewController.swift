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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        customisationNC()
    }
    

}

//MARK: - setup table
private extension PlacesViewController{

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
        cellStyle.text = "123"
        cell.contentConfiguration = cellStyle
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

//MARK: - Navigation customisation
private extension PlacesViewController{
    
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
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription as? String ?? "error", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            } else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }
}
