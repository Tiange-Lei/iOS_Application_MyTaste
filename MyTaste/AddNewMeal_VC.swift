//
//  AddNewMeal_VC.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import Foundation
import UIKit

class AddNewMeal_VC: UIViewController {
    var datePicker:UIDatePicker!
    var mealArray:[MealDetail]=[MealDetail(index: 0, mealName: ""),MealDetail(index: 1,mealName: "")]
    var thisRestaurantInfo:RestaurantInfo!
    @IBOutlet weak var DoneBarButton: UIBarButtonItem!
    @IBOutlet weak var DishLabel: UILabel!
    @IBOutlet weak var DishStepper: UIStepper!
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var DateTextField: UITextField!
    var previousValue = 2
    @IBAction func DishStepperChanged(_ sender: UIStepper) {
        
        if Int(sender.value) > previousValue {
            mealArray.append(MealDetail(index:mealArray.count,mealName: ""))
                let insertIndexPath=IndexPath(row: mealArray.count-1, section: 0)
                CollectionView.insertItems(at: [insertIndexPath])
        }else {
                mealArray.removeLast()
                let insertIndexPath=IndexPath(row: mealArray.count, section: 0)
                CollectionView.deleteItems(at: [insertIndexPath])
        }
        previousValue = Int(sender.value)
        DishLabel.text=String(Int(sender.value))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(UserDefaultManagement.shared.getRecord())

        setupDatePicker()
        DishStepper.value=2
        CollectionView.delegate=self
        CollectionView.dataSource=self
        CollectionView.collectionViewLayout=UICollectionViewFlowLayout()
    }
    func addMealInfo(oldMealInfoRecord:RestaurantInfo,mealDetail:[MealDetail],mealDate:String)->RestaurantInfo{
        var newRecord=oldMealInfoRecord
        if newRecord.mealInfoArray == nil{
            newRecord.mealInfoArray=[]
        }
        newRecord.mealInfoArray!.append(MealInfo(date: mealDate, info: mealDetail))
        return newRecord
    }
    @IBAction func DoneWithAddingMeal(){
        var invalidCount=[Int]()
        for meal in mealArray{
            if meal.mealImage == UIImage(systemName: "plus")?.pngData() || meal.mealName == "" || meal.rate == 0{
                invalidCount.append(1)
            }
        }
        guard !invalidCount.contains(1) else{
            let alertController=UIAlertController(title: "", message: "Please complete all the information required", preferredStyle:  .alert)
            let alertAction=UIAlertAction(title: "OK", style:  .cancel)
                alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let newRecord=addMealInfo(oldMealInfoRecord: thisRestaurantInfo, mealDetail: mealArray, mealDate: DateTextField.text!)
        let newRestaurantInfo=UserDefaultManagement.shared.updateRecord(newInfo: newRecord)
        let recordInfo=try! PropertyListEncoder().encode(newRestaurantInfo)
        UserDefaultManagement.shared.defaults.set(recordInfo, forKey: "record")
        let selectedMealInfo = try! PropertyListEncoder().encode(newRecord)
        UserDefaultManagement.shared.defaults.setValue(selectedMealInfo, forKey: "currentSelected")
        NotificationCenter.default.post(name: Notification.Name("addNewMeal"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func setupDatePicker(){
        datePicker=UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            datePicker.preferredDatePickerStyle = .wheels
        }
        let toolBar:UIToolbar=UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 45))
        let doneButton=UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonClicked))
        toolBar.setItems([doneButton], animated: true)
        DateTextField.inputAccessoryView=toolBar
        DateTextField.inputView=datePicker
    }
    // Change the date into wanted formate when done button clicked
    @objc func doneButtonClicked(){
        let formatter=DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        DateTextField.text=formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

}
extension AddNewMeal_VC:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "SingleMealCell", for: indexPath) as! SingleMealCell
        cell.cellNumer=mealArray[indexPath.row].index
        //Display the content inside textfield if available
        if mealArray[indexPath.row].mealName != ""{
            cell.MealNameTextField.text=mealArray[indexPath.row].mealName
        }
        //Display the image if available
        if let savedImage=mealArray[indexPath.row].mealImage{
            cell.AddMealImageButton.setBackgroundImage(UIImage(data: savedImage), for: .normal)
        }
        //Display the rating stars accordingly
        if let savedScore=mealArray[indexPath.row].rate{
            switch savedScore{
                case 1:
                    cell.firstStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                case 2:
                    cell.firstStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                    cell.secondStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                case 3:
                    cell.firstStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                    cell.secondStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                    cell.thirdStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
                default:
                    cell.firstStarButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
            }

        }
        cell.delegate=self
        cell.MealNameTextField.autocorrectionType = .no
        cell.MealNameTextField.returnKeyType = .done
        cell.MealNameTextField.delegate=self
        return cell
    }
}
//Configure the layout setting of collection view
extension AddNewMeal_VC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:self.view.bounds.width , height: 311)
    }
}
extension AddNewMeal_VC: SingleMealCellDelegate{
    // When new dish info is given, update the data stored in mealArray
    func updateMealImage(image: UIImage, cell: SingleMealCell) {
        if let indexPath=CollectionView?.indexPath(for: cell){
            guard indexPath.row <= mealArray.count-1 else{
                return
            }
            mealArray[indexPath.row].mealImage=image.pngData()!
        }
    }
    
    func updateMealName(mealName: String, cell: SingleMealCell) {
        if let indexPath=CollectionView?.indexPath(for: cell){
            guard indexPath.row <= mealArray.count-1 else{
                return
            }
            mealArray[indexPath.row].mealName=mealName
        }
    }
    
    func updateRateScore(score: Int, cell: SingleMealCell) {
        if let indexPath=CollectionView?.indexPath(for: cell){
            guard indexPath.row <= mealArray.count-1 else{
                return
            }
            mealArray[indexPath.row].rate=score
        }
    }
    
}
extension AddNewMeal_VC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
    }
    //adjust the view to make the textfield visible
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DoneBarButton.isEnabled=false
        UIView.animate(withDuration: 0.4, animations: {
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 130, width: self.view.frame.size.width, height: self.view.frame.size.height);
        })
    }
    //adjust back to normal
    func textFieldDidEndEditing(_ textField: UITextField) {
        DoneBarButton.isEnabled=true
        UIView.animate(withDuration: 0.4, animations: {
        self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 130, width: self.view.frame.size.width, height: self.view.frame.size.height);
        })
    }
}
