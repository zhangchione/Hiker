//
//  RecognizeManager+Recognize.swift
//  Recognize
//
//  Created by nine on 2018/9/22.
//

import Foundation
import Vision
import Photos
import UIKit
import CoreML

class DetectStatus {
    var textCount: Int = 0
    var faceCount: Int = 0
    var identifiers: [(String, Float)]?
}
class RecognizeUtil {
    static func startRecognize(_ photo: Photo, with model: MLModel, callBack: (() -> Void)?) {
        let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = true
        option.resizeMode = .exact

        PHImageManager.default().requestImage(for: photo.asset, targetSize: CGSize(width: 256, height: 256), contentMode: .aspectFit, options: option) {  (thumbnailImage, _) in
            guard let image: UIImage = thumbnailImage, let ciImage = CIImage(image: image) else { return }
            let detectStatus = DetectStatus()
            let requests = createVisionRequests(with: detectStatus, callBack: callBack)
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            do {
                try handler.perform(requests)
                detect(photo, with: detectStatus)
                callBack?()
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    fileprivate static func createVisionRequests(with status: DetectStatus, callBack: (() -> Void)?) -> [VNRequest] {
        var requests: [VNRequest] = []
        let classificationRequest: VNCoreMLRequest = {
            do {
                let model = try VNCoreMLModel(for: PhotoDataManager.Configuration.default.coreMLModel)
                let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
                    //                    let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
                    //                    _ = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
                    if let identifier = RecognizeUtil.processClassifications(for: request, error: error) {
                        status.identifiers = identifier
                    }
                        
                })
                request.imageCropAndScaleOption = .centerCrop
                return request
            } catch {
                fatalError("Failed to load Vision ML model: \(error)")
            }
        }()
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { (request, _) in
            guard let results = request.results as? [VNFaceObservation] else { return }
            status.faceCount = results.count
        }
        let textDetectionRequest = VNDetectTextRectanglesRequest { (request, _) in
            guard let results = request.results as? [VNTextObservation] else { return }
            status.textCount = results.count
        }
        requests.append(classificationRequest)  // 18w
        requests.append(faceDetectionRequest)   // 15
        requests.append(textDetectionRequest)   // 7s
        return requests
    }
}

extension RecognizeUtil {
    static func detect(_ photo: Photo, with detectStatus: DetectStatus) {
        // 表情包判定
        if detectStatus.identifiers?.first?.0 == "meme" {
            if detectStatus.faceCount <= 1, detectStatus.textCount >= 1 {
                photo.identifiers = detectStatus.identifiers
                return
            } else {
                detectStatus.identifiers?.removeFirst()
            }
        }
        // 文字判断
        if detectStatus.identifiers?.first?.0 == "text" || detectStatus.textCount > 0, photo.identifiers == nil {
            photo.identifiers = detectStatus.identifiers
            return
        }
        // 人脸判断
        if detectStatus.faceCount > 0, detectStatus.textCount == 0, photo.identifiers == nil {
            photo.identifiers = [("face", 1.0)]
            return
        }
        // 其他类型
        if photo.identifiers == nil {
            photo.identifiers = detectStatus.identifiers
        }
    }

    static func processClassifications(for request: VNRequest, error: Error?) -> [(String, Float)]? {
        guard let results = request.results else {
            return nil
        }
        guard let classifications = results as? [VNClassificationObservation] else { return nil }

        if !classifications.isEmpty {
            let topClassifications = classifications.prefix(2)
            return topClassifications.map { ($0.identifier, $0.confidence) }
        } else {
            return nil
        }
    }
}
