//
//  AppDelegate.swift
//  MoodNews
//
//  Created by Steven Lin on 2020/6/2.
//  Copyright © 2020 xiaoping. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

         return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
       guard let fun = FunVCSingleton else{
           return
       }
       fun.stopBackGroundUrlCheck()
       fun.stopProgFetch()

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       
        if let lastPresentUrl = MainWebView?.url{
            PresentingURL = lastPresentUrl
        }
        AppDuringUsage = false

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        AppDuringUsage = true

 
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        if DidReceiveMemoryWarningBackground && PresentingURL != nil{
            MainWebView?.load(URLRequest(url: PresentingURL!))
            print("Trig WebView reload due to MemoryWarning")
            DidReceiveMemoryWarningBackground = false
        }
        guard let fun = FunVCSingleton else{
            return
        }
        fun.startBackgroundUrlCheck()
        fun.startProgFetch()
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("didReciveMemoryWarning, AppDuringUsage = ",AppDuringUsage)
        if !AppDuringUsage{DidReceiveMemoryWarningBackground = true}
    }
}

