//
//  MyTaste_VC.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import Foundation
import UIKit

class MyTaste_VC: UIViewController {
    var selectedRestaurant:RestaurantInfo!
    @IBOutlet weak var CollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserDefaultManagement.shared.clearRecord()
        CollectionView.delegate=self
        CollectionView.dataSource=self
        CollectionView.collectionViewLayout=UICollectionViewFlowLayout()
        //Create an observer to see when user add a new restaurant
        NotificationCenter.default.addObserver(self,
             selector: #selector(addNewRestaurant(notification:)),
             name: Notification.Name("addNewRestaurant"),
             object: nil)
    }
    //When user add a new restaurant, update the database and collection view
    @objc func addNewRestaurant(notification: Notification){
        let insertIndexPath=IndexPath(row: UserDefaultManagement.shared.getRecord().count-1, section: 0)
        CollectionView.insertItems(at: [insertIndexPath])
    }
    // Navigate to add new restaurant view
    @IBAction func addButtonClicked(){
        self.performSegue(withIdentifier: "addNewRestaurant", sender: nil)
    }
}

extension MyTaste_VC:UICollectionViewDataSource{
    //The data source of th collection is from the UDM
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserDefaultManagement.shared.getRecord().count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as! SingleRestaurantCell
        cell.setUp(UserDefaultManagement.shared.getRecord()[indexPath.row])
        //become the delegate of the single restaurant cell
        cell.delegate=self
        return cell
    }
    //Pass the data of the selected restaurant info to My restaurant VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toARestaurant"{
            let destinationController=segue.destination as! MyRestaurant_VC
            destinationController.restaurant=selectedRestaurant
        }
    }
}
    //Configure the flow layout of the collection view
extension MyTaste_VC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 10, bottom: 0, right: 10)
    }
}
    // Every time clicking on a row, navigate to My Restaurant VC
extension MyTaste_VC:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRestaurant=UserDefaultManagement.shared.getRecord()[indexPath.row]
        self.performSegue(withIdentifier: "toARestaurant", sender: nil)
    }
}
extension MyTaste_VC:SingleRestaurantCellDelegate{
    //when the delete button in the single restaurant is clicked, delete the item in collection view
    func deleteRestaurant(selectedRestaurant: RestaurantInfo, cell: SingleRestaurantCell) {
        if let indexPath=CollectionView.indexPath(for: cell){
            CollectionView.deleteItems(at: [indexPath])
        }
    }
}
