//
//  RootViewController.swift
//  WebkitWraper
//
//

import UIKit
import Foundation
import WebKit


let showInWebviewIdentifier = "showInWebView"
let showInWKWebviewIdentifier = "showInWKWebView"

class RootViewController: UIViewController {


    @IBOutlet weak var openInwebviewBtn: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var openInWKWebviewbtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if Platform.isSimulator {

        } else {
            WriteToFileHelper.redirectConsoleLogToDocumentFolder()
        }
        var userAgent : String = "WebKit"
        WKWebView().evaluateJavaScript("navigator.userAgent") { (result, error) in
            if error == nil {
                userAgent = result as! String
            }
        }

       WriteToFileHelper.writeToFile(text: userAgent)
       if let savedUrl =  WriteToFileHelper.loadUrl() {
            urlTextField.text = savedUrl
        } else
        {
            urlTextField.text = defaultURLString
        }
        openInwebviewBtn.layer.borderColor = UIColor.black.cgColor
        openInwebviewBtn.layer.borderWidth = 0.5

        openInWKWebviewbtn.layer.borderColor = UIColor.black.cgColor
        openInWKWebviewbtn.layer.borderWidth = 0.5

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openInWebviewPressed(_ sender: Any) {
        if (self.urlTextField.text?.count)! <= 5 {
            return
        }
        performSegue(withIdentifier: showInWebviewIdentifier, sender: self)
    }

    @IBAction func openInWKWebViewPressed(_ sender: Any) {
        if (self.urlTextField.text?.count)! <= 5 {
            return
        }
        performSegue(withIdentifier: showInWKWebviewIdentifier, sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        WriteToFileHelper.saveURL(url: urlTextField.text!)
        if segue.identifier == showInWebviewIdentifier {
            let destinationVC = segue.destination as! WebViewViewController
            destinationVC.updateWithUrlString(url: urlTextField.text!)
        }

        if segue.identifier == showInWKWebviewIdentifier {
            let destinationVC = segue.destination as! WKWebViewViewController
               destinationVC.updateWithUrlString(url: urlTextField.text!)
        }
    }


}
