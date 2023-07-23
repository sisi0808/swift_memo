//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by sisi0808 on 2023/07/08.
//

import Foundation
import UIKit // UIに関するクラスが格納されたモジュール
import RealmSwift

class HomeViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var memoDataList: [MemoDataModel] = []
    
    override func viewDidLoad() {
        // このクラスが表示される際に呼び出される
        // 画面の表示・婢女表示に 応じて実行されるメソッドを「ライフサイクルメソッド」と呼ぶ
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        setNavigationBarButton()
        setLeftNavigationBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMemoData()
        tableView.reloadData()
    }
    
    func setMemoData(){
        let realm = try! Realm()
        let result = realm.objects(MemoDataModel.self)
        memoDataList = Array(result)
    }
    
    @objc func tapAddButton(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(withIdentifier: "MemoDetailViewController") as! MemoDetailViewController
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    func setNavigationBarButton(){
        let buttonActionSelector: Selector = #selector(tapAddButton)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setLeftNavigationBarButton(){
        let buttonActionSelector: Selector = #selector(didTapColorSettingButton)
        let leftButtonImage = UIImage(named: "night")
        let leftButton = UIBarButtonItem(image: leftButtonImage, style:.plain, target: self, action: buttonActionSelector)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func didTapColorSettingButton(){
        let defaultAction = UIAlertAction(title: "デフォルト", style: .default, handler: { _ -> Void in
            print("デフォルトがタップされました")
        })
        let orangeAction = UIAlertAction(title: "オレンジ", style: .default, handler: { _ -> Void in
            print("オレンジがタップされました")
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .default, handler: nil)
        let alert = UIAlertController(title: "テーマカラーを選択してください", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource{
    // テーブルのレコード数を定義
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataList.count
    }

    // テーブルの中身を定義(セル毎に読み込まれる)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let memoDataModel: MemoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}

extension HomeViewController: UITableViewDelegate{
    // タップされたセルのインデックス番号を表示
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // storyboardからインスタンスを取得
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        // 遷移先のページを取得
        let memoDetailViewController = storyBoard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        // メモの内容を取得・記録
        let memoData = memoDataList[indexPath.row]
        memoDetailViewController.configure(memo: memoData)
        
        // 選択状態を解除
        tableView.deselectRow(at: indexPath, animated:true)
        // pushされたら遷移
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let targetMemo = memoDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write{
            realm.delete(targetMemo)
        }
        memoDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
