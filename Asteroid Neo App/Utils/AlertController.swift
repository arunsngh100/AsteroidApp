//
//  AlertController.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import Foundation
import UIKit

class AlertController {
    
    /// Show Toast With Message
    static func showToastWithMessage(_ msg: String, completion: (() -> Swift.Void)? = nil) {
        if msg.count > 0 {
            DispatchQueue.mainQueueAsync {
                SKToast.backgroundStyle(UIBlurEffect.Style.dark)
                SKToast.messageFont(.systemFont(ofSize: 14))
                SKToast.messageTextColor(UIColor.white)
                SKToast.show(withMessage: msg, completionHandler: {
                    completion?()
                })
            }
        }
        else {
            
        }
    }
}
