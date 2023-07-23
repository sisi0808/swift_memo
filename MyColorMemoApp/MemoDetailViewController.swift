//
//  MemoDetailVIewController.swift
//  MyColorMemoApp
//
//  Created by sisi0808 on 2023/07/09.
//

import UIKit
import RealmSwift

class MemoDetailViewController: UIViewController{
    @IBOutlet var textView: UITextView!
    
    var memoData = MemoDataModel()
    
    var dateFormat: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        return dateFormatter
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        textView.delegate = self
    }
    
    func configure(memo: MemoDataModel){
        memoData.text = memo.text
        memoData.recordDate = memo.recordDate
    }
    
    func displayData(){
        textView.text = memoData.text
        navigationItem.title = dateFormat.string(from:memoData.recordDate)
    }
    
    @objc func tapDoneButton(){
        view.endEditing(true)
    }
    
    func setDoneButton(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let commitBUtton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitBUtton]
        textView.inputAccessoryView = toolBar
    }
    
    func saveData(with text: String){
        let realm = try! Realm()
        try! realm.write {
            memoData.text = text
            memoData.recordDate = Date()
            realm.add(memoData)
        }
    }
}

extension MemoDetailViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        let updatedText = textView.text ?? ""
        saveData(with: updatedText)
    }
}
