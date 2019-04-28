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
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet var updateButton: UIButton!
    var tableViewDelegate: TableViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        //ボタンの設定
        updateButton.layer.borderWidth = 1
        updateButton.layer.borderColor = UIColor.blue.cgColor
        updateButton.tintColor = .blue
        updateButton.layer.cornerRadius = 15
        updateButton.backgroundColor = .white
        //textViewの枠線の設定
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        wordLabel.text = PassData.shared.word
        textView.text = PassData.shared.wordMean
        
        //autolayout
        //navbar
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        //wordLabel
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
        wordLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        wordLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30).isActive = true
        wordLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        //updateButton
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        updateButton.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 30).isActive = true
        //textView
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        textView.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 30).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    //更新ボタン
    @IBAction func updateButton(_ sender: Any) {
        if textView.text == ""{
            //入力がない時のアラート
            let alert = UIAlertController(title: "エラー", message: "単語の意味を追加してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
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
            let alert = UIAlertController(title: "更新", message: "単語が更新されました", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            
        }
    }
    //前の画面に戻る
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion:nil)
    }
}
