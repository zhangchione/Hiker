//
//  NoticeHelper.swift
//  Tracks
//
//  Created by 张驰 on 2019/7/11.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation
import SwiftMessages

class NoticeHelper {
    static func shake(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        DispatchQueue.main.async {
            let feedback = UIImpactFeedbackGenerator(style: style)
            feedback.prepare()
            feedback.impactOccurred()
        }

    }
    
    static func showError(_ text: String) {
        showNotice(text, theme: .error)
    }
    static func showSuccess(_ text: String) {
        showNotice(text, theme: .success)
    }
    static func showNotice(_ text: String, theme: Theme, duration: SwiftMessages.Duration = .seconds(seconds: 0.1)) {
        DispatchQueue.main.async {
            let success = MessageView.viewFromNib(layout: .statusLine)
            success.configureTheme(theme)
            success.configureDropShadow()
            success.configureContent(title: "Success", body: text)
            success.button?.isHidden = true
            var successConfig = SwiftMessages.defaultConfig
            successConfig.presentationStyle = .top
            successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            successConfig.duration = duration
            SwiftMessages.show(config: successConfig, view: success)
        }
    }

    static func showloading(_ text: String, theme: Theme, duration: SwiftMessages.Duration = .seconds(seconds: 0.1)) {
        DispatchQueue.main.async {

            let success = MessageView.viewFromNib(layout: .statusLine)
            //            if theme == .success {
            //                success.configureTheme(backgroundColor: UIColor(rgb: 0x2ADAD5), foregroundColor: .white)
            //            } else {
            success.configureTheme(theme)
            //            }
            success.configureDropShadow()
            success.configureContent(title: "Success", body: text)
            success.button?.isHidden = true
            var successConfig = SwiftMessages.defaultConfig
            successConfig.presentationStyle = .top
            successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            successConfig.duration = duration
            SwiftMessages.show(config: successConfig, view: success)
        }
    }
    static func showThanks(_ title: String) {
        showNotice(title, "app会因您变得更好", theme: .success, duration: .seconds(seconds: 3))
    }
    static func showNotice(_ title: String, _ body: String, theme: Theme, layout: MessageView.Layout = .cardView, duration: SwiftMessages.Duration = .seconds(seconds: 3)) {
        //        DispatchQueue.main.async {
        let view = MessageView.viewFromNib(layout: layout)

        // Theme message elements with the warning style.
        view.configureTheme(theme)
        // Add a drop shadow.
        view.configureDropShadow()
        view.button?.isHidden = true
        var iconText = ""
        if theme == .success {
            iconText = "😁"
        } else if theme == .error {
            iconText = "☹️"
        }
        view.configureContent(title: title, body: body, iconText: iconText)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        // Reduce the corner radius (applicable to layouts featuring rounded corners).
//        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        var config = SwiftMessages.Config.init()
//        config.presentationStyle = .top
        config.duration = duration
        SwiftMessages.show(config: config, view: view)
    }
    
    
}
