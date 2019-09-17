//
//  LocationTable.swift
//  Tracks
//
//  Created by 张驰 on 2019/8/14.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SQLite

class LocationTable {
    let table = Table("LocationTable")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    
    func setupTable() {
        do {
            guard let cmd = createTableCMD() else { return }
            try DataBase.db?.run(cmd)
        } catch { print(error) }
    }
    
    func createTableCMD() -> String? {
        return table.create(ifNotExists: true) { tbl in
            tbl.column(id, primaryKey: true)
            tbl.column(name, unique: true)
        }
    }
}
