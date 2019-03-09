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

    //アプリ起動時
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //textfield.textviewがキーボードと被らないようにする
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

    //バックグラウンドに移行する
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //　通知設定に必要なクラスをインスタンス化
        var trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        //データを持ってくる
        let realm = try! Realm()
        let rememberWordData = realm.objects(RememberWord.self).sorted(byKeyPath: "created", ascending: false)
        
        for data in rememberWordData{
            //覚えて１日後の設定
            if data.dateStatus == "day"{
                // トリガー設定
                notificationTime.year = data.tomorrow[0]
                notificationTime.month = data.tomorrow[1]
                notificationTime.day = data.tomorrow[2]
                notificationTime.hour = data.tomorrow[3]
                notificationTime.minute = data.tomorrow[4]
                notificationTime.second = 0
                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                // 通知内容の設定
                content.title = "単語チェック"
                content.body = "単語を覚えてから１日が経ちました"
                content.sound = UNNotificationSound.default
                
                // 通知スタイルを指定
                //identifierは通知のon,offの時に必要になる
                let request = UNNotificationRequest(identifier: data.word, content: content, trigger: trigger)
                // 通知をセット
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            //覚えて１週間後の設定
            if data.dateStatus == "week"{
                // トリガー設定
                notificationTime.year = data.afterWeek[0]
                notificationTime.month = data.afterWeek[1]
                notificationTime.day = data.afterWeek[2]
                notificationTime.hour = data.afterWeek[3]
                notificationTime.minute = data.afterWeek[4]
                notificationTime.second = 0
                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                // 通知内容の設定
                content.title = "単語チェック"
                content.body = "単語を覚えてから１週間が経ちました"
                content.sound = UNNotificationSound.default
                
                // 通知スタイルを指定
                //identifierは通知のon,offの時に必要になる
                let request = UNNotificationRequest(identifier: data.word, content: content, trigger: trigger)
                // 通知をセット
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

            }
            //覚えて１ヶ月後の設定
            if data.dateStatus == "month"{
                // トリガー設定
                notificationTime.year = data.afterMonth[0]
                notificationTime.month = data.afterMonth[1]
                notificationTime.day = data.afterMonth[2]
                notificationTime.hour = data.afterMonth[3]
                notificationTime.minute = data.afterMonth[4]
                notificationTime.second = 0
                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                // 通知内容の設定
                content.title = "単語チェック"
                content.body = "単語を覚えてから1ヶ月が経ちました"
                content.sound = UNNotificationSound.default
                
                // 通知スタイルを指定
                //identifierは通知のon,offの時に必要になる
                let request = UNNotificationRequest(identifier: data.word, content: content, trigger: trigger)
                // 通知をセット
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

            }
        }
    }
    
    // バックグラウンドに移動したら
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    //バックグラウンドからフォアグランド
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    //アプリが開いたら
    func applicationDidBecomeActive(_ application: UIApplication) {
        //アプリが開いたらチェックする単語があるかどうかの確認
        let realm = try! Realm()
        let rememberWordData = realm.objects(RememberWord.self).sorted(byKeyPath: "created", ascending: false)

        for data in rememberWordData{
            if data.dateStatus == "day"{
                if data.isAfterOneDay(){
                    testData.shared.testArray.append(data)
                }
            }else if data.dateStatus == "week"{
                if data.isAfterOneWeek(){
                    testData.shared.testArray.append(data)
                }
            }else if data.dateStatus == "month"{
                if data.isAfterOneMonth(){
                    testData.shared.testArray.append(data)
                }
            }
        }
        //重複のない配列を作成
        let orderedSet = NSOrderedSet(array: testData.shared.testArray)
        testData.shared.testArray.removeAll()
        //重複のないtestArrayに変更
        testData.shared.testArray = orderedSet.array as! [RememberWord]

        //tabbarのバッチ
        if testData.shared.testArray.count >= 0{
            if let tabBarController = self.window?.rootViewController as? ViewController {
                tabBarController.tabBar.items![3].badgeValue = String(testData.shared.testArray.count)
            }
        }
    }
    //フォアグランドで通知が呼ばれたら
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        //アプリが開いたらチェックする単語があるかどうかの確認
        let realm = try! Realm()
        let rememberWordData = realm.objects(RememberWord.self).sorted(byKeyPath: "created", ascending: false)
        for data in rememberWordData{
            if data.dateStatus == "day"{
                if data.isAfterOneDay(){
                    testData.shared.testArray.append(data)
                }
            }else if data.dateStatus == "week"{
                if data.isAfterOneWeek(){
                    testData.shared.testArray.append(data)
                }
            }else if data.dateStatus == "month"{
                if data.isAfterOneMonth(){
                    testData.shared.testArray.append(data)
                }
            }

        }
        //重複のない配列を作成
        let orderedSet = NSOrderedSet(array: testData.shared.testArray)
        testData.shared.testArray.removeAll()
        //重複のないtestArrayに変更
        testData.shared.testArray = orderedSet.array as! [RememberWord]

        //tabbarのバッチ
        if testData.shared.testArray.count >= 0{
            if let tabBarController = self.window?.rootViewController as? ViewController {
                tabBarController.tabBar.items![3].badgeValue = String(testData.shared.testArray.count)
            }
        }

        
    }
    
    //アプリ終了時
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

