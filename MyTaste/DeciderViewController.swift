//
//  DeciderViewController.swift
//  MyTaste
//
//  Created by Ahmad on 28/1/21.
//

import UIKit

class DeciderViewController: UIViewController {
    
    // The below code is the definition/initialisation of different variable items
    @IBOutlet weak var chosenRestaurantButton: UIButton!
    @IBOutlet weak var decideButton: UIButton!
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var spinImageView: UIImageView!
    @IBOutlet weak var restImageView: UIImageView!
    var restaurants: [RestaurantInfo] = [];
    var restIndex = 0;
    var selectedRestaurant: RestaurantInfo?;
    
    // The below function is the entry function of this view. It will load with the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        // The below code will hide the decided button before the app predict a restaurant.
        chosenRestaurantButton.isHidden = true;
    }
    
    
    // The below code is the spinning function that would animate the spin of the wheel and randomly choose a restaurants from my saved one to decide where to eat
    @IBAction func spin(sender: UIButton) {
        let savedRestaurants = UserDefaultManagement.shared.getRecord();
        for var i in 0..<savedRestaurants.count {
            restaurants.append(savedRestaurants[i]);
            i += 1;
        }
        UIView.animate(
            withDuration: 0.4
            ,delay: 0.0
            ,options: [.curveLinear]
            ,animations: ({
                self.spinImageView.transform = self.spinImageView.transform.rotated(by: CGFloat(Double.pi));
            })
            ,completion: {_ in
                if self.restaurants.count > 0{
                    self.restIndex = Int.random(in: 0..<self.restaurants.count);
                    self.decisionLabel.text = self.restaurants[self.restIndex].name;
                    self.selectedRestaurant = self.restaurants[self.restIndex];
                    self.restImageView.image = UIImage(data: self.restaurants[self.restIndex].coverImage);
                    self.chosenRestaurantButton.isHidden = false;
                } else {
                    let alert = UIAlertController(title: "No Restaurants", message: "Please add two or more restaurants to My taste View and try again", preferredStyle: .alert);
                    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
                    alert.addAction(alertAction);
                    self.present(alert, animated: true);
                }
            })
    }
    
    // The below code will prepare the segue before it load the predicted restaurant and send the value to the MyRestaurant View.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="mealSegue"{
            let destinationController=segue.destination as! MyRestaurant_VC;
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
            destinationController.restaurant=selectedRestaurant;
        }
    }
    
    // The below code will perform the segue once the user press the Restaurant's meals.
    @IBAction func chosingRestaurant(){
        self.performSegue(withIdentifier: "mealSegue", sender: nil)
    }
}
