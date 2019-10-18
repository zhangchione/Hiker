//
//  GeocodeLocation.swift
//  Recognize
//
//  Created by nine on 2018/9/19.
//

import Foundation
import Photos

class GeocodeLocation {
    var waitPhoto = [Photo]()
    var intervalTime: TimeInterval = 0.5

    let geocode = CLGeocoder()
    let semaphore =  DispatchSemaphore(value: 1)
    let dispatchQueue =  DispatchQueue(label: "cc.zc.hiker.geocodeLocation", qos: .background)
    var isGeocodeing = false

    func startGeocode() {
        guard !isGeocodeing else { return }
        isGeocodeing.toggle()
        dispatchQueue.async {
            while let photo = self.waitPhoto.first {
                self.semaphore.wait()
                if let city = DataBase.shared.queryLocationByGeographic(with: photo) {
                    photo.city = city
                    //PhotoDataManager.addLocationAlbum(photo)
                    self.semaphore.signal()
                } else if let location = photo.location {
                    self.reverseGeocode(location, with: photo) { self.semaphore.signal() }
                    Thread.sleep(forTimeInterval: self.intervalTime)
                }
                if let i = self.waitPhoto.firstIndex(where: { $0 === photo }) { self.waitPhoto.remove(at: i) }
            }
            self.isGeocodeing.toggle()
        }
    }

    func reverseGeocode(_ location: CLLocation, with photo: Photo, finfish: (() -> Void)? ) {
        self.geocode.reverseGeocodeLocation(location) { (array, error) in
            if let array = array, array.count > 0 {
                var name: String?
                if let city = array[0].locality {
                    name = city
                } else if let subLocality = array[0].subLocality {
                    name = subLocality
                } else if let country = array[0].country {
                    name = country
                }
//                print("成功剩余\(self.waitPhoto.count)  \(Double(location.coordinate.latitude).roundTo()) \(Double(location.coordinate.longitude).roundTo()) \(name)")
                photo.city = name ?? ""
                DataBase.shared.insertLocationIndex(with: photo, to: name)
               // PhotoDataManager.addLocationAlbum(photo)
                self.intervalTime = 0.5
            } else {
                if error.debugDescription.contains("8") {
                    DataBase.shared.insertLocationIndex(with: photo, to: nil)
                    self.intervalTime = 0
                } else {
                    self.intervalTime = self.intervalTime < 0.5 ? 0.25 : self.intervalTime
                }
                self.intervalTime *= 2
                if self.intervalTime > 64 { self.intervalTime = 64 }
//                    print("失败\(Double(location.coordinate.latitude).roundTo()) \(Double(location.coordinate.longitude).roundTo())  等待\(self.intervalTime) 剩余\(self.waitPhoto.count)  \(error)  \(Double(location.coordinate.latitude)) \(Double(location.coordinate.longitude))  ")
            }
            finfish?()
        }
    }
}
