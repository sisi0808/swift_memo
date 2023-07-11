//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by sisi0808 on 2023/07/08.
//

import Foundation
import UIKit // UIに関するクラスが格納されたモジュール

class HomeViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var memoDataList: [MemoDataModel] = []
    
    override func viewDidLoad() {
        // このクラスが表示される際に呼び出される
        // 画面の表示・婢女表示に 応じて実行されるメソッドを「ライフサイクルメソッド」と呼ぶ
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        setMemoData()
        setNavigationBarButton()
    }
    
    func setMemoData(){
        for i in 1...5{
            let memodataModel = MemoDataModel(text: "このメモは\(i)番目のメモです", recordDate: Date())
            memoDataList.append(memodataModel)
        }
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
}
