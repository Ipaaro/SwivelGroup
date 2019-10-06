//
//  RealmDataBase.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import UIKit
import RealmSwift

//User Database Object
class userDetail: Object {
    
    @objc dynamic var userName = ""
    @objc dynamic var password = ""
    @objc dynamic var email = ""
    @objc dynamic var mobileNo = ""
}
