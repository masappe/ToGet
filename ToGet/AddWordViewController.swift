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

class AddWordViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate,WKNavigationDelegate {

    @IBOutlet var backView: UIView!
    @IBOutlet weak var wkWebView3: WKWebView!
    @IBOutlet weak var wkWebView2: WKWebView!
    @IBOutlet weak var wkWebView1: WKWebView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addWordField: UITextField!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    
    var tableViewDelegate: TableViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面サイズの取得
        let viewSize = UIScreen.main.bounds.size
        
        //ボタンの設定
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.blue.cgColor
        addButton.tintColor = .blue
        addButton.layer.cornerRadius = 15
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.blue.cgColor
        searchButton.tintColor = .blue
        searchButton.layer.cornerRadius = 15
        //textViewの枠線の設定
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        //page数の決定
        pageControl.numberOfPages = 4
        //frame表示領域，contentsize内容領域
        //scrollviewが不変的だった
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(pageControl.numberOfPages), height: scrollView.frame.size.height)
        //デバイスの画面の4倍のコンテント
        scrollView.contentSize = CGSize(width: viewSize.width * CGFloat(pageControl.numberOfPages), height: viewSize.height - 44 - 37 - 20)
        scrollView.delegate = self
        addWordField.delegate = self
        wkWebView1.navigationDelegate = self
        wkWebView2.navigationDelegate = self
        wkWebView3.navigationDelegate = self
        
        //autolayout
        //NavigationBar
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        //ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor).isActive = true
        //PageControl
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //BackView
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        backView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        backView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        backView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        //WebView1
        wkWebView1.translatesAutoresizingMaskIntoConstraints = false
        wkWebView1.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        wkWebView1.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        wkWebView1.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        wkWebView1.leftAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
        //WebView2
        wkWebView2.translatesAutoresizingMaskIntoConstraints = false
        wkWebView2.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        wkWebView2.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        wkWebView2.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        wkWebView2.leftAnchor.constraint(equalTo: wkWebView1.rightAnchor).isActive = true
        //WebView3
        wkWebView3.translatesAutoresizingMaskIntoConstraints = false
        wkWebView3.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        wkWebView3.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        wkWebView3.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        wkWebView3.leftAnchor.constraint(equalTo: wkWebView2.rightAnchor).isActive = true
        //AddWordField
        addWordField.translatesAutoresizingMaskIntoConstraints = false
        addWordField.topAnchor.constraint(equalTo: backView.topAnchor, constant: 30).isActive = true
        addWordField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addWordField.widthAnchor.constraint(equalToConstant: 260).isActive = true
        addWordField.centerXAnchor.constraint(equalTo: backView.centerXAnchor).isActive = true
        //addButton
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addButton.topAnchor.constraint(equalTo: addWordField.bottomAnchor, constant: 30).isActive = true
        addButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: -70).isActive = true
        //searchButton
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchButton.topAnchor.constraint(equalTo: addWordField.bottomAnchor, constant: 30).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor, constant: 70).isActive = true
        //textView
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: backView.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: backView.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 30).isActive = true
        textView.bottomAnchor.constraint(equalTo: backView.bottomAnchor,constant: -10).isActive = true
        

    }
    //scrollが終わった後の処理，ページの移動を行う
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / view.safeAreaLayoutGuide.layoutFrame.width)

    }
    //pagecontrolをたっぷした時の処理
    @IBAction func tapPageControl(_ sender: UIPageControl) {
        scrollView.contentOffset.x = view.safeAreaLayoutGuide.layoutFrame.width * CGFloat(sender.currentPage)
    }
    //検索ボタン
    @IBAction func searchButton(_ sender: Any) {
        if (addWordField.text == ""){
            // 入力がない時のアラート
            let alert = UIAlertController(title: "Error", message: "値が入力されてません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            //webサイトの表示
            var urlArray: [URL] = []
            var url = "https://ja.wikipedia.org/wiki/" + addWordField.text!
            //日本語のurlに対応できるようにencodeする
            var encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            urlArray.append(encURL!)
            url = "https://wa3.i-3-i.info/search.html?q=" + addWordField.text!
            encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            urlArray.append(encURL!)
            url = "https://www.weblio.jp/content/" + addWordField.text!
            encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
            urlArray.append(encURL!)
            
            var myRequest = URLRequest(url: urlArray[0])
            wkWebView1.load(myRequest)
            myRequest = URLRequest(url: urlArray[1])
            wkWebView2.load(myRequest)
            myRequest = URLRequest(url: urlArray[2])
            wkWebView3.load(myRequest)
            //確認アラート
            let alert = UIAlertController(title: "検索", message: "検索しました", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)

        }
    }
    //単語を追加
    @IBAction func insertWord(_ sender: Any) {
        if ((addWordField.text == "")&&(textView.text == "")){
            //入力がない時のアラート
            let alert = UIAlertController(title: "エラー", message: "単語と単語の意味を追加してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else if ((addWordField.text == "")||(textView.text == "")){
            //入力がない時のアラート
            let alert = UIAlertController(title: "エラー", message: "単語か単語の意味が追加されていません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)

        }else{
            //単語の追加
            let realmData: NotRememberWord = NotRememberWord()
            realmData.word = addWordField.text!
            realmData.wordMean = textView.text!
            save(realmData: realmData)
            //確認アラート
            let alert = UIAlertController(title: "追加", message: "単語を追加しました", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
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
