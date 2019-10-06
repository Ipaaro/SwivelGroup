//
//  DetailNewsViewController.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {
    
    @IBOutlet weak var imgNews: UIImageView!
    
    @IBOutlet weak var lblPublisher: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tvContent: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    var selectedNews = NewsItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayNewsData()
        // Do any additional setup after loading the view.
    }
    
    //Display News Details
    func displayNewsData(){
        
        self.lblTitle.text = selectedNews.title
        self.tvDescription.text = selectedNews.description
        self.tvContent.text = selectedNews.content
        self.lblPublisher.text = selectedNews.author
        self.lblDate.text = selectedNews.publishDate
        self.btnLink.setTitle(selectedNews.url, for: .normal)
        tvDescription.sizeToFit()
        tvContent.sizeToFit()
        
        if selectedNews.imageUrl != ""{
            if selectedNews.imageUrl == nil{
                imgNews.image = #imageLiteral(resourceName: "ImgLoading")
            }else{
                let   url : URL = URL(string: selectedNews.imageUrl!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
                
                imgNews.kf.indicatorType = .activity                
                
                imgNews.kf.setImage(with: url , completionHandler: {
                    (image, error, cacheType, imageUrl) in
                })
            }
        }else{
            imgNews.image = #imageLiteral(resourceName: "ImgLoading")
        }
    }
    
    // MARK: - Button Clicked Event
    @IBAction func btnSourceClicked(_ sender: Any) {
        
         self.performSegue(withIdentifier: "toDetailWebSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailWebSegue" {
            let TargetVC = segue.destination as! DetailWebViewController
            TargetVC.selectedNews = self.selectedNews
        }
    }
}
