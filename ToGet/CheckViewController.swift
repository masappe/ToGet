//
//  CheckViewController.swift
//  ToGet
//
//  Created by Masato Hayakawa on 2019/03/09.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

class CheckViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var checkDateLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet var checkButton: UIButton!
    let testData = try! Realm().objects(TestData.self)

    var tabViewDelegate: TabViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isEditable = false
        //ボタンの設定
        checkButton.layer.borderWidth = 1
        checkButton.layer.borderColor = UIColor.blue.cgColor
        checkButton.tintColor = .blue
        checkButton.backgroundColor = .white
        checkButton.layer.cornerRadius = 15
        if testData[0].testArray.count == 0{
            wordLabel.text = "確認終了"
            textView.text = "現在確認すべき単語はありません"
        }else{
            let last = testData[0].testArray.count - 1
            checkDateLabel.backgroundColor = .white
            switch testData[0].testArray[last].dateStatus{
            case "day":
                checkDateLabel.text = "覚えてから１日経過"
            case "week":
                checkDateLabel.text = "覚えてから１週間経過"
            case "month":
                checkDateLabel.text = "覚えてから１ヶ月経過"
            default: break
                
            }
            wordLabel.text = testData[0].testArray[last].word
            textView.text = testData[0].testArray[last].wordMean
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.tabViewDelegate.reloadTabBar()
        })
    }
    @IBAction func checkButton(_ sender: Any) {
        if testData[0].testArray.count == 0{
            dismiss(animated: true, completion: {
                self.tabViewDelegate.reloadTabBar()
            })
        }else{
            //チャック日付の更新
            let realm = try! Realm()
            //filterで変数を使うときは%@を用いる
            let data = realm.objects(RememberWord.self).filter("created == %@",testData[0].testArray[0].created)
            
            if data[0].dateStatus == "day"{
                //realmを変更するときはwriteの中で変更する
                try! realm.write {
                    data[0].afterOneWeek()
                    testData[0].testArray.remove(at: 0)
                }
            }else if data[0].dateStatus == "week"{
                try! realm.write {
                    data[0].afterOneMonth()
                    testData[0].testArray.remove(at: 0)
                }
            }else if data[0].dateStatus == "month"{
                let endWordData: EndWord = EndWord()
                endWordData.word = data[0].word
                endWordData.wordMean = data[0].wordMean
                let deleteData = data[0]
                try! realm.write {
                    realm.add(endWordData)
                    realm.delete(deleteData)
                }
            }
            
            
            if testData[0].testArray.count > 0 {
                let last = testData[0].testArray.count - 1
                checkDateLabel.backgroundColor = .white
                switch testData[0].testArray[last].dateStatus{
                case "day":
                    checkDateLabel.text = "覚えてから１日経過"
                case "week":
                    checkDateLabel.text = "覚えてから１週間経過"
                case "month":
                    checkDateLabel.text = "覚えてから１ヶ月経過"
                default: break
                    
                }
                wordLabel.text = testData[0].testArray[last].word
                textView.text = testData[0].testArray[last].wordMean
            }else{
                wordLabel.text = "確認終了"
                textView.text = "現在確認すべき単語はありません"
            }
        }
    }
    

}
