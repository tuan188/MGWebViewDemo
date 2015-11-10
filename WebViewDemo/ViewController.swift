//
//  ViewController.swift
//  WebViewDemo
//
//  Created by Tuan Truong on 11/10/15.
//  Copyright © 2015 Framgia. All rights reserved.
//

import UIKit

class AppJavascriptDelegate: NSObject, JavascriptObjectDelegate {
    var webView: UIWebView?
    var foos: Dictionary<String, (callback: String, data :String)->() >?
    
    init(wv: UIWebView) {
        super.init()
        
        webView = wv
        foos = [
            "ping": { (callback: String, data: String) in
                self.js_callback_helper(callback, data: "pong")
            },
            "hello": { (callback: String, data: String) in
                let alertView = UIAlertView(title: "Hello", message: "From UIWebView", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            },
        ]
    }
    
    // make sure data(string) contains no ' " ' (quote)
    func js_callback_helper(callback: String, data: String) {
        let exec: String = callback + "(\"" + data + "\")"
        self.webView!.stringByEvaluatingJavaScriptFromString(exec)
    }
    
    func call(action: String, callback: String, data: String) {
        if foos![action] != nil {
            foos![action]! (callback: callback, data: data)
        } else {
            print("Invalid action: " + action);
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var appJavascriptDelegate: AppJavascriptDelegate?
    var webViewDelegate: WebViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: NSURL(string: "https://dl.dropboxusercontent.com/u/7918250/WebViewDemo/test.html")!)
        
        // disable scroll out of edge
        webView.scrollView.bounces = false
        appJavascriptDelegate = AppJavascriptDelegate(wv: webView!)
        webViewDelegate = WebViewDelegate(delegate: appJavascriptDelegate!)
        webView.delegate = webViewDelegate
        
        // load request
        webView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

