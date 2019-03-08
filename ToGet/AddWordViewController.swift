//
//  AddWordViewController.swift
//  ToGet
//
//  Created by Masato Hayakawa on 2019/02/27.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift
//import Alamofire
//import SwiftyJSON
import WebKit

class AddWordViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate {

    @IBOutlet weak var wkWebView3: WKWebView!
    @IBOutlet weak var wkWebView2: WKWebView!
    @IBOutlet weak var wkWebView1: WKWebView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addWordField: UITextField!
    var tableViewDelegate: TableViewControllerDelegate!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        //page数の決定
        pageControl.numberOfPages = 4
        //frame表示領域，contentsize内容領域
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(pageControl.numberOfPages), height: scrollView.frame.size.height)
        scrollView.delegate = self
        addWordField.delegate = self
    }
        
    //scrollが終わった後の処理，ページの移動を行う
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    //pagecontrolをたっぷした時の処理
    @IBAction func tapPageControl(_ sender: UIPageControl) {
        scrollView.contentOffset.x = scrollView.frame.size.width * CGFloat(sender.currentPage)
    }
    //検索ボタン
    @IBAction func searchButton(_ sender: Any) {
        if (addWordField.text == ""){
            let alert = UIAlertController(title: "Error", message: "値が入力されてません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            var urlArray: [URL] = []
            var url = "https://ja.wikipedia.org/wiki/" + addWordField.text!
            //日本語のurlに対応できるようにencodeする
            var encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            urlArray.append(encURL!)
            url = "https://wa3.i-3-i.info/search.html?q=" + addWordField.text!
            encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            urlArray.append(encURL!)
            url = "https://www.weblio.jp/content/" + addWordField.text!
            print(url)
            encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            urlArray.append(encURL!)
            
            var myRequest = URLRequest(url: urlArray[0])
            wkWebView1.load(myRequest)
            myRequest = URLRequest(url: urlArray[1])
            wkWebView2.load(myRequest)
            myRequest = URLRequest(url: urlArray[2])
            wkWebView3.load(myRequest)
        }
    }
    //単語を追加
    @IBAction func insertWord(_ sender: Any) {
        if ((addWordField.text == "")||(textView.text == "")){
            let alert = UIAlertController(title: "Error", message: "値が入力されてません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            let realmData: NotRememberWord = NotRememberWord()
            realmData.word = addWordField.text!
            realmData.wordMean = textView.text!
            save(realmData: realmData)
        }
    }
    //前の画面に戻る
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: {
            //tableの更新
            self.tableViewDelegate.reloadTable()
        })
    }
    //単語をデータベースに追加
    func save(realmData:NotRememberWord) {
        do {
            let realm = try Realm()  // Realmのインスタンスを作成します。
            try realm.write {
                realm.add(realmData)  // 作成した「realm」というインスタンスにrealmDataを書き込みます。
            }
        } catch {
            
        }
    }
    
    //returnを押したらキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //TextField以外をタップしたらキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
