//
//  AppDelegate.swift
//  ToGet
//
//  Created by Masato Hayakawa on 2019/02/26.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.        //textfield.textviewがキーボードと被らないようにする
         IQKeyboardManager.shared.enable = true
        //Realmのクラス構造を変更したらschemaVersionを変更する
        let config = Realm.Configuration(schemaVersion: 5)
        Realm.Configuration.defaultConfiguration = config
        //通知の許可設定
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge , .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    print("通知許可")
                    
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    
                } else {
                    print("通知拒否")
                }
            })
            
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge ,.sound , .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    // バックグラウンドに移動したら一度呼ばれる
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //　通知設定に必要なクラスをインスタンス化
        var trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        //データを持ってくる
        let realm = try! Realm()
        let rememberWordData = realm.objects(RememberWord.self).sorted(byKeyPath: "created", ascending: false)
        
        for data in rememberWordData{
            //覚えて１日後の設定
            if data.dateStatus == "init"{
                // トリガー設定
                notificationTime.year = data.tomorrow[0]
                notificationTime.month = data.tomorrow[1]
                notificationTime.day = data.tomorrow[2]
                notificationTime.hour = data.tomorrow[3]
                notificationTime.minute = data.tomorrow[4]
                notificationTime.second = 0
                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                // 通知内容の設定
                content.title = "単語テスト"
                content.body = "単語を覚えてから１日が経ちました"
                content.sound = UNNotificationSound.default
                
                // 通知スタイルを指定
                //identifierは通知のon,offの時に必要になる
                let request = UNNotificationRequest(identifier: data.word, content: content, trigger: trigger)
                // 通知をセット
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            //覚えて１週間後の設定
            
            //覚えて１ヶ月後の設定
        }
        
        
        

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

