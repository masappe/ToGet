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
        let date = Date(timeInterval: 24*60*60, since: created)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date) - 9
        let minute = calendar.component(.minute, from: date)
        let dateArray = [year,month,day,hour,minute]
        for i in dateArray{
            tomorrow.append(i)
        }
    }
    //一週間後の値の取得
    //テストで正解したらデータを作成
    func afterOneWeek(){
        let date = Date(timeInterval: 7*24*60*60, since: created)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date) - 9
        let minute = calendar.component(.minute, from: date)
        let dateArray = [year,month,day,hour,minute]
        for i in dateArray{
            afterWeek.append(i)
        }
    }
    //一ヶ月後の値の取得
    //テストで正解したらデータを作成
    func afterOneMonth(){
        let calendar = Calendar.current
        let year = calendar.component(.year, from: created)
        var month = calendar.component(.month, from: created) + 1
        if month == 12{
            month = 1
        }
        let day = calendar.component(.day, from: created)
        let hour = calendar.component(.hour, from: created) - 9
        let minute = calendar.component(.minute, from: created)
        let dateArray = [year,month,day,hour,minute]
        for i in dateArray{
            afterMonth.append(i)
        }

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

