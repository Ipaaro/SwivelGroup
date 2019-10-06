//
//  WebCommunicator.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebCommunicator: NSObject {
    
    var delegate: ServiceRequestorDelegate?
    
    // WEBSERVICES WITH PARAMETERS - RETURN JSON
    func composeRequestWithParameters(dataArray:[Any] , serviceType:String)-> Void{
        
        let parameters = WebHelper.parametersForService(serviceName: serviceType, dataArray: dataArray)
        let url = ServerURL.baseUrl.rawValue  + serviceType
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            if let error = response.result.error {
                if error._code == NSURLErrorTimedOut {
                    self.handleTimeOut(service: serviceType )
                }
            }
            
            if let value = response.result.value {
                
                let json = JSON(value)
                
                self.handleSuccess(responseObject: json,  service: serviceType as NSString)
                
            }else{
                self.handleError(service: serviceType )
            }
        }
    }
    
    // WEBSERVICES SUCCESS RESPONSE
    func handleSuccess(responseObject:JSON, service:NSString) -> Void{
        
        delegate?.handleResponseData(status: "success", result: responseObject, serviceType:service as String )
        
    }
    // WEBSERVICES ERROR RESPONSE
    func handleError(service:String) -> Void{
        
        delegate?.handleResponseData(status: "error", result:JSON.null, serviceType:service as String)
        
    }
    // WEBSERVICES TIMEOUT RESPONSE
    func handleTimeOut(service:String) -> Void{
        
        delegate?.handleResponseData(status: "timeOut", result:JSON.null, serviceType:service as String)
        
    }
}
