//
//  AppDelegate.swift
//  musicPlayerDemo
//
//  Created by 林祐辰 on 2020/11/25.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookCore 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = .label
        // 設置/初始化Firebase
        FirebaseApp.configure()
        /*
         設置/初始化GoogleSignIn
         這裏的寫法時是在設定GoogleSignIn的初始化的ID (白話就是GoogleSignIn依照個別App設專屬 ID)
         Firebase是Google的, 在Firebase 的 options中也有 clientID
         且你在註冊Firebase 服務時也要註冊此App
         所以這裡也可以使用 跟GoogleService Plist的 clientID
        */
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        // 設置/初始化Facebook登入功能
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    
    // 因為apple 串接登入的方式是要處理URLScheme , 也就是來回切換 App的動作 會處理兩種型態的url
    // application(_:open_options:)方法會來處理
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
   
        var handled:Bool = true
        // Google用GIDSignIn的handleURL方法來登入
        // handleURL方法會處理最後驗證程序所接收的URL
        
        if url.absoluteString.contains("google"){
            handled = GIDSignIn.sharedInstance().handle(url)
        }else if url.absoluteString.contains("fb"){
        // Facebook用ApplicationDelegate的application方法處理facebook登入資訊
        handled =  ApplicationDelegate.shared.application( app, open: url, options: options)
        }
        return handled
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


