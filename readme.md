# WebKit Wrapper iOS Application for Qlik Sense

![App Icon](/screenshots/app_icon.png?raw=true "App Icon")

### Introduction

A number of Qlik Sense customers use an enterprise mobility management platform, such as MobileIron or AirWatch, to manage their corporate mobile devices. In some cases these solutions will not work when connecting to the Hub using Safari. The root cause of the issue is a bug in iOS that causes WebSocket traffic to be blocked when trying to connect to Qlik Sense.

This iOS app offers a simple WebKit wrapper that leverages UIWebView and allows customers to circumvent this issue. An additional benefit is the appearance of a native app experience and removing the address bar for extra screen real estate.

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
