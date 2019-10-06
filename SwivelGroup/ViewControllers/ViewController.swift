//
//  ViewController.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import CRNotifications
import RealmSwift
import Material
import DLRadioButton
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITextFieldDelegate, ServiceRequestorDelegate {
  
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var lblFIlter: UILabel!
    @IBOutlet weak var btnChangeFilter: UIButton!
    @IBOutlet weak var viewNewsTable: UIView!
    @IBOutlet weak var tblNewsList: UITableView!
    @IBOutlet weak var txtUserName: TextField!
    @IBOutlet weak var txtPassword: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var txtMobile: TextField!
    @IBOutlet weak var txtConfirmPassword: TextField!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var constrainFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentFilter: UISegmentedControl!
    @IBOutlet var viewFilterSelection: UIView!
    @IBOutlet weak var btnAnimal: DLRadioButton!
    @IBOutlet weak var btnEarthquake: DLRadioButton!
    @IBOutlet weak var btnApple: DLRadioButton!
    @IBOutlet weak var btnbitcoin: DLRadioButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    var communicator : WebCommunicator?
    var newsListArray = [NewsItem]()
    var selectedNews = NewsItem()
    var selectedUser = UserObject()
    var  blurView : UIView!
    let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        communicator = WebCommunicator()
        communicator?.delegate = self
        
        viewSetup()
    }
    
    // MARK: - Device rotation Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ask the system to start notifying when interface change
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //add the observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
    }
    @objc func orientationChanged(notification : NSNotification) {
    
        if(viewFilterSelection.window != nil){
            removeViews()
            showFilterPopup()
        }
    }
    
     // MARK: - View Setup Methods
    //View Setting Detail Method
    func viewSetup(){
        prepareTextFields(textField: txtUserName)
        prepareTextFields(textField: txtMobile)
        prepareTextFields(textField: txtEmail)
        prepareTextFields(textField: txtPassword)
        prepareTextFields(textField: txtConfirmPassword)
        
        loadNewsListSegment()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeAddedAvailableView))
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.addGestureRecognizer(tap)
        blurView.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyBoardViewTap(sender:)))
        
        viewProfile.addGestureRecognizer(tap2)
        
        tblNewsList.rx.itemSelected
            .subscribe(onNext: { [weak self]indexPath in
                self?.selectedNews = (self?.newsListArray[indexPath.row])!
                self?.performSegue(withIdentifier: "toNewsDetailSegue", sender: nil)
            }).disposed(by: disposeBag)
        
    }
    // Remove all open view for touch gesture
    @objc func removeAddedAvailableView(sender : UITapGestureRecognizer){
       removeViews()
    }
    
    //Remove Added View
    func removeViews(){
        if(blurView != nil){
            blurView.removeFromSuperview()
            blurView.isUserInteractionEnabled = true
        }
        
        if(viewFilterSelection.window != nil){
            viewFilterSelection.removeFromSuperview()
        }
    }
    
     // MARK: - Segment Controller Methods
    //Segment Clicked Event
    @IBAction func newsOptionAction(_ sender: Any) {
        
        if(segmentFilter.selectedSegmentIndex == 0){
            loadNewsListSegment()
        }else if (segmentFilter.selectedSegmentIndex == 1){
           loadNewsFilterListSegment()
        }else if (segmentFilter.selectedSegmentIndex == 2){
            loadProfileSegment()
        }
    }
    
    func loadNewsListSegment(){
        loadNewsList(filterType: "")
        self.constrainFilterHeight.constant = 0
        self.viewNewsTable.isHidden = false
        self.viewFilter.isHidden = true
        self.viewProfile.isHidden = true
    }
    
    func loadNewsFilterListSegment(){
        self.constrainFilterHeight.constant = 30
        loadNewsList(filterType: FilterTypes.bitcoin.rawValue)
        self.lblFIlter.text = Message.filterTitle.rawValue + FilterTypes.bitcoin.rawValue
        self.btnbitcoin.isSelected = true
        self.viewFilter.isHidden = false
        self.viewNewsTable.isHidden = false
        self.viewProfile.isHidden = true
    }
    
    func loadProfileSegment(){
        self.constrainFilterHeight.constant = 0
        self.viewProfile.isHidden = false
        self.viewFilter.isHidden = true
        self.viewNewsTable.isHidden = true
    }
    
    // MARK: - Filtered News Event Methods
    //Search button clicked event
    @IBAction func btnFilterClickEvent(_ sender: Any) {
        showFilterPopup()
    }
    
    //Bitcoin Selection Method
    @IBAction func btnBitCoinClicked(_ sender: Any) {
        loadNewsList(filterType: FilterTypes.bitcoin.rawValue)
        self.lblFIlter.text = Message.filterTitle.rawValue + FilterTypes.bitcoin.rawValue
        removeViews()
    }
    //Animal Selection Method
    @IBAction func btnAnimalClicked(_ sender: Any) {
        loadNewsList(filterType:  FilterTypes.animal.rawValue)
        self.lblFIlter.text = Message.filterTitle.rawValue + FilterTypes.animal.rawValue
        removeViews()
    }
    //Earthquake Selection Method
    @IBAction func btnEarthquakeClicked(_ sender: Any) {
        loadNewsList(filterType: FilterTypes.earthquake.rawValue)
        self.lblFIlter.text = Message.filterTitle.rawValue + FilterTypes.earthquake.rawValue
        removeViews()
    }
    //Apple Selection Method
    @IBAction func btnAppleClicked(_ sender: Any) {
        loadNewsList(filterType: FilterTypes.apple.rawValue)
        self.lblFIlter.text = Message.filterTitle.rawValue + FilterTypes.apple.rawValue
        removeViews()
    }
    //Close Filtered Popup
    @IBAction func btnCloseViewClicked(_ sender: Any) {
        removeViews()
    }
    
    // Show Filtered Popup
    func showFilterPopup() {
        
        if(!blurView.isDescendant(of: self.view)) {
            self.view.addSubview(blurView)
            blurView.frame = self.view.bounds
        }
        
        blurView.isUserInteractionEnabled = false
        self.view.addSubview(viewFilterSelection)
        self.blurView.isUserInteractionEnabled = true
        
        viewFilterSelection.frame = CGRect(x: 0, y: 0 , width: viewFilterSelection.bounds.width, height:  viewFilterSelection.bounds.height)
        viewFilterSelection.layer.cornerRadius=5.0
        viewFilterSelection.center = self.view.center
        viewFilterSelection.transform = CGAffineTransform.init(scaleX: 1.3,y: 1.3)
        viewFilterSelection.alpha = 0
        
        UIView.animate (withDuration: 0.4){
            self.viewFilterSelection.alpha = 1
            self.viewFilterSelection.transform = CGAffineTransform.identity
        }
    }
  
    // MARK: - Get News Event Methods
    //News List Get Server Call
    func loadNewsList(filterType: String){

        self.showIndicator(withTitle: Message.loadingTitle.rawValue, and: "")
        if filterType == ""{
        communicator?.composeRequestWithParameters(dataArray: [CountryList.us.rawValue,AccessKeys.newsKey.rawValue], serviceType:ServiceURL.Service_NewsList.rawValue )
        }else{
            communicator?.composeRequestWithParameters(dataArray: [filterType,AccessKeys.newsKey.rawValue], serviceType:ServiceURL.Service_Search.rawValue )
        }
    }
    
    // MARK: - Profile Event Methods
      //Save user details button clicked event
    @IBAction func saveUserDetailsBtnClicked(_ sender: Any) {
        
        hideKeyBoardViewTap()
        
        guard let userName = self.txtUserName.text else {
            return
        }
        guard let password = self.txtPassword.text else {
            return
        }
        guard let confirmPassword = self.txtConfirmPassword.text else {
            return
        }
        if userName.isEmpty {
            CRNotifications.showNotification(type:CRNotifications.error, title: Message.Title.rawValue , message: Message.EmptyFields.rawValue, dismissDelay: 5)
            return
        }else if password.isEmpty {
            CRNotifications.showNotification(type:CRNotifications.error, title: Message.Title.rawValue , message: Message.EmptyFields.rawValue, dismissDelay: 5)
            return
        }
        else if confirmPassword.isEmpty {
            CRNotifications.showNotification(type:CRNotifications.error, title: Message.Title.rawValue , message: Message.EmptyFields.rawValue, dismissDelay: 5)
            return
        }else if confirmPassword != password {
            CRNotifications.showNotification(type:CRNotifications.error, title: Message.Title.rawValue , message: Message.passwordMatch.rawValue, dismissDelay: 5)
            return
        }
        else  if !txtEmail.isValidEmail(){
            CRNotifications.showNotification(type:CRNotifications.error, title: Message.Title.rawValue , message: Message.ValidEmail.rawValue, dismissDelay: 5)
            return
        }else if !txtMobile.isValidPhoneNumber(){
            CRNotifications.showNotification(type:CRNotifications.error, title: Message.Title.rawValue , message: Message.ValidMobile.rawValue, dismissDelay: 5)
            return
           }else{        
                selectedUser.userName = txtUserName.text
                selectedUser.password = txtPassword.text
                selectedUser.email = txtEmail.text
                selectedUser.mobileNo = txtMobile.text
                userDetailDBSave(selectedUser: selectedUser)
                textFeildClear()
            }
    }
    
    //Clear Textfiels
    func textFeildClear(){
        txtUserName.text = ""
        txtPassword.text = ""
        txtConfirmPassword.text = ""
        txtEmail.text = ""
        txtMobile.text = ""
    }
    
    // MARK: - Table Reload Methods
    // Load data to table view
    func loadDataToTable() {
        
        let objeArray : Observable<[NewsItem]> =  Observable.just(newsListArray)
        tblNewsList.dataSource = nil
        objeArray.bind(to: tblNewsList.rx.items(cellIdentifier: "newsCell")) { (row, news, cell) in
            if let cellToUse = cell as? newstableViewCell {

                cellToUse.lblNewsTitle.text = news.title
                
                if news.imageUrl != ""{
                    
                    if news.imageUrl == nil{
                        cellToUse.imgNews.image = #imageLiteral(resourceName: "ImgLoading")
                    }else{
                    
                        let   url : URL = URL(string: news.imageUrl!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
                        cellToUse.imgNews.kf.indicatorType = .activity
                    
                            cellToUse.imgNews.kf.setImage(with: url , completionHandler: {
                                (image, error, cacheType, imageUrl) in
                        
                            })
                    }
                }else{
                    cellToUse.imgNews.image = #imageLiteral(resourceName: "ImgLoading")
                }
            }
            }.disposed(by: disposeBag)
    }
 
    // MARK: - SERVICE DELEGATE METHODS
    func handleResponseData(status: String, result: JSON, serviceType: String) {
        if serviceType as String == ServiceURL.Service_NewsList.rawValue {
            
            self.hideIndicator()
            self.newsListArray.removeAll()
            
            if status == "success" {
                
                let newsData = result["articles"]
                if(newsData !=  JSON.null){
                   for (_,news):(String, JSON) in newsData {
                    
                        let source = news["source"]
                        self.newsListArray.append(NewsItem(author: news["author"].stringValue, title: news["title"].stringValue, description: news["description"].stringValue, url: news["url"].stringValue, imageUrl: news["urlToImage"].stringValue, publishDate: news["publishedAt"].stringValue, content: news["content"].stringValue, sourceId: source["id"].stringValue, sourceName: source["name"].stringValue))
                    }
                    loadDataToTable()
                }
                
            }else{
                CRNotifications.showNotification(type:CRNotifications.info, title: Message.Title.rawValue , message: Message.ServerError.rawValue, dismissDelay: 5)
            }
        }
        if serviceType as String == ServiceURL.Service_Search.rawValue {
            
            self.hideIndicator()
            self.newsListArray.removeAll()
            
            if status == "success" {
                
                let newsData = result["articles"]
                if(newsData !=  JSON.null){
                    for (_,news):(String, JSON) in newsData {
                        
                        let source = news["source"]
                        self.newsListArray.append(NewsItem(author: news["author"].stringValue, title: news["title"].stringValue, description: news["description"].stringValue, url: news["url"].stringValue, imageUrl: news["urlToImage"].stringValue, publishDate: news["publishedAt"].stringValue, content: news["content"].stringValue, sourceId: source["id"].stringValue, sourceName: source["name"].stringValue))
                        
                    }
                    loadDataToTable()                    
                }
            }else{
                CRNotifications.showNotification(type:CRNotifications.info, title: Message.Title.rawValue , message: Message.ServerError.rawValue, dismissDelay: 5)
            }
        }
    }
    
    // MARK: - KEYBOARD HIDE METHODS
    @objc func hideKeyBoardViewTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    // MARK: - NAVIGATION METHODS    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewsDetailSegue" {
            let TargetVC = segue.destination as! DetailNewsViewController
            TargetVC.selectedNews = self.selectedNews
            
        }
    }
    
    // MARK: - TEXT FIELD DELEGATION METHODS
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if(textField == txtMobile ) {
            let invalidCharacters = CharacterSet(charactersIn: "0123456789 ").inverted
            return string.rangeOfCharacter(from: invalidCharacters) == nil
        }
        
        return false
    }
}
