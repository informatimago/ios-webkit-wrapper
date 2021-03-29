//
//  WebViewViewController.swift
//  WebkitWraper
//
//

import UIKit
import MessageUI
import SafariServices
import WebKit

class WebViewViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate, NSURLConnectionDelegate, URLSessionDelegate, UITextFieldDelegate, WKUIDelegate {
    var authRequest : URLRequest? = nil
    var authenticated = false
    var failedRequest : URLRequest? = nil

    @IBOutlet weak var bottomGuide: NSLayoutConstraint!
    var urlSession:URLSession!
    var urlSessionConfig:URLSessionConfiguration!

    @IBOutlet weak var webView: WKWebView!
    var urlString:String = ""
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    var timer : Timer? = nil

    var connection:URLSession!

    override func viewDidLoad() {
        super.viewDidLoad()

        WriteToFileHelper.redirectConsoleLogToDocumentFolder()

        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.extendedLayoutIncludesOpaqueBars = false;
//        self.automaticallyAdjustsScrollViewInsets = false;
//        self.contentInsetAdjustmentBehavior =
        definesPresentationContext = true

        title = "SBDE Mobile Web App"
        backButton.setTitle("<", for: UIControl.State.normal)

        loadURL()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(WebViewViewController.addButtonClicked))
    }

    func functionThatYouWantTriggeredOnRotation() {

    }

    @objc func addButtonClicked(_ sender: UIButton){

        let alertController = UIAlertController(title: "Update URL", message: "", preferredStyle: .alert)

        let sentEmailAction = UIAlertAction(title: "Sent Email", style: .default, handler: {
            alert -> Void in

            self.sendToMail()
        })

        let goToDetaultUrl = UIAlertAction(title: "Load Default Website", style: .default,  handler: {(action : UIAlertAction) -> Void in
            self.urlString = defaultURLString
            WriteToFileHelper.saveURL(url: self.urlString)
            self.loadURL()
        })


        let loadUrlAction = UIAlertAction(title: "Load URL", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            let textField = alertController.textFields![0] as UITextField
            print("url = " + textField.text!)
            if self.validateUrl(urlString: textField.text!)  {
                self.urlString = (textField.text)!
                WriteToFileHelper.saveURL(url: self.urlString)
                self.loadURL()
            } else {
                self.showErrorMessage(title: "Error", message: "Invalid url")
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in

        })

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter url Here"
            textField.text = self.urlString
            textField.delegate = self
            textField.returnKeyType = .go
        }

        alertController.addAction(sentEmailAction)
        alertController.addAction(goToDetaultUrl)
        alertController.addAction(loadUrlAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.validateUrl(urlString: textField.text!) == true {
            urlString = textField.text!
            loadURL()
        } else {
            self.showErrorMessage(title: "Error", message: "Invalid url")
        }
        return true
    }

    func loadURL() {
        if let savedUrl =  WriteToFileHelper.loadUrl() {
            urlString = savedUrl
        } else
        {
            urlString = defaultURLString
        }

        let url = URL(string: urlString)

        print("trying to load:  \(urlString)")
        WriteToFileHelper.writeToFile(text: "trying to load:  " + urlString)
        let requestObj = NSURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval:30.0)
        let conn = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        conn.downloadTask(with: requestObj as URLRequest)
        webView.uiDelegate = self
        webView.load(requestObj as URLRequest)
    }

    func connection(_ connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool
    {
        return (protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func sendToMail(){
        //Check to see the device can send email.
        if MFMailComposeViewController.canSendMail() && !Platform.isSimulator{
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ben@sbde.fr"])
            mail.setMessageBody("<p>Console Output</p>", isHTML: true)
            mail.setSubject("Web Wrapper Output")

            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
            let documentsDirectory: NSString = paths[0] as! NSString
            let logPath: String = documentsDirectory.appendingPathComponent("Console.log") as String

                do {
                    let url = URL(fileURLWithPath: logPath)
                    let fileData = try Data(contentsOf: url, options: .mappedIfSafe);
                    print("File data loaded.")
                    mail.addAttachmentData(fileData as Data, mimeType: "text/plain", fileName: "Console.log")
                } catch let error {
                    print(error.localizedDescription)
                }

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    func updateWithUrlString(url:String) {
        urlString = url

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func webViewDidStartLoad(_ webView: WKWebView) {
        WriteToFileHelper.writeToFile(text: "webViewDidStartLoad  ")
        if timer?.isValid == true {
            timer?.invalidate()
        }
    }

    private func scalesPageToFit(_ webView: WKWebView){
        let javaScript = """
            var meta = document.createElement('meta');
                        meta.setAttribute('name', 'viewport');
                        meta.setAttribute('content', 'width=device-width');
                        document.getElementsByTagName('head')[0].appendChild(meta);
            """

        webView.evaluateJavaScript(javaScript)
    }
    private func webViewDidFinishLoad(_ webView: WKWebView) {
        webView.autoresizesSubviews = true
        scalesPageToFit(webView)
        webView.contentMode = .scaleAspectFit

        if webView.url?.absoluteString.range(of:"/app/") != nil {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(WebViewViewController.forceRedrawWebviewContent), userInfo: nil, repeats: true)
        }
    }

    // MARK - DELEGATE METHODS WEBVIEW
    private func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        print("Webview fail with error \(error)");
        WriteToFileHelper.writeToFile(text: "Webview fail with error" + "  " + error.localizedDescription)
        self.showErrorMessage(title: "Error", message: error.localizedDescription)
    }

    private func webView(_ webView: WKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        let message = "Webview shouldStartLoadWithRequest"
        print(request.url?.absoluteString ?? "no request")
        scalesPageToFit(webView)
        WriteToFileHelper.writeToFile(text: message)
        self.connection = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        self.connection.downloadTask(with: request)
        return true;
    }

    // MARK - NSURLConnectionDelegate methods
    func connection(_ connection: NSURLConnection, willSendRequestFor challenge: URLAuthenticationChallenge) {
        let trust:SecTrust = challenge.protectionSpace.serverTrust!;
        let cred:URLCredential = URLCredential(trust: trust)
        challenge.sender?.use(cred, for: challenge)
        let log = "willSendRequestFor" + challenge.protectionSpace.serverTrust.debugDescription + cred.debugDescription
        WriteToFileHelper.writeToFile(text: log)
    }

    func connection(_ connection: NSURLConnection, NSURLConnection response:URLResponse){
        let requestObj:NSURLRequest = NSURLRequest(url: URL(string: urlString)!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 20.0)
        self.webView.load(requestObj as URLRequest)
        let log = "connection response" + (requestObj.url?.absoluteString)!
        WriteToFileHelper.writeToFile(text: log)
        self.connection.invalidateAndCancel()
    }

    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        WriteToFileHelper.writeToFile(text: "connection fail with error" + "  " + error.localizedDescription)
    }

    func connectionShouldUseCredentialStorage(_ connection: NSURLConnection) -> Bool {
        WriteToFileHelper.writeToFile(text: "connectionShouldUseCredentialStorage")
        return true
    }

    private func connection(_ connection: NSURLConnection, didReceive response: URLResponse){
        WriteToFileHelper.writeToFile(text: "connection didReceive response")

    }

    private func connection(_ connection: NSURLConnection, didReceive data: Data){
        WriteToFileHelper.writeToFile(text: "connection didReceive data")

    }

     func connection(_ connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int){
        WriteToFileHelper.writeToFile(text: "connection didSendBodyData totalBytesWritten ")

    }

    func connectionDidFinishLoading(_ connection: NSURLConnection){
        WriteToFileHelper.writeToFile(text: "connectionDidFinishLoading")
    }

    @objc func forceRedrawWebviewContent() {
        if webView.url?.absoluteString.range(of:"/app/") != nil {
            webView.sizeToFit()
        }
        webView.setNeedsDisplay(view.bounds)
        webView.setNeedsLayout()
        webView.setNeedsDisplay()
        webView.layoutIfNeeded()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        if webView.canGoBack {
            webView.goForward()
        }
    }
}

extension WebViewViewController {

    func validateUrl (urlString: String) -> Bool {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }

    func showErrorMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action : UIAlertAction!) -> Void in

        })
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension NSURLRequest {
    static func allowsAnyHTTPSCertificate(forHost host: String) -> Bool {
        return true
    }
}
