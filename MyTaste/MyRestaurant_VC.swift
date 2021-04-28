//
//  MyRestaurant_VC.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import Foundation
import UIKit

class MyRestaurant_VC: UIViewController {
    var restaurant:RestaurantInfo!
//    var mealInfoArray:[MealInfo]?
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title=restaurant.name
        TableView.dataSource=self
        TableView.rowHeight=300
        
        NotificationCenter.default.addObserver(self,
             selector: #selector(addNewMeal(notification:)),
             name: Notification.Name("addNewMeal"),
             object: nil)
    }
    //When being notified user added a meal, relaod the table view
    @objc func addNewMeal(notification: Notification){
        if let selectedRestaurant=UserDefaultManagement.shared.getCurrentSelectedRestaurantInfo(){
            restaurant=selectedRestaurant
            TableView.reloadData()
        }
    }
    
    @IBAction func addMealClicked(){
        self.performSegue(withIdentifier: "addNewMeal", sender: nil)
    }
    // pass the selected restaurant data to add new meal vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="addNewMeal"{
            let destinationController=segue.destination as! AddNewMeal_VC
            destinationController.thisRestaurantInfo=restaurant
        }
    }
}

extension MyRestaurant_VC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let restaurantMealInfo=restaurant.mealInfoArray{
            return restaurantMealInfo.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let restaurantMealInfo=restaurant.mealInfoArray{
            return restaurantMealInfo[section].info.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        if let restaurantMealInfo=restaurant.mealInfoArray{
            let mealInfos=restaurantMealInfo[indexPath.section]
            let mealDetail=mealInfos.info[indexPath.row]
            cell.dishNameLabel.text=mealDetail.mealName
            if let image=mealDetail.mealImage{
                cell.dishImageView.image=UIImage(data: image)
            }else{
                cell.dishImageView.image=nil
            }
            if let rating=mealDetail.rate{
                switch rating {
                case 1:
                    cell.dishRatingImageView.image=UIImage(named: "1Star")
                case 2:
                    cell.dishRatingImageView.image=UIImage(named:  "2Star")
                case 3:
                    cell.dishRatingImageView.image=UIImage(named: "3Star")
                default:
                    cell.dishRatingImageView.image=nil
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let restaurantMealInfo=restaurant.mealInfoArray{
        let mealInfos=restaurantMealInfo[section]
            return mealInfos.date
        }else{
            return nil
        }
    }
    //Configure the delete row function for table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if var restaurantMealInfo=restaurant.mealInfoArray{
                restaurantMealInfo[indexPath.section].info.remove(at: indexPath.row)
                let updatedMealInfoArray=restaurantMealInfo.filter{$0.info.count > 0}
                restaurant.mealInfoArray=updatedMealInfoArray
                let updatedRestaurantInfo=UserDefaultManagement.shared.updateRecord(newInfo: restaurant)
                let recordInfo=try! PropertyListEncoder().encode(updatedRestaurantInfo)
                UserDefaultManagement.shared.defaults.set(recordInfo, forKey: "record")
                TableView.reloadData()
            }
        }
    }
}
