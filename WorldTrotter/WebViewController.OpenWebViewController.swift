//
//  WebViewController.OpenWebViewController.swift
//  WorldTrotter
//
//  Created by Jayden Olsen on 2/7/17.
//  Copyright © 2017 Jayden Olsen. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
