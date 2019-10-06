//
//  DatabaseFunctions.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/5/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import Foundation
import RealmSwift
import CRNotifications

// Save user detail method to local database
func userDetailDBSave (selectedUser : UserObject ) {
    let userObject = userDetail()
    let realm = try! Realm()
    let previousNews = realm.objects(userDetail.self).filter("userName = %@", selectedUser.userName!)
    
    if(previousNews.count > 0){
        
        try! realm.write {
            
            previousNews.first?.userName = selectedUser.userName!
            previousNews.first?.password = selectedUser.password!
            previousNews.first?.email = selectedUser.email!
            previousNews.first?.mobileNo = selectedUser.mobileNo!
        }
    }else{
        
        userObject.userName = selectedUser.userName!
        userObject.password = selectedUser.password!
        userObject.email = selectedUser.email!
        userObject.mobileNo = selectedUser.mobileNo!
        
        try! realm.write {
            realm.add(userObject)
            CRNotifications.showNotification(type:CRNotifications.success, title: Message.Title.rawValue , message: Message.savedSuccess.rawValue, dismissDelay: 5)
            
        }
    }
}
