//
//  MemoDataModel.swift
//  MyColorMemoApp
//
//  Created by sisi0808 on 2023/07/09.
//

import Foundation
import RealmSwift

class MemoDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString // データを一位に識別するための識別子
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
