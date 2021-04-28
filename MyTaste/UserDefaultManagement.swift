//
//  UserDefaultManagement.swift
//  MyTaste
//
//  Created by Tiange Lei on 27/1/21.
//

import Foundation

class UserDefaultManagement{
    static let shared=UserDefaultManagement()
    let defaults=UserDefaults(suiteName: "MyTaste")!
    
    func getRecord()->Array<RestaurantInfo>{
        let defaultRecord=[RestaurantInfo]()
        if let fetchedData = UserDefaultManagement.shared.defaults.data(forKey: "record"){
            let fetchedRecord = try! PropertyListDecoder().decode([RestaurantInfo].self, from: fetchedData)
            return fetchedRecord
        }else{
            return defaultRecord
        }
    }
    func deleteRecord(deletedInfo:RestaurantInfo)->Array<RestaurantInfo>{
        var oldRecord=getRecord()
        let index=oldRecord.firstIndex{$0.name == deletedInfo.name && $0.coverImage == deletedInfo.coverImage}
        oldRecord.remove(at: index!)
        return oldRecord
    }
    func clearRecord(){
        defaults.removeObject(forKey: "record")
    }
    func updateRecord(newInfo:RestaurantInfo)->Array<RestaurantInfo>{
        let oldRecord=getRecord()
        var newRecord=oldRecord
        let index=oldRecord.firstIndex{$0.name == newInfo.name }
        newRecord[index!]=newInfo
        return newRecord
    }
    func getCurrentSelectedRestaurantInfo()->RestaurantInfo?{
        if let fetchedData = UserDefaultManagement.shared.defaults.data(forKey: "currentSelected"){
            let fetchedRecord = try! PropertyListDecoder().decode(RestaurantInfo.self, from: fetchedData)
            return fetchedRecord
        }else{
            return nil
        }
    }
}
