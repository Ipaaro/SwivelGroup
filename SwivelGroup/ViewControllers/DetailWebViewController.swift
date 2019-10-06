//
//  DetailWebViewController.swift
//  SwivelGroup
//
//  Created by Malsha Parani on 10/4/19.
//  Copyright © 2019 Malsha Parani. All rights reserved.
//

import UIKit
import WebKit

class DetailWebViewController:  UIViewController,WKNavigationDelegate {
    
        var selectedNews = NewsItem()
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newsUrl = selectedNews.url!
        // 1
        let url = URL(string: newsUrl)!
        webView.load(URLRequest(url: url))
        
        // 2
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = selectedNews.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
