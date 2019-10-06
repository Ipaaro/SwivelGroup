//
//  WebHelper.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import UIKit

class WebHelper: NSObject {
    
    //Set parameters for the service calls
    
    static func parametersForService(serviceName: String, dataArray: [Any]) ->  [String: AnyObject] {
   
        var paramDictionary : [String: AnyObject] = [:]
        let crrayCount = dataArray.count
        
        if serviceName  == ServiceURL.Service_NewsList.rawValue{
            
            let paramArray = ["country","apiKey"]
            
            for i in 0..<crrayCount {
                paramDictionary.updateValue(dataArray[i] as AnyObject, forKey: paramArray[i])
                
            }
            return paramDictionary
        }
        
        if serviceName  == ServiceURL.Service_Search.rawValue{
            
            let paramArray = ["q","apiKey"]
            
            for i in 0..<crrayCount {
                paramDictionary.updateValue(dataArray[i] as AnyObject, forKey: paramArray[i])
                
            }
            return paramDictionary
        }
  
        return paramDictionary
    }
    
}
