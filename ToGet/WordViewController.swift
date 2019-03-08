//
//  WordViewController.swift
//  ToGet
//
//  Created by Masato Hayakawa on 2019/02/26.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

class WordViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var wordLabel: UILabel!
//    var getWord: String!
//    var getText: String!
    var tableViewDelegate: TableViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        wordLabel.text = PassData.shared.word
        textView.text = PassData.shared.wordMean
    }
    //更新ボタン
    @IBAction func updateButton(_ sender: Any) {
        let realm = try! Realm()
        if PassData.shared.status == "notRememberWord"{
            let notRememberWordData = realm.objects(NotRememberWord.self).sorted(byKeyPath: "created",ascending: false)
            let data = notRememberWordData[PassData.shared.indexPath]
            try! realm.write {
                data.wordMean = textView.text
            }
            
        }else if PassData.shared.status == "rememberWord"{
            let rememberWordData = realm.objects(RememberWord.self).sorted(byKeyPath: "created",ascending: false)
            let data = rememberWordData[PassData.shared.indexPath]
            try! realm.write {
                data.wordMean = PassData.shared.wordMean
            }

        }
    }
    //前の画面に戻る
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
}
