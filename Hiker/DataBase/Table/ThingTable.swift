//
//  ThingsRealm.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SQLite

class ThingTable {
    let table = Table("ThingTable")
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

    //    func create(_ thing: String) {
    //        do {
    //            let insert = self.table.insert(self.name <- thing)
    //            try DataCenter.db?.run(insert)
    //        } catch { print(error) }
    //    }
}
