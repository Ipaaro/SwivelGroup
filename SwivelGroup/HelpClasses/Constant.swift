//
//  Constant.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import WebKit
import Material

class newstableViewCell : UITableViewCell  {
    
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var lblNewsTitle: UILabel!
   
}

//Base URLs
enum ServerURL : String {
    case baseUrl = "https://newsapi.org/v2/"
}

//Service URLS
enum ServiceURL : String {
    case Service_Search = "everything"
    case Service_NewsList = "top-headlines"
}

//Keys
enum AccessKeys : String{
    case newsKey = "07a887362b12428d9a463d841a59a313"
}

//Keys
enum CountryList : String{
    case us = "us"
}

//News Object
struct NewsItem {
    var author : String?
    var title : String?
    var description: String?
    var url : String?
    var imageUrl : String?
    var publishDate : String?
    var content : String?
    var sourceId : String?
    var sourceName : String?
//    init(author : String, title : String, description : String, url : String, imageUrl : String, publishDate : String, content : String, sourceId : String, sourceName : String ) {
//        self.author = author
//        self.title = title
//        self.description = description
//        self.url = url
//        self.imageUrl = imageUrl
//        self.publishDate = publishDate
//        self.content = content
//        self.sourceId = sourceId
//        self.sourceName = sourceName
//    }
    
}

//User Object
struct UserObject {
    var userName : String?
    var password : String?
    var email : String?
    var artWorkURL : String?
    var price : String?
    var mobileNo : String?
    
   
}

//Message List
enum Message : String{
    case Title = "Alert"
    case EmptyFields = "Field Can't be empty"
    case ServerError = "Server call error. Please try again."
    case ValidEmail = "Please enter valid email"
    case ValidMobile = "Please enter valid mobile no"
    case loadingTitle = "Loading..."
    case filterTitle = "Filtered - "
    case savedSuccess = "Successfully saved"
    case passwordMatch = "Password mismatch"
}


enum FilterTypes : String {
    case bitcoin = "bitcoin"
    case apple = "apple"
    case earthquake = "earthquake"
    case animal = "animal"
}

//ViewCOntroller Extension
extension UIViewController {
    func showIndicator(withTitle title: String, and Description:String) {
        let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        Indicator.label.text = title
        Indicator.contentColor = .darkText
        Indicator.isUserInteractionEnabled = false
        Indicator.backgroundView.blurEffectStyle = .extraLight
        Indicator.bezelView.backgroundColor = .white
        
        self.view.isUserInteractionEnabled = false
        Indicator.show(animated: true)
    }
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
}

//TextField Extension
extension UITextField
{
    
    //MARK: -  VALIDATION METHODS
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    func isValidPhoneNumber() -> Bool {
        let PHONE_REGEX = "[0-9]{7,13}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self.text)
        
        return result
        
    }
}

//Webview Extension
extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}

// MARK: - TextField Innitiate
func prepareTextFields(textField: TextField ){
    
    let textColor = #colorLiteral(red: 0.1411764706, green: 0.2431372549, blue: 0.5607843137, alpha: 1)
    let textColorPlaceholder = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    textField.layer.borderColor = UIColor.clear.cgColor
    textField.textColor = textColor
    textField.font = .boldSystemFont(ofSize: 14)
    textField.layer.borderWidth=1.0;
    textField.textAlignment = .center
    textField.clearButtonMode = .always
    textField.placeholderActiveColor = textColorPlaceholder
    textField.placeholderNormalColor = textColorPlaceholder
    textField.dividerActiveColor = textColor
    textField.dividerNormalColor = textColor
    
    
}

