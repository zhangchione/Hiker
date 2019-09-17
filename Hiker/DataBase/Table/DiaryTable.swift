//
//  DiaryTable.swift
//  Tracks
//
//  Created by 张驰 on 2019/8/20.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SQLite

class DiaryTable{
    let table = Table("DiaryTable")
    let id = Expression<Int64>("id")
    let date = Expression<Date>("date")
    let describe = Expression<String>("describe")
    let image = Expression<String>("image")
    let images = Expression<String>("images")
    let title = Expression<String>("title")
    let content = Expression<String>("content")
    let location = Expression<String>("location")
    
    
    func setupTable() {
        do {
            guard let cmd = createTableCMD() else { return }
            try DataBase.db?.run(cmd)
        } catch { print(error) }
    }
    
    func createTableCMD() -> String? {
        return table.create(ifNotExists: true) { tbl in
            tbl.column(id, primaryKey: true)
            tbl.column(date)
            tbl.column(describe)
            tbl.column(image)
            tbl.column(images)
            tbl.column(title)
            tbl.column(content)
            tbl.column(location)
        }
    }
}
