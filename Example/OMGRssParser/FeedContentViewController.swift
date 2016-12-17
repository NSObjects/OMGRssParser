//
//  FeedContentViewController.swift
//  OMGRssParser
//
//  Created by 林涛 on 2016/12/17.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class FeedContentViewController: UIViewController {

    var content:String?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let content = content else {
            return
        }
        webView.loadHTMLString(content, baseURL: nil)
        
    }
}
