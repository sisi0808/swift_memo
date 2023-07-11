//
//  MemoDetailVIewController.swift
//  MyColorMemoApp
//
//  Created by sisi0808 on 2023/07/09.
//

import UIKit

class MemoDetailViewController: UIViewController{
    @IBOutlet var textView: UITextView!
    
    var text: String = ""
    var recordDate: Date = Date()
    
    var dateFormat: DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY年MM月dd日"
        return dateFormatter
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
    }
    
    func configure(memo: MemoDataModel){
        text = memo.text
        recordDate = memo.recordDate
    }
    
    func displayData(){
        textView.text = text
        navigationItem.title = dateFormat.string(from:recordDate)
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
}
