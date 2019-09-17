//
//  ThingIndexTable.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//
// swiftlint:disable all
import Foundation
import SQLite

class ThingIndexTable {
    private let thing = Table("ThingTable")
    //    private let photo = Table("PhotoTable")
    private let id = Expression<Int64>("id")
    
    let table = Table("ThingIndexTable")
    let localIdentifier = Expression<String>("localIdentifier")
    let thing_id = Expression<Int64>("thing_id")
    let convidence = Expression<Double>("convidence")
    
    func setupTable() {
        do {
            guard let cmd = createTableCMD() else { return }
            try DataBase.db?.run(cmd)
        } catch { print(error) }
    }
    
    func createTableCMD() -> String? {
        return table.create(ifNotExists: true) { tbl in
            //            tbl.column(id, primaryKey: true)
            tbl.column(localIdentifier, primaryKey: true)
            tbl.column(thing_id, references: thing, id)
            tbl.column(convidence)
        }
    }
    
    //    func create(_ thing: String) {
    //        do {
    //            let insert = self.table.insert(self.name <- thing)
    //            try DataCenter.db?.run(insert)
    //        } catch { print(error) }
    //    }
}
