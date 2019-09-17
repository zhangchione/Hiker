//
//  DataBase.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/17.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation

import SQLite
import Photos
struct DataCenterConstant {
    static let dbName = "db.sqlite"
    static let dbFilePath = NSHomeDirectory() + "/Documents/" + DataCenterConstant.dbName
}

class DataBase {
    static let shared = DataBase()
    static var db: Connection? = {
        do {
            return try Connection(DataCenterConstant.dbFilePath)
        } catch {
            assertionFailure("Create DB Fail")
            debugPrint(error)
        }
        return nil
    }()
    
    var locationIndexTable = LocationIndexTable()
    var locationTable = LocationTable()
    var thingTable = ThingTable()
    var thingIndexTable = ThingIndexTable()
    var customAlbumTable = CustomAlbumTable()
    var delectTable = DelectTable()
    var localAlbumTable = LocalAlbumTable()
    var diaryTable = DiaryTable()
    
    init() {
        locationIndexTable.setupTable()
        locationTable.setupTable()
        thingTable.setupTable()
        thingIndexTable.setupTable()
        customAlbumTable.setupTable()
        delectTable.setupTable()
        localAlbumTable.setupTable()
        diaryTable.setupTable()
    }
}

// MARK: - Query
extension DataBase {
    func querylocalAlbumName() -> [String] {
        var value = [String]()
        do {
            for localAlbumPhoto in Array(try DataBase.db!.prepare(localAlbumTable.table) ) {
                value.append(localAlbumPhoto[localAlbumTable.name])
            }
        } catch {
            assertionFailure("\(error)")
        }
        return value
    }
    func queryDelectPhoto() -> [String] {
        var value = [String]()
        do {
            for delectPhoto in Array(try DataBase.db!.prepare(delectTable.table) ) {
                value.append(delectPhoto[delectTable.localIdentifier])
            }
        } catch {
            assertionFailure("\(error)")
        }
        return value
    }
    
    func queryCustomPhoto() -> [NewAlbum] {
        var res = [NewAlbum]()
        do {
            for value in Array(try DataBase.db!.prepare(customAlbumTable.table) ) {
                let name = value[customAlbumTable.name]
                let startDate = value[customAlbumTable.startDate]
                let endDate = value[customAlbumTable.endDate]
                let things = value[customAlbumTable.things]?.components(separatedBy: ",")
                let locations = value[customAlbumTable.locations]?.components(separatedBy: ",")
                let album = NewAlbum.init(name: name, classifyChoice: things, locationChoice: locations, beginTime: startDate, endTime: endDate)
                res.append(album)
            }
        } catch {
            assertionFailure("\(error)")
        }
        return res
    }
    
    func queryCustomCategory() -> [String] {
        var value = [String]()
        do {
            for thing in Array(try DataBase.db!.prepare(customAlbumTable.table) ) {
                value.append(thing[customAlbumTable.name])
            }
        } catch {
            assertionFailure("\(error)")
        }
        return value
    }
    
    func queryThingCategory() -> [String] {
        var value = [String]()
        do {
            for thing in Array(try DataBase.db!.prepare(thingTable.table) ) {
                value.append(thing[thingTable.name])
            }
        } catch {
            assertionFailure("\(error)")
        }
        return value
    }
    
    func queryLocationCategory() -> [String] {
        var value = [String]()
        do {
            for location in Array(try DataBase.db!.prepare(locationTable.table) ) {
                value.append(location[locationTable.name])
            }
        } catch {
            assertionFailure("\(error)")
        }
        return value
    }
    
