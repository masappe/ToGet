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

    let backView = UIView()
    let wkWebView1 = WKWebView()
    let wkWebView2 = WKWebView()
    let wkWebView3 = WKWebView()
    let scrollView = UIScrollView()
    let addButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)
    let textView = UITextView()
    let addWordField = UITextField()
//    @IBOutlet weak var textView: UITextView!
//    @IBOutlet weak var addWordField: UITextField!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var pageControl: UIPageControl!
    
    var tableViewDelegate: TableViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //page数の決定
        pageControl.numberOfPages = 4
        scrollView.delegate = self
        addWordField.delegate = self
        wkWebView1.navigationDelegate = self
        wkWebView2.navigationDelegate = self
        wkWebView3.navigationDelegate = self
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //画面サイズの取得
        let safeArea = view.safeAreaLayoutGuide.layoutFrame
        let height = safeArea.height - 37 - 44
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: safeArea.origin.y
            + 44, width: safeArea.width, height: height)
        //デバイスの画面の4倍のコンテント
        scrollView.contentSize = CGSize(width: safeArea.width * CGFloat(pageControl.numberOfPages), height: height)
        view.addSubview(scrollView)
        //一つ上のレイヤーに対してどの位置に配置するのかを記入する
        backView.frame = CGRect(x: safeArea.width * 0, y: 0, width: safeArea.width, height: height)
        wkWebView1.frame = CGRect(x: safeArea.width * 1, y: 0, width: safeArea.width
            , height: height)
        wkWebView2.frame = CGRect(x: safeArea.width * 2, y: 0, width: safeArea.width
            , height: height)
        wkWebView3.frame = CGRect(x: safeArea.width * 3, y: 0, width: safeArea.width
            , height: height)
        var url = "https://ja.wikipedia.org/wiki/UDP"
        var encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        wkWebView1.load(URLRequest(url: encURL))
        url = "https://ja.wikipedia.org/wiki/UDP"
        encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        wkWebView2.load(URLRequest(url: encURL))
        url = "https://ja.wikipedia.org/wiki/UDP"
        encURL = URL(string: url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        wkWebView3.load(URLRequest(url: encURL))
        
        scrollView.addSubview(backView)
        scrollView.addSubview(wkWebView1)
        scrollView.addSubview(wkWebView2)
        scrollView.addSubview(wkWebView3)
        
        //ボタンの設定
        addButton.setTitle("追加する", for: .normal)
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.blue.cgColor
        addButton.tintColor = .blue
        addButton.layer.cornerRadius = 15
        addButton.addTarget(self, action: #selector(insertWord(_:)), for: UIControl.Event.touchUpInside)
        searchButton.setTitle("検索する", for: .normal)
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.blue.cgColor
        searchButton.tintColor = .blue
        searchButton.layer.cornerRadius = 15
        searchButton.addTarget(self, action: #selector(searchButton(_:)), for: .touchUpInside)
        //textViewの枠線の設定
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        //textfieldの設定
        addWordField.layer.borderColor = UIColor.lightGray.cgColor
        addWordField.layer.borderWidth = 1

        backView.addSubview(addButton)
        backView.addSubview(searchButton)
        backView.addSubview(textView)
        backView.addSubview(addWordField)


        //autolayout
        //NavigationBar
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        //PageControl
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
//        pageControl.topAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(navBar.frame)
        print(scrollView.frame)
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
    @objc func searchButton(_ sender: Any) {
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
    @objc func insertWord(_ sender: Any) {
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
