//
//  DatePicker.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import Foundation
import UIKit

let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first
// MARK:- UIDEVICE
//==================
extension UIDevice {
    
    static let size = UIScreen.main.bounds.size
    
    static let height = UIScreen.main.bounds.height
    
    static let width = UIScreen.main.bounds.width
    
    @available(iOS 11.0, *)
    static var bottomSafeArea = keyWindow!.safeAreaInsets.bottom
    
    @available(iOS 11.0, *)
    static let topSafeArea = keyWindow!.safeAreaInsets.top
    
    static func vibrate() {
        let feedback = UIImpactFeedbackGenerator.init(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        feedback.prepare()
        feedback.impactOccurred()
    }
}

// MARK:- DatePicker Class Implementation
//==========================================
class DatePicker : UIDatePicker {
    
    internal typealias PickerDone = (_ date : Date) -> Void
    
    private var doneBlock : PickerDone!
    
    class func openPicker(in textField: UITextField, currentDate: Date?, minimumDate: Date?, maximumDate: Date?, pickerMode: UIDatePicker.Mode, doneBlock: @escaping PickerDone) {
        
        let picker = DatePicker()
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        picker.doneBlock = doneBlock
        picker.openPickerInTextField(textField: textField, currentDate: currentDate, minimumDate: minimumDate, maximumDate: maximumDate, pickerMode: pickerMode)
        
    }
    
    private func openPickerInTextField(textField: UITextField, currentDate: Date?, minimumDate: Date?, maximumDate: Date?, pickerMode: UIDatePicker.Mode) {
        
        self.datePickerMode = pickerMode
        
        self.maximumDate = maximumDate
        self.date = currentDate ?? Date()
        self.minimumDate = minimumDate
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(DatePicker.pickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action:nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(DatePicker.pickerCancelButtonTapped))
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let array = [cancelButton,spaceButton, doneButton]
        toolbar.setItems(array, animated: true)
        toolbar.backgroundColor = UIColor.lightText
        
        textField.inputView = self
        textField.inputAccessoryView = toolbar
        
    }
    
    @IBAction private func pickerDoneButtonTapped(){
        
        keyWindow?.endEditing(true)
        self.doneBlock(self.date)
    }
    
    @IBAction private func pickerCancelButtonTapped(){
        
        keyWindow?.endEditing(true)
        self.setDate(Calendar.current.date(byAdding: .year, value: 0, to: Date(), wrappingComponents: false)!, animated: false)
    }
}
