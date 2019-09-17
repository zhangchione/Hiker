//
//  LocationIndexRealm.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/13.
//  Copyright © 2019 张驰. All rights reserved.
//
// swiftlint:disable all
import Foundation
import SQLite

class LocationIndexTable {
    private let location = Table("LocationTable")
    //    private let photo = Table("PhotoTable")
    
    let table = Table("LocationIndexTable")
    let id = Expression<Int64>("id")
    let localIdentifier = Expression<String>("localIdentifier")
    let location_id = Expression<Int64?>("location_id")
    let latitude = Expression<Double>("latitude")
    let longitude = Expression<Double>("longitude")
    
    
    func setupTable() {
        do {
            guard let cmd = createTableCMD() else { return }
            try DataBase.db?.run(cmd)
        } catch { print(error) }
    }
    
    func createTableCMD() -> String? {
        return table.create(ifNotExists: true) { tbl in
            tbl.column(localIdentifier, primaryKey: true)
            tbl.column(location_id, references: location, id)
            tbl.column(latitude)
            tbl.column(longitude)
        }
    }
}
