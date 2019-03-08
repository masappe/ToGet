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
    @objc dynamic var created = Date()
}

class RememberWord: Object {
    @objc dynamic var word: String = ""
    @objc dynamic var wordMean: String = ""
    @objc dynamic var created = Date()
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
