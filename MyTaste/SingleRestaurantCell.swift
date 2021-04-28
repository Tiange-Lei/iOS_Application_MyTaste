//
//  SingleRestaurantCell.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import UIKit

protocol SingleRestaurantCellDelegate:class{
    func deleteRestaurant(selectedRestaurant:RestaurantInfo,cell:SingleRestaurantCell)
}
class SingleRestaurantCell: UICollectionViewCell {
    weak var delegate:SingleRestaurantCellDelegate?
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var CoverImage: UIImageView!
    var selectedInfo:RestaurantInfo!
    //configurate the restaurant info for the cell
    func setUp(_ info:RestaurantInfo){
        NameLabel.text=info.name
        NameLabel.layer.masksToBounds = true
        NameLabel.layer.cornerRadius=10
        CoverImage.image=UIImage(data: info.coverImage)
        selectedInfo=info
    }
    @IBAction func deleteClicked(){
        //when the delete button in the single restaurant is clicked, delete the item in collection view
        let updatedRecord=UserDefaultManagement.shared.deleteRecord(deletedInfo: selectedInfo)
        let recordInfo=try! PropertyListEncoder().encode(updatedRecord)
        UserDefaultManagement.shared.defaults.set(recordInfo, forKey: "record")
        delegate?.deleteRestaurant(selectedRestaurant: selectedInfo, cell: self)
    }
}
