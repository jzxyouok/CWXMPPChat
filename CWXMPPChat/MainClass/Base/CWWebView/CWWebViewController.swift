//
//  CWWebViewController.swift
//  CWXMPPChat
//
//  Created by chenwei on 16/5/29.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import WebKit

var webViewContentKey = "webViewContentKey"
var webViewBackgroundColorKey = "webViewBackgroundColorKey"

let webView_Items_Fixed_Space:CGFloat =  9

class CWWebViewController: UIViewController {
    
    ///是否使用网页标题作为nav标题，默认YES
    var usepageTitleAsTitle: Bool = true
    
    ///是否显示加载进度，默认YES
    var showLoadingProgress: Bool = true {
        didSet {
            self.progressView.hidden = !showLoadingProgress
        }
    }
    
    ///是否禁止历史记录，默认NO
    var disableBackButton: Bool = false
    
    var urlString: String = "" {
        didSet {
            
        }
    }
    
    private lazy var webView: WKWebView = {
        
//        let source = "document.body.style.background = \"#777\";"
//        let userScript = WKUserScript(source: source, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
//        
//        let userContentController = WKUserContentController()
//        userContentController.addUserScript(userScript)
        
        let configure = WKWebViewConfiguration()
//        configure.userContentController = userContentController
        
        let frame = CGRect(x: 0, y: Screen_NavigationHeight, width: Screen_Width, height: Screen_Height-Screen_NavigationHeight)
        let webView = WKWebView(frame: frame, configuration: configure)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let frame = CGRect(x: 0, y: Screen_NavigationHeight, width: Screen_Width, height: 10)
        let progressView = UIProgressView(frame: frame)
        progressView.progressTintColor = UIColor.chatSystemColor()
        progressView.trackTintColor = UIColor.clearColor()
        return progressView
    }()
    
    private lazy var backButtonItem: UIBarButtonItem = {
        let backButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(navigationBackButtonDown))
        return backButtonItem
    }()
    
    private lazy var closeButtonItem: UIBarButtonItem = {
        let closeButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(navigationCloseButtonDown))
        return closeButtonItem
    }()
    
    private var authLabel: UILabel = {
        let frame = CGRect(x: 20, y: Screen_NavigationHeight+13, width: Screen_Width-2*20, height: 0)
        let authLabel = UILabel(frame: frame)
        authLabel.font = UIFont.systemFontOfSize(12)
        authLabel.textAlignment = .Center
        authLabel.textColor = UIColor(hexString: "#6b6f71")
        authLabel.numberOfLines = 1
        return authLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.defaultBlackColor()
        self.view.addSubview(authLabel)
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
        webView.scrollView.backgroundColor = UIColor.clearColor()
        
        for subView in webView.scrollView.subviews {
            if "\(subView.classForCoder)" == "WKContentView" {
                subView.backgroundColor = UIColor.whiteColor()
            }
        }
        
        let spaceItem = UIBarButtonItem.fixBarItemSpaceWidth(webView_Items_Fixed_Space)
        self.navigationItem.leftBarButtonItems = [spaceItem,backButtonItem]
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: &webViewContentKey)
        webView.scrollView.addObserver(self, forKeyPath: "backgroundColor", options: .New, context: &webViewBackgroundColorKey)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.progressView.progress = 0
        let request = NSURLRequest(URL: NSURL(string: self.urlString)!)
        self.webView.loadRequest(request)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if context == &webViewContentKey && object === self.webView {
            self.progressView.alpha = 1
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if self.webView.estimatedProgress >= 1.0 {
                
                UIView.animateWithDuration(0.3, delay: 0.25, options: .CurveEaseInOut, animations: { 
                    self.progressView.alpha = 0
                    }, completion: { (finished) in
                    self.progressView.setProgress(0, animated: false)
                })
                
            }
        }
        
        else if context == &webViewBackgroundColorKey && object === self.webView.scrollView {
            let color = change!["new"] as! UIColor
            if !CGColorEqualToColor(color.CGColor, UIColor.clearColor().CGColor) {
                self.webView.scrollView.backgroundColor = UIColor.clearColor()
            }
        }
        
    }
    
    
    //MARK: 方法
    ///关闭
    func navigationCloseButtonDown() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func navigationBackButtonDown() {
        
        if self.webView.canGoBack {
            self.webView.goBack()
            let spaceItem = UIBarButtonItem.fixBarItemSpaceWidth(webView_Items_Fixed_Space)
            self.navigationItem.leftBarButtonItems = [backButtonItem,spaceItem,closeButtonItem]
            
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.scrollView.removeObserver(self, forKeyPath: "backgroundColor")
    }
}


extension CWWebViewController: WKNavigationDelegate {
    
    //完成
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        if usepageTitleAsTitle {
            self.title = webView.title
            self.authLabel.text = String(format: "网页由 %@ 提供", (webView.URL?.host) ?? "未知网页")
            let size = self.authLabel.sizeThatFits(CGSize(width: self.authLabel.width, height: CGFloat(MAXFLOAT)))
            self.authLabel.height = size.height
        }
   
        
    }
    
}
