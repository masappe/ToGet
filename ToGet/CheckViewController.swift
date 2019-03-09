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

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var tabViewDelegate: TabViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        if testData.shared.testArray.count == 0{
            wordLabel.text = "確認するものはありません"
        }else{
            wordLabel.text = testData.shared.testArray[0].word
            textLabel.text = testData.shared.testArray[0].wordMean
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.tabViewDelegate.reloadTabBar()
        })
    }
    @IBAction func checkButton(_ sender: Any) {
        if testData.shared.testArray.count == 0{
            wordLabel.text = "確認終了"
        }else{
            //チャック日付の更新
            let realm = try! Realm()
            let data = realm.objects(RememberWord.self).filter("created == \(testData.shared.testArray[0].created)")
            for i in data{
                if i.dateStatus == "day"{
                    i.afterOneWeek()
                }else if i.dateStatus == "week"{
                    i.afterOneMonth()
                }else if i.dateStatus == "month"{
                    let endWordData: EndWord = EndWord()
                    endWordData.word = i.word
                    endWordData.wordMean = i.wordMean
                    try! realm.write {
                        realm.add(endWordData)
                        realm.delete(i)
                    }
                }
            }
            testData.shared.testArray.remove(at: 0)
            wordLabel.text = testData.shared.testArray[0].word
            textLabel.text = testData.shared.testArray[0].wordMean
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
