//
//  Realm.swift
//  ToGet
//
//  Created by Masato Hayakawa on 2019/02/26.
//  Copyright © 2019 masappe. All rights reserved.
//

import Foundation
import RealmSwift

class NotRememberWord:Object{
    @objc dynamic var word: String = ""
    @objc dynamic var wordMean: String = ""
    //日本時間に変更
    @objc dynamic var created = Date(timeIntervalSinceNow: 9*60*60)
}

class RememberWord: Object {
    @objc dynamic var word: String = ""
    @objc dynamic var wordMean: String = ""
    @objc dynamic var created = Date(timeIntervalSinceNow: 9*60*60)
    //realmでは配列は使えない
    let tomorrow = List<Int>()
    let afterWeek = List<Int>()
    let afterMonth = List<Int>()
    //状態
    var dateStatus = "init"
    //１日後の値の取得
    //覚えたにした時にデータを作成
    func afterOneDay(){
        let calendar = Calendar.current
        let comps = DateComponents(day: 1)
        let nextDay = calendar.date(byAdding: comps, to: created)
        let year = calendar.component(.year, from: nextDay!)
        let month = calendar.component(.month, from: nextDay!)
        let day = calendar.component(.day, from: nextDay!)
        let hour = calendar.component(.hour, from: nextDay!)
        let minute = calendar.component(.minute, from: nextDay!)
        let dateArray = [year,month,day,hour,minute]
        for i in dateArray{
            tomorrow.append(i)
        }
        dateStatus = "day"
    }
    
    func isAfterOneDay() -> Bool{
        let calendar = Calendar.current
        let comps = DateComponents(day: 1)
        let afterOneDay = calendar.date(byAdding: comps, to: created)
        let today = Date(timeIntervalSinceNow: 9*60*60)
        if afterOneDay! <= today{
            return true
        }
        return false
    }

    //一週間後の値の取得
    //テストで正解したらデータを作成
    func afterOneWeek(){
        let calendar = Calendar.current
        let comps = DateComponents(day: 7)
        let afterOneWeek = calendar.date(byAdding: comps, to: created)
        let year = calendar.component(.year, from: afterOneWeek!)
        let month = calendar.component(.month, from: afterOneWeek!)
        let day = calendar.component(.day, from: afterOneWeek!)
        let hour = calendar.component(.hour, from: afterOneWeek!)
        let minute = calendar.component(.minute, from: afterOneWeek!)
        let dateArray = [year,month,day,hour,minute]
        for i in dateArray{
            afterWeek.append(i)
        }
        dateStatus = "week"
    }
    func isAfterOneWeek() -> Bool{
        let calendar = Calendar.current
        let comps = DateComponents(day: 7)
        let afterOneWeek = calendar.date(byAdding: comps, to: created)
        let today = Date(timeIntervalSinceNow: 9*60*60)
        if afterOneWeek! <= today{
            return true
        }
        return false
    }
    //一ヶ月後の値の取得
    //テストで正解したらデータを作成
    func afterOneMonth(){
        let calendar = Calendar.current
        let comps = DateComponents(month: 1)
        let afterOneMonth = calendar.date(byAdding: comps, to: created)
        let year = calendar.component(.year, from: afterOneMonth!)
        let month = calendar.component(.month, from: afterOneMonth!)
        let day = calendar.component(.day, from: afterOneMonth!)
        let hour = calendar.component(.hour, from: afterOneMonth!)
        let minute = calendar.component(.minute, from: afterOneMonth!)
        let dateArray = [year,month,day,hour,minute]
        for i in dateArray{
            afterMonth.append(i)
        }
        dateStatus = "month"
    }
    func isAfterOneMonth() -> Bool{
        let calendar = Calendar.current
        let comps = DateComponents(month: 1)
        let afterOneMonth = calendar.date(byAdding: comps, to: created)
        let today = Date(timeIntervalSinceNow: 9*60*60)
        if afterOneMonth! <= today{
            return true
        }
        return false
    }

}

class EndWord: Object {
    @objc dynamic var word: String = ""
    @objc dynamic var wordMean: String = ""
    @objc dynamic var created = Date(timeIntervalSinceNow: 9*60*60)
}

//viewcontrollerからwordviewcontrollerに情報を伝達する
class PassData{
    var status = ""
    var indexPath = 0
    var word = ""
    var wordMean = ""

    static let shared = PassData()
    private init(){}
}
//testのデータを格納
class testData{
    var testArray:[RememberWord] = []
    
    static let shared = testData()
    private init(){}
}
