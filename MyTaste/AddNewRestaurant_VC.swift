//
//  AddNewRestaurant_VC.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import Foundation
import UIKit

class AddNewRestaurant_VC: UIViewController {

    @IBOutlet weak var CoverImageButton: UIButton!
    @IBOutlet weak var NameTextField: UITextField!
    let record=UserDefaultManagement.shared.getRecord()
    var embeddedImage:UIImage!
    var alertController:UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        NameTextField.layer.borderWidth=0.5
        NameTextField.autocorrectionType = .no
        NameTextField.returnKeyType = .done
        NameTextField.delegate=self
    }
    @IBAction func addPhotoClicked(){
        //Show the action sheet when photo button clicked
        presentActionSheet()
        self.present(alertController, animated: true, completion: nil)
    }
    // Configuration of the presentAction sheet
    func presentActionSheet(){
        alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoLibraryAction=UIAlertAction(title: "Choose from photo library",style: .default) { (action) in
            //Check if the photo library is available, if so, create the action.If not, create alert
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else{
                let alertController=UIAlertController(title: "", message: "Please allow access to the photo library", preferredStyle:  .alert)
                let alertAction=UIAlertAction(title: "OK", style:  .cancel)
                    alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let vc=UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing=true
            self.present(vc, animated: true, completion: nil)
        }
        let cameraAction=UIAlertAction(title: "Take a photo", style: .default) { (action) in
            //Check if the camera is available, if so, create the action.If not, create alert
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else{
            let alertController=UIAlertController(title: "", message: "Please allow access to the camera", preferredStyle:  .alert)
            let alertAction=UIAlertAction(title: "OK", style:  .cancel)
                alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
            let vc=UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.allowsEditing=true
            self.present(vc, animated: true, completion: nil)
        }
        let cancelAction=UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
    }
    @IBAction func doneButtonClicked(){
        //Check if the user have all the required information when click on done button
        guard NameTextField.text != "",CoverImageButton.currentBackgroundImage != UIImage(systemName: "plus") else{
            let alertController=UIAlertController(title: "", message: "Please upload a image and put in a name", preferredStyle:  .alert)
            let alertAction=UIAlertAction(title: "OK", style:  .cancel)
                alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        //Store the record of restaurant info to UDM
        let newRecord=recordInfo(record, NameTextField.text!, embeddedImage)
        let recordInfo=try! PropertyListEncoder().encode(newRecord)
        UserDefaultManagement.shared.defaults.set(recordInfo, forKey: "record")
        NotificationCenter.default.post(name: Notification.Name("addNewRestaurant"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    //Update the record array
    func recordInfo(_ record:Array<RestaurantInfo>,_ restaurantName:String,_ coverImage:UIImage)->Array<RestaurantInfo>{
        var newRecord=record
        newRecord.append(RestaurantInfo(coverImage: coverImage, name: restaurantName))
        return newRecord
    }
}
//Configure the image picker setting
extension AddNewRestaurant_VC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image=info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            CoverImageButton.setBackgroundImage(image, for: .normal)
            embeddedImage=image
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension AddNewRestaurant_VC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
    }
}


