//
//  ServiceRequestorDelegate.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ServiceRequestorDelegate: class {
    
    func handleResponseData(status:String, result:JSON , serviceType:String)
}
