//
//  NewAlbumRealm.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SQLite

class CustomAlbumTable {
    private let thing = Table("ThingTable")
    private let photo = Table("PhotoTable")

    let table = Table("CustomAlbumTable")
    let id = Expression<Int64>("id")
    let locations = Expression<String?>("locations")
    let things = Expression<String?>("things")
    let name = Expression<String>("name")
    let startDate = Expression<Date?>("startDate")
    let endDate = Expression<Date?>("endDate")

    func setupTable() {
        do {
            guard let cmd = createTableCMD() else { return }
            try DataBase.db?.run(cmd)
        } catch { print(error) }
    }

    func createTableCMD() -> String? {
        return table.create(ifNotExists: true) { tbl in
            tbl.column(id, primaryKey: true)
            tbl.column(locations)
            tbl.column(things)
            tbl.column(name)
            tbl.column(startDate)
            tbl.column(endDate)
        }
    }
}

