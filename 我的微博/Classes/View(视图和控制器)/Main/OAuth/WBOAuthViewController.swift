//
//  WBOAuthViewController.swift
//  我的微博
//
//  Created by 贺宁博 on 2017/8/13.
//  Copyright © 2017年 贺宁博. All rights reserved.
//

import UIKit
import SVProgressHUD
class WBOAuthViewController: UIViewController {

    private lazy var webView: UIWebView = UIWebView()
        
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        title = "登录新浪微博"
//        导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill), isBack: false)

    }
    @objc func close() {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WBAppKey)&redirect_uri=\(WBRedirect_uri)"
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        webView.delegate = self
        webView.loadRequest(request)
    }

    
    @objc func autoFill() {
//       准备js
        let js = "document.getElementById('userId').value = '17600109323';" + "document.getElementById('passwd').value = 'love5211314';"
//        让webview 执行js
        webView.stringByEvaluatingJavaScript(from: js)
    }

}

extension WBOAuthViewController: UIWebViewDelegate {
//     将要加载请求
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        96d8c7af24d268d407278ec9612332ec
        if request.url?.absoluteString.hasPrefix(WBRedirect_uri) == false {
            return true
 
        }
        
        if request.url?.query?.hasPrefix("code=") == false {
            close()
            return false
        }
       let code = request.url?.query?.substring(from: "code=".endIndex)
        WBHttpManager.shared.loadAccessToken(code: code!) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.show(withStatus: "网络请求失败")
            } else {
                SVProgressHUD.show(withStatus: "登陆成功")
//下一步 做什么 跳转界面 如何跳转？
//  
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: WBUserLoginSuccessNotication), object: nil)
                self.close()
            }
        }
        
        return false
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}
