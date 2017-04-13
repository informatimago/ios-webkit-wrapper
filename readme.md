# WebKit Wrapper iOS Application for Qlik Sense

![App Icon](/screenshots/app_icon.png?raw=true "App Icon")

### Introduction

Several Qlik Sense customers use an enterprise mobility management platform, such as MobileIron or AirWatch, to manage their corporate mobile devices. In some cases, these solutions will not work when connecting to the Hub using Safari. The root cause of the issue is a bug in iOS that causes WebSocket traffic to be blocked when trying to connect to Qlik Sense.

This iOS app offers a simple WebKit wrapper that leverages UIWebView and allows customers to circumvent this issue. Additional benefits are the appearance of a native app experience and removal of the address bar for extra screen real estate.

### Problem Description
Websocket traffic issues are not always easy to uncover. In many cases users can still connect to the QMC and the Hub. The real issue occurs when a user tries to open an app. From here it appears that the app is opening, but the users ends up only seeing the Qlik Sense bubbles. 

![Bubbles](/screenshots/Bubbles.png?raw=true "Bubbles")

### Confirming Websocket Issue
There is a great extension on branch that can help identify if Websocket traffic is being blocked. It is called 
[Qlik Sense Websocket Connectivity Tester](http://branch.qlik.com/#!/project/56728f52d1e497241ae69865) and was created by Fredrik Lautrup.

You have a Websocket issue if you see this...
![Bad_Websocket_Test](/screenshots/Bad_Websocket_Test.png?raw=true "Bad_Websocket_Test")

If you see something like this, Websocket traffic is not an issue...
![Good_Websocket_Test](/screenshots/Good_Websocket_Test.png?raw=true "Good_Websocket_Test")


### Features and Functionality

The core setting of this application is the default URL, which is where the application will open to on launch. This can be the Qlik Sense hub, an app home screen, an individual sheet, or a mashup.

![Hub](/screenshots/hub.png?raw=true "Hub")

The button in the top right opens a menu that allows you to go back to the default website or type in your own url, functioning much like an address bar in your browser.

![Navigation](/screenshots/navigation.png?raw=true "Navigation")

Beyond those features the experience is native Qlik Sense.

![Zika](/screenshots/zika.png?raw=true "Zika")

![Market Basket](/screenshots/market_basket.png?raw=true "Market Basket")

### Architecture and Deployment

![Architecture](/screenshots/architecture.png?raw=true "Architecture")

![Deployment Process](/screenshots/deployment_process.png?raw=true "Deployment Process")

### Modifying the Application

Here are some quick pointers on how to use this application yourself.

* **Default URL** => defaultURLString variable in WriteToFileHelper.swift, line 18.
* **Title on the top bar** => title variable in WebViewController.swift, line 40.
* **App name** => Product name in Xcode general settings for the app.
* **Changing icons** => Icons and contents.json in Assets.xcassets/AppIcon.appiconset and Resources folders. Can also be done with a GUI in Xcode.
* **Unsigned certificates** => If you want to use unsigned https certs enter the domain to whitelist in  App Transport Security Settings => Exception domains within Xcode.

### How to Install

There are multiple ways to deploy this mobile app to your iPad/iPhone. Depending on your specific scenario these options may vary. Contact the Bardess Group for additional information bgl@bardess.com.
1.	From a Mac download the source code, connect your iPad/iPhone, and build to that device as a developer. Here are some helpful links:
    * [Deploying to a Device without an Apple Developer Account](http://blog.ionic.io/deploying-to-a-device-without-an-apple-developer-account/)
    * [Launching Your App on Devices](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/LaunchingYourApponDevices/LaunchingYourApponDevices.html)
2.	Create an ipa file for ad hoc distribution. There are also many different ways to achieve this.
    * [Ad Hoc IPA Distribution](https://coderwall.com/p/r5jzzw/creating-an-itunes-ipa-file-for-ad-hoc-distribution-in-30-steps-xcode-for-ios)
