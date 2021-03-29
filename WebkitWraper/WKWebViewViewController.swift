//
//  WKWebViewViewController.swift
//  WebkitWraper
//
//

import UIKit
import WebKit

class WKWebViewViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    var urlString:String = ""
    @IBOutlet private weak var contentView: UIView!
    var wkWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WKWebView"

        let configuration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: CGRect.zero, configuration: configuration)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.navigationDelegate = self
        contentView.addSubview(wkWebView)

        [wkWebView.topAnchor.constraint(equalTo: contentView.topAnchor),
         wkWebView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         wkWebView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
         wkWebView.rightAnchor.constraint(equalTo: contentView.rightAnchor)].forEach  { anchor in
            anchor.isActive = true
        }

        let myURL = NSURL(string: urlString)
        let request = NSURLRequest(url: myURL! as URL)
        wkWebView.load(request as URLRequest)

    }

    func updateWithUrlString(url:String) {
        urlString = url

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidStartLoad(_ webView: WKWebView) {

    }

    func webViewDidFinishLoad(_ webView: WKWebView) {


    }


    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView content loaded.")
    }

    func webView(_ webView: WKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        return true
    }

    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        print(error)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        if wkWebView.canGoForward {
            wkWebView.goForward()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
