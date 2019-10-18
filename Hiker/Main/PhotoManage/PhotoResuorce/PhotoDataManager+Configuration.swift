//
//  PhotoDataManager+Configuration.swift
//  Common
//
//  Created by nine on 2018/9/25.
//

import Foundation
import CoreML
import Photos

extension PhotoDataManager {
    struct PhotoSerialQueue {
        let thing = DispatchQueue.init(label: "cc.zc.hiker.addThing")
        let location = DispatchQueue.init(label: "cc.zc.hiker.addLocation")
        let custom = DispatchQueue.init(label: "cc.zc.hiker.addCustom")
        let my = DispatchQueue.init(label: "cc.zc.hiker.addMy")
    }
    struct Configuration {
        var coreMLModel: MLModel
        var confidence: Float
        let modelVersion: Int

        static var `default`: Configuration {
            return Configuration(coreMLModel: ImageClassifier().model,
                                 confidence: 0.8,
                                 modelVersion: 16)
        }
    }
}


extension PHFetchOptions {
    func config() {
        self.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.includeHiddenAssets = false
        self.includeAllBurstAssets = false
        self.includeAssetSourceTypes = [.typeUserLibrary]
        self.predicate = NSPredicate(format: "mediaType = %d",
                                     PHAssetMediaType.image.rawValue)
    }
}