    func queryLocationByGeographic(with photo: Photo) -> String? {
        do {
            let longitude = Double(photo.asset.location?.coordinate.longitude ?? 0.0 ).roundTo()
            let latitude = Double(photo.asset.location?.coordinate.latitude ?? 0.0 ).roundTo()
            let geographicTable = locationIndexTable.table
                .filter(locationIndexTable.longitude == longitude && locationIndexTable.latitude == latitude)
            
            // 把命中了照片并且有地址的
            if let pluck =  try DataBase.db?.pluck(geographicTable.join(locationTable.table, on: locationIndexTable.table[locationIndexTable.location_id] == locationTable.table[locationTable.id])) {
                self.insertLocationIndex(with: photo, to: pluck[locationTable.name])
                return pluck[locationTable.name]
            } else if try DataBase.db?.scalar(geographicTable.count) != 0 {
                return ""
            }
            
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }
    
    func queryLocation(with photo: Photo) -> String? {
        do {
            let cityTable = locationIndexTable.table
                .filter(locationIndexTable.localIdentifier == photo.asset.localIdentifier)
                .join(locationTable.table, on: locationIndexTable.table[locationIndexTable.location_id] == locationTable.table[locationTable.id])
            if let pluck =  try DataBase.db?.pluck(cityTable.select(locationTable.name)) { return pluck[locationTable.name] }
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }
    
    func queryLocationId(with city: String) -> Int64? {
        do {
            guard let pluck =  try DataBase.db?.pluck(locationTable.table.filter( locationTable.name == city)) else {
                let cid = self.insertLocation(with: city)
                return cid
            }
            return pluck[locationTable.id]
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }
    
    func findPhoto(with photo: Photo) -> Bool {
        do {
            let photoJoinTable = thingIndexTable.table
                .filter(thingIndexTable.localIdentifier == photo.asset.localIdentifier)
                .join(thingTable.table, on: thingIndexTable.table[thingIndexTable.thing_id] == thingTable.table[thingTable.id])
            
            guard let pluck =  try DataBase.db?.pluck(photoJoinTable.select(thingTable.name, thingIndexTable.convidence)) else { return false}
            var identifiers = [(String, Float)]()
            identifiers.append((pluck[thingTable.name], Float(pluck[thingIndexTable.convidence])))
            photo.identifiers = identifiers
            return true
        } catch {
            assertionFailure("\(error)")
        }
        return false
    }
    

    

}

// MARK: - Insert

extension DataBase {
    @discardableResult
    func insertCustomPhoto(with custom: NewAlbum) -> Int64? {
        var locations: String?
        var things: String?
        if let l = custom.locationChoice?.reduce("", { $0 == "" ? $1 : $0+","+$1 }), l != "" { locations = l }
        if let t = custom.thingsChoice?.reduce("", { $0 == "" ? $1 : $0+","+$1 }), t != "" { things = t }
        do {
            let customid = try DataBase.db?.run(customAlbumTable.table.insert(customAlbumTable.name <- custom.name,
                                                                              customAlbumTable.startDate <- custom.beginTime,
                                                                              customAlbumTable.endDate <- custom.endTime,
                                                                              customAlbumTable.locations <- locations,
                                                                              customAlbumTable.things <- things))
            return customid
        } catch {
            assertionFailure()
        }
        return nil
    }
    @discardableResult
    func insertThingIndex(with photo: Photo) -> Int64? {
        let localId = photo.asset.localIdentifier
        do {
            guard try DataBase.db?.scalar(thingIndexTable.table.filter(thingIndexTable.localIdentifier == localId).count) == 0 else { return nil }
            guard let thing = photo.identifiers?.first?.0, let convidence = photo.identifiers?.first?.1 else { return nil }
            
            guard let thingid = self.insertThing(with: thing)else {
                assertionFailure()
                return nil
            }
            
            let insertThing = thingIndexTable.table.insert(thingIndexTable.thing_id <- thingid,
                                                           thingIndexTable.localIdentifier <- localId,
                                                           thingIndexTable.convidence <- Double(convidence).roundTo(2))
            return try DataBase.db?.run(insertThing)
        } catch {
            assertionFailure()
        }
        return nil
    }
    
    func insertThing(with name: String) -> Int64? {
        do {
            if let thing = try DataBase.db?.pluck(thingTable.table.filter(thingTable.name == name)) {
                return thing[thingTable.id]
            }
            let insert = thingTable.table.insert(thingTable.name <- name)
            let thingid = try DataBase.db?.run(insert)
            return thingid
        } catch {
            assertionFailure()
        }
        return nil
    }
    @discardableResult
    func insertLocationIndex(with photo: Photo, to city: String?) -> Int64? {
        do {
            let longitude = Double(photo.asset.location?.coordinate.longitude ?? 0.0 ).roundTo()
            let latitude = Double(photo.asset.location?.coordinate.latitude ?? 0.0 ).roundTo()
            let localId = photo.asset.localIdentifier
            var locationid: Int64? =  nil
            if let c = city {
                locationid =  queryLocationId(with: c)
            }
            
            guard try DataBase.db?.scalar(locationIndexTable.table.filter(locationIndexTable.localIdentifier == localId).count) == 0 else { return nil }
            let insertIndex = locationIndexTable.table.insert(locationIndexTable.localIdentifier <- localId,
                                                              locationIndexTable.location_id <- locationid,
                                                              locationIndexTable.latitude <- latitude,
                                                              locationIndexTable.longitude <- longitude)
            let insertLocationid = try? DataBase.db?.run(insertIndex)
            return insertLocationid ?? nil
        } catch {
            assertionFailure()
        }
        return nil
    }
    
    @discardableResult
    func insertLocation(with name: String) -> Int64? {
        do {
            if let location = try DataBase.db?.pluck(locationTable.table.filter(locationTable.name == name)) {
                return location[locationTable.id]
            }
            let insert = locationTable.table.insert(locationTable.name <- name)
            let photoid = try? DataBase.db?.run(insert)
            return photoid ?? nil
        } catch {
            assertionFailure()
        }
        return nil
    }
    
    func insertDelect(with photo: Photo) {
        do {
            if (try DataBase.db?.pluck(delectTable.table.filter(delectTable.localIdentifier == photo.asset.localIdentifier))) != nil {
                return
            }
            let insert = delectTable.table.insert(delectTable.localIdentifier <- photo.asset.localIdentifier)
            _ = try? DataBase.db?.run(insert)
        } catch {
            assertionFailure()
        }
    }
    
    func insertLocalAlbum(with name: String) {
        do {
            if (try DataBase.db?.pluck(localAlbumTable.table.filter(localAlbumTable.name == name))) != nil {
                return
            }
            let insert = localAlbumTable.table.insert(localAlbumTable.name <- name)
            _ = try? DataBase.db?.run(insert)
        } catch {
            assertionFailure()
        }
    }
    
}
// MARK: - delete
extension DataBase {
    
    func delectDeleteTable(with photos: [Photo]) {
        let alice = delectTable.table.filter( photos.map { $0.asset.localIdentifier}.contains(delectTable.localIdentifier))
        do {
            try? DataBase.db?.run(alice.delete())
        } catch {
            assertionFailure()
        }
    }
    
    func deleteAllDelectTable() {
        let alice = delectTable.table
        do {
            try? DataBase.db?.run(alice.delete())
        } catch {
            assertionFailure()
        }
    }
    
    func  delectLocalAlbum(with names: [String]) {
        let alice = localAlbumTable.table.filter( names.contains(localAlbumTable.name))
        do {
            try? DataBase.db?.run(alice.delete())
        } catch {
            assertionFailure()
        }
    }
    
    
    func deleteCustomAlbum(with names: [String]) {
        let alice = customAlbumTable.table.filter( names.contains(customAlbumTable.name))
        do {
            try? DataBase.db?.run(alice.delete())
        } catch {
            assertionFailure()
        }
    }
}

extension Double {
    func roundTo(_ places: Int = 1) -> Double {
        var formatter = NumberFormatter()
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = places
        return Double(formatter.string(from: NSNumber(value: self)) ?? "\(self)") ?? self
    }
}
