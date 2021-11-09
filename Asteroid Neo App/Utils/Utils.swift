//
//  Utils.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import Foundation
import UIKit

var isIPhoneSe: Bool { UIScreen.main.nativeBounds.height == 1136 }
typealias TableDelegate = UITableViewDelegate & UITableViewDataSource
//
let gAppDelegate = UIApplication.shared.delegate as! AppDelegate
let gSceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate


private let kAPICallManagerManagerLoggedEnable = true
private let kLoggedEnable = true

/// Print Debug
func printAPICallManagerLogs<T>(_ obj : T) {
#if DEBUG
    if kAPICallManagerManagerLoggedEnable == true { print("APICallManagerLogs : \(obj)") }
#endif
}

/// Print Debug
func printLogs<T>(file: StaticString = #file, line: UInt = #line, _ obj : T) {
    let url = URL(string: file.description)
    if kLoggedEnable == true { print("{\n   File: \(url?.lastPathComponent ?? ""), \n   line: \(line) \n    Log: \(obj)\n}") }
}

extension DispatchQueue {
    
    ///Delays the executon of 'closer' block upto a given time
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        
        self.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    ///Returns the main queue asynchronuously
    class func mainQueueAsync(_ closure:@escaping ()->()){
        self.main.async(execute: {
            closure()
        })
    }
    
    ///Returns the main queue synchronuously
    class func mainQueueSync(_ closure:@escaping ()->()){
        self.main.sync(execute: {
            closure()
        })
    }
    
    ///Returns the background queue asynchronuously
    class func backgroundQueueAsync(_ closure:@escaping ()->()){
        self.global().async(execute: {
            closure()
        })
    }
    
    ///Returns the background queue synchronuously
    class func backgroundQueueSync(_ closure:@escaping ()->()){
        self.global().sync(execute: {
            closure()
        })
    }
}

extension String {
    
    //To check text field or String is blank or not
    
    func trim() -> String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}

extension UIView {
    
    ///Sets the border width of the view
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    ///Sets the border color of the view
    @IBInspectable var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    
    ///Sets the corner radius of the view
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func draw3DShadow(shadowColor: UIColor = .black, opacity: Float = 0.5, offset: CGSize = CGSize(width: 1, height: 1), radius: CGFloat = 2, shouldRasterize : Bool = false, cornerRadius: CGFloat = 6) {
        self.cornerRadius = cornerRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = shouldRasterize
    }
    
}

extension String {
    
    var getFormattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.locale = .autoupdatingCurrent
        let date = dateFormatter.date(from: self) ?? Date()
        dateFormatter.dateFormat = "dd MMM"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
}


extension Double {
    
    func roundedBy(xDecimalPoints: Double) -> String {
        let tensData = pow(Double(10), Double(xDecimalPoints))
        let roundedData = (tensData*self).rounded()
        return "\(roundedData / tensData)"
    }
}

