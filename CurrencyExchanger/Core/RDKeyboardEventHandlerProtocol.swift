//
//  RDKeyboardEventHandlerProtocol.swift
//  CurrencyExchanger
//
//  Created by Giorgi Katamadze on 4/9/23.
//

import UIKit


@objc protocol RDKeyboardEventHandlerProtocol : AnyObject {
    @objc optional func keyboardWillShow(notification: NSNotification)
    @objc optional func keyboardDidShow(notification: NSNotification)
    @objc optional func keyboardWillChangeFrame(notification: NSNotification)
    @objc optional func keyboardDidChangeFrame(notification: NSNotification)
    @objc optional func keyboardWillHide(notification: NSNotification)
    @objc optional func keyboardDidHide(notification: NSNotification)
}
extension RDKeyboardEventHandlerProtocol where Self:NSObject {
    func registerKeyboardEvent() {
        [
            (#selector(self.keyboardWillShow(notification:)), UIResponder.keyboardWillShowNotification),
            (#selector(self.keyboardDidShow(notification:)), UIResponder.keyboardDidShowNotification),
            (#selector(self.keyboardWillChangeFrame(notification:)), UIResponder.keyboardWillChangeFrameNotification),
            (#selector(self.keyboardDidChangeFrame(notification:)), UIResponder.keyboardDidChangeFrameNotification),
            (#selector(self.keyboardWillHide(notification:)), UIResponder.keyboardWillHideNotification),
            (#selector(self.keyboardDidHide(notification:)), UIResponder.keyboardDidHideNotification)
        ].forEach { touple in
            if self.responds(to: touple.0) {
                
                NotificationCenter.default.addObserver(self, selector: touple.0, name: touple.1, object: nil)
            }
        }
    }
    func unregisterKeyboardEvents()
    {
        [
            (#selector(self.keyboardWillShow(notification:)), UIResponder.keyboardWillShowNotification),
            (#selector(self.keyboardDidShow(notification:)), UIResponder.keyboardDidShowNotification),
            (#selector(self.keyboardWillChangeFrame(notification:)), UIResponder.keyboardWillChangeFrameNotification),
            (#selector(self.keyboardDidChangeFrame(notification:)), UIResponder.keyboardDidChangeFrameNotification),
            (#selector(self.keyboardWillHide(notification:)), UIResponder.keyboardWillHideNotification),
            (#selector(self.keyboardDidHide(notification:)), UIResponder.keyboardDidHideNotification)
        ].forEach { touple in
            
            if(self.responds(to: touple.0))
            {
                NotificationCenter.default.removeObserver(self, name: touple.1, object: nil)
            }
        }
    }
}
