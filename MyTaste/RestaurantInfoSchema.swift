//
//  RestaurantInfoSchema.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import Foundation
import UIKit
struct RestaurantInfo:Codable{
    var name:String
    var coverImage:Data
    var mealInfoArray:[MealInfo]?
    init(coverImage:UIImage,name:String){
        self.coverImage=coverImage.pngData()!
        self.name=name
    }
}
