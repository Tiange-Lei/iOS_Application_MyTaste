//
//  SingleMealCell.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import UIKit
protocol SingleMealCellDelegate: class{
    func updateMealName(mealName:String,cell:SingleMealCell)
    func updateMealImage(image:UIImage,cell:SingleMealCell)
    func updateRateScore(score:Int,cell:SingleMealCell)
}
class SingleMealCell: UICollectionViewCell {
    
    @IBOutlet weak var AddMealImageButton: UIButton!
    @IBOutlet weak var MealNameTextField: UITextField!
    
    
    @IBOutlet weak var firstStarButton: UIButton!
    
    @IBOutlet weak var secondStarButton: UIButton!
    
    @IBOutlet weak var thirdStarButton: UIButton!
    
    
    weak var delegate:SingleMealCellDelegate?
    var mealName:String?
    var cellNumer:Int?
    var mealImage:UIImage?
    var rateScore=0
    var alertController:UIAlertController!
    //set the rating star button background image
    @IBAction func firstButtonClicked(){
        firstStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        secondStarButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        thirdStarButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        rateScore=1
        delegate?.updateRateScore(score: rateScore, cell: self)
    }
    @IBAction func secondButtonClicked(){
        firstStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        secondStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        thirdStarButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        rateScore=2
        delegate?.updateRateScore(score: rateScore, cell: self)
    }
    @IBAction func thirdButtonClicked(){
        firstStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        secondStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        thirdStarButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
        rateScore=3
        delegate?.updateRateScore(score: rateScore, cell: self)
    }
    @IBAction func FinishInputDishName(_ sender: UITextField) {
        mealName=MealNameTextField.text
        delegate?.updateMealName(mealName: mealName!,cell: self)
    }
    @IBAction func addImageClicked(){
        presentActionSheet()
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    func presentActionSheet(){
        //present the action sheet to choose the way to upload image
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Check if the photo library is available, if so, create the action.If not, create alert
        let photoLibraryAction=UIAlertAction(title: "Choose from photo library",style: .default) { (action) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else{
                let alertController=UIAlertController(title: "", message: "Please allow access to the photo library", preferredStyle:  .alert)
                let alertAction=UIAlertAction(title: "OK", style:  .cancel)
                    alertController.addAction(alertAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                return
            }
            let vc=UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing=true
            self.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        //Check if the camera is available, if so, create the action.If not, create alert
        let cameraAction=UIAlertAction(title: "Take a photo", style: .default) { (action) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else{
                let alertController=UIAlertController(title: "", message: "Please allow access to the camera", preferredStyle:  .alert)
                let alertAction=UIAlertAction(title: "OK", style:  .cancel)
                    alertController.addAction(alertAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                return
            }
            let vc=UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing=true
            self.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        let cancelAction=UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
    }
    //For the new reuseable cell, give the cell default value for each component
    override func prepareForReuse() {
        super.prepareForReuse()
        mealName=nil
        MealNameTextField.text=""
        AddMealImageButton.setBackgroundImage(UIImage.init(systemName: "plus"), for: .normal)
        firstStarButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        secondStarButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        thirdStarButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
    }
}
//When image is uploaded through image picker, set the background image for the image button to render
extension SingleMealCell:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image=info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            AddMealImageButton.setBackgroundImage(image, for: .normal)
            mealImage=image
            delegate?.updateMealImage(image: mealImage!, cell: self)
        }
        picker.dismiss(animated: true, completion: nil)
//        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
