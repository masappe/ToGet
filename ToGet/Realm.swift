//
//  Realm.swift
//  ToGet
//
//  Created by Masato Hayakawa on 2019/02/26.
//  Copyright © 2019 masappe. All rights reserved.
//

import Foundation
import RealmSwift

//testのデータを格納
class TestData:Object{
    @objc dynamic var first:String = ""
    let testArray = List<RememberWord>()
    
//    static let shared = testData()
}

class NotRememberWord:Object{
    @objc dynamic var word: String = ""
    @objc dynamic var wordMean: String = ""
    //日本時間に変更
    @objc dynamic var created = Date()
}

class RememberWord: Object {
    @objc dynamic var word: String = ""
    @objc dynamic var wordMean: String = ""
    @objc dynamic var created = Date()
    //状態
    @objc dynamic var dateStatus = "init"
    //一度のみデータを入れる
    @objc dynamic var isDayFinish:Bool = false
    @objc dynamic var isWeekFinish:Bool = false
    @objc dynamic var isMonthFinish:Bool = false

    //realmでは配列は使えない
    let tomorrow = List<Int>()
    let afterWeek = List<Int>()
    let afterMonth = List<Int>()
    //１日後の値の取得
    //覚えたにした時にデータを作成
    //let comps = DateComponents(day: 1)
    func afterOneDay(){
        created = Date()

        let calendar = Calendar.current
        let comps = DateComponents(second: 30)
        let nextDay = calendar.date(byAdding: comps, to: created)
        let year = calendar.component(.year, from: nextDay!)
        let month = calendar.component(.month, from: nextDay!)
        let day = calendar.component(.day, from: nextDay!)
        let hour = calendar.component(.hour, from: nextDay!)
        let minute = calendar.component(.minute, from: nextDay!)
        let second = calendar.component(.second, from: nextDay!)
        let dateArray = [year,month,day,hour,minute,second]
        for i in dateArray{
            tomorrow.append(i)
        }
        dateStatus = "day"
    }
    //let comps = DateComponents(day: 1)
    func isAfterOneDay() -> Bool{
        let calendar = Calendar.current
        let comps = DateComponents(second: 30)
        let afterOneDay = calendar.date(byAdding: comps, to: created)
        let today = Date()
        if afterOneDay! <= today{
            if !isDayFinish{
                return true
            }
        }
        return false
    }

    //一週間後の値の取得
    //テストで正解したらデータを作成
//    let comps = DateComponents(day: 7)
    func afterOneWeek(){
        let calendar = Calendar.current
        let comps = DateComponents(second: 60)
        let afterOneWeek = calendar.date(byAdding: comps, to: created)
        let year = calendar.component(.year, from: afterOneWeek!)
        let month = calendar.component(.month, from: afterOneWeek!)
        let day = calendar.component(.day, from: afterOneWeek!)
        let hour = calendar.component(.hour, from: afterOneWeek!)
        let minute = calendar.component(.minute, from: afterOneWeek!)
        let second = calendar.component(.second, from: afterOneWeek!)
        let dateArray = [year,month,day,hour,minute,second]
        for i in dateArray{
            afterWeek.append(i)
        }
        dateStatus = "week"
    }
//    let comps = DateComponents(day: 7)
    func isAfterOneWeek() -> Bool{
        let calendar = Calendar.current
        let comps = DateComponents(second: 60)
        let afterOneWeek = calendar.date(byAdding: comps, to: created)
        let today = Date()
        if afterOneWeek! <= today{
            if !isWeekFinish{
                return true
            }
        }
        return false
    }
    
    //一ヶ月後の値の取得
    //テストで正解したらデータを作成
//        let comps = DateComponents(month: 1)
    func afterOneMonth(){
        let calendar = Calendar.current
        let comps = DateComponents(second: 90)
        let afterOneMonth = calendar.date(byAdding: comps, to: created)
        let year = calendar.component(.year, from: afterOneMonth!)
        let month = calendar.component(.month, from: afterOneMonth!)
        let day = calendar.component(.day, from: afterOneMonth!)
        let hour = calendar.component(.hour, from: afterOneMonth!)
        let minute = calendar.component(.minute, from: afterOneMonth!)
        let second = calendar.component(.second, from: afterOneMonth!)
        let dateArray = [year,month,day,hour,minute,second]
        for i in dateArray{
            afterMonth.append(i)
        }
        dateStatus = "month"
    }
//    let comps = DateComponents(month: 1)
    func isAfterOneMonth() -> Bool{
        let calendar = Calendar.current
        let comps = DateComponents(second: 90)
        let afterOneMonth = calendar.date(byAdding: comps, to: created)
        let today = Date()
        if afterOneMonth! <= today{
            if !isMonthFinish{
                return true
            }
        }
        return false
    }

}

class EndWord: Object {
    @objc dynamic var word: String = ""
    @objc dynamic var wordMean: String = ""
    @objc dynamic var created = Date()
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
