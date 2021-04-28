//
//  MealInfoSchema.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import Foundation

struct MealInfo:Codable{
    var date:String
    var info:[MealDetail]
}
struct MealDetail:Codable{
    var index:Int
    var mealName:String
    var mealImage:Data?
    var rate:Int?
}
