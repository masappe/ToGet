//
//  ViewController.swift
//  ToGet
//
//  Created by Masato Hayakawa on 2019/02/26.
//  Copyright © 2019 masappe. All rights reserved.
//
import UIKit
import RealmSwift

protocol TableViewControllerDelegate{
    func reloadTable()
}
protocol TabViewControllerDelegate {
    func reloadTabBar()
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TableViewControllerDelegate,UITabBarDelegate,TabViewControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    //init,notRememberWord,rememberWord,endWord
    var status = "init"
    //    var wordArray:[String] = []
    var passWord: String!
    var passText: String!
    var notRememberWordData: Results<NotRememberWord>!
    var rememberWordData: Results<RememberWord>!
    var endWordData: Results<EndWord>!
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        //createdを降順にソート
        notRememberWordData = realm.objects(NotRememberWord.self).sorted(byKeyPath: "created",ascending: false)
        rememberWordData = realm.objects(RememberWord.self).sorted(byKeyPath: "created",ascending: false)
        endWordData = realm.objects(EndWord.self).sorted(byKeyPath: "created",ascending: false)
        print(notRememberWordData)
        print(rememberWordData)
        print(endWordData)
        
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        
    }
    //tableview内のセルをたっぷしたらwordviewに画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if status == "init" || status == "notRememberWord" {
            //            passWord = notRememberWordData[indexPath.row].word
            //            passText = notRememberWordData[indexPath.row].wordMean
            PassData.shared.status = "notRememberWord"
            PassData.shared.indexPath = indexPath.row
            PassData.shared.word = notRememberWordData[indexPath.row].word
            PassData.shared.wordMean = notRememberWordData[indexPath.row].wordMean
        }else if status == "rememberWord"{
            //            passWord = rememberWordData[indexPath.row].word
            //            passText = rememberWordData[indexPath.row].wordMean
            PassData.shared.status = "rememberWord"
            PassData.shared.indexPath = indexPath.row
            PassData.shared.word = rememberWordData[indexPath.row].word
            PassData.shared.wordMean = rememberWordData[indexPath.row].wordMean
        }else if status == "endWord"{
            //            passWord = endWordData[indexPath.row].word
            //            passText = endWordData[indexPath.row].wordMean
            PassData.shared.status = "endWord"
            PassData.shared.indexPath = indexPath.row
            PassData.shared.word = endWordData[indexPath.row].word
            PassData.shared.wordMean = endWordData[indexPath.row].wordMean
        }
        performSegue(withIdentifier: "toWord", sender: nil)
    }
    //画面遷移する前の準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //AddWordViewController
        if segue.identifier == "toAddWord"{
            let addWordViewController = segue.destination as! AddWordViewController
            //delegateの設定
            addWordViewController.tableViewDelegate = self
        }
        if segue.identifier == "toCheck"{
            let checkViewController = segue.destination as! CheckViewController
            checkViewController.tabViewDelegate = self
        }
        //WordViewController
        //        if segue.identifier == "toWord"{
        //            let wordViewController = segue.destination as! WordViewController
        //            wordViewController.getWord = passWord
        //            wordViewController.getText = passText
    }
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            notRememberWord()
        case 2:
            rememberWord()
        case 3:
            endWord()
        case 4:
            toCheck()
        default:
            break
        }
    }
    func notRememberWord(){
        status = "notRememberWord"
        reloadTable()
    }
    func rememberWord(){
        status = "rememberWord"
        reloadTable()
    }
    func endWord(){
        status = "endWord"
        reloadTable()
    }
    func toCheck(){
        performSegue(withIdentifier: "toCheck", sender: nil)
    }
    //delegateで使用，tableviewをreloadする
    func reloadTable(){
        tableView.reloadData()
    }
    //delegateで使用，tabbarのアイコン設定
    func reloadTabBar(){
        //tabbarのバッチ
        if testData.shared.testArray.count >= 0{
            tabBar.items![3].badgeValue = String(testData.shared.testArray.count)
            
        }

    }
    //tableviewに対する左スワイプの設定
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //削除の設定
        let delete = UIContextualAction(style: .destructive, title: "削除", handler: {(action, sourceView, completionHandler) in
            //なんか必要
            completionHandler(true)
            //データとセルの削除
            let realm = try! Realm()
            if self.status == "init" || self.status == "notRememberWord" {
                let data = self.notRememberWordData[indexPath.row]
                try! realm.write {
                    realm.delete(data)
                }
            }else if self.status == "rememberWord"{
                let data = self.rememberWordData[indexPath.row]
                try! realm.write {
                    realm.delete(data)
                }
            }else if self.status == "endWord"{
                let data = self.endWordData[indexPath.row]
                try! realm.write {
                    realm.delete(data)
                }
            }
            tableView.deleteRows(at: [indexPath], with: .right)
        })
        delete.backgroundColor = .red
        //覚える→覚えた設定
        let remember = UIContextualAction(style: .destructive, title: "覚えた", handler: {(action,sourceView,completionHandler) in
            completionHandler(true)
            let realm = try! Realm()
            let notRememberWordData = self.notRememberWordData[indexPath.row]
            let rememberWordData: RememberWord = RememberWord()
            rememberWordData.word = notRememberWordData.word
            rememberWordData.wordMean = notRememberWordData.wordMean
            //日付の更新
            rememberWordData.created = Date(timeIntervalSinceNow: 9*60*60)
            //１日後の日付を入れる
            rememberWordData.afterOneDay()
            try! realm.write {
                realm.add(rememberWordData)
                realm.delete(notRememberWordData)
            }
            tableView.deleteRows(at: [indexPath], with: .right)
        })
        remember.backgroundColor = .lightGray
        //覚えた→終了設定
        
        //スワイプした時の表示を決める
        if status == "init" || status == "notRememberWord"{
            return UISwipeActionsConfiguration(actions: [delete,remember])
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    @IBAction func button(_ sender: Any) {
        print(Date())
    }
    //cellの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.status == "init" || self.status == "notRememberWord" {
            return notRememberWordData.count
        }else if status == "rememberWord"{
            return rememberWordData.count
        }else if status == "endWord"{
            return endWordData.count
        }
        return 1
    }
    //cellの内容を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if self.status == "init" || self.status == "notRememberWord" {
            cell?.textLabel?.text = notRememberWordData[indexPath.row].word
        }else if status == "rememberWord"{
            cell?.textLabel?.text = rememberWordData[indexPath.row].word
        }else if status == "endWord"{
            cell?.textLabel?.text = endWordData[indexPath.row].word
        }
        return cell!
    }
    
}
