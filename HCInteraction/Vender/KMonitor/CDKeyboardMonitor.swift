//
//  CDKeyboardMonitor.swift
//  Documention
//
//  Created by 高炼 on 17/4/20.
//  Copyright © 2017年 高炼. All rights reserved.
//

import UIKit
import Dispatch

internal func +(a: CGRect, b: CGRect) -> CGRect {
    return CGRect(x: a.origin.x + b.origin.x, y: a.origin.y + b.origin.y, width: a.size.width + b.size.width, height: a.size.height + b.size.height)
}

internal func -(a: CGRect, b: CGRect) -> CGRect {
    return a + CGRect(x: -b.origin.x, y: -b.origin.y, width: -b.size.width, height: -b.size.height)
}

internal func *(a: CGRect, b: CGFloat) -> CGRect {
    return CGRect(x: a.origin.x * b, y: a.origin.y * b, width: a.size.width * b, height: a.size.height * b)
}

internal func /(a: CGRect, b: CGFloat) -> CGRect {
    return a * (1/b)
}

class CDKeyboardMonitor: NSObject {
    typealias NotificationHandler = (Notification) -> ()
    typealias ProgressHandler = (CGFloat) -> ()
    
    var willShowHandler: NotificationHandler?
    var didShowHandler: NotificationHandler?
    var willHideHandler: NotificationHandler?
    var didHideHandler: NotificationHandler?
    var willChangeHandler: NotificationHandler?
    var didChangeHandler: NotificationHandler?
    var progressHandler: ProgressHandler?
    
    var duration: CGFloat = 0.25
    
    static var currentKeyBoard: UIView? {
        return UIApplication.shared.windows
            .filter{ NSStringFromClass($0.classForCoder) == "UIRemoteKeyboardWindow" }
            .first?.subviews.filter { NSStringFromClass($0.classForCoder) == "UIInputSetContainerView" }
            .first?.subviews.filter { NSStringFromClass($0.classForCoder) == "UIInputSetHostView" }
            .first
    }
    
    internal var keyboard: UIView? {
        return CDKeyboardMonitor.currentKeyBoard
    }
    
    internal var showFrame: CGRect?
    internal var hideFrame: CGRect?
    
    internal var progress: CGFloat = 0 {
        didSet {
            guard let keyboard = keyboard else { return }
            guard let showFrame = showFrame else { return }
            guard let hideFrame = hideFrame else { return }
            keyboard.frame = showFrame + (hideFrame - showFrame) * progress
            progressHandler?(progress)
        }
    }
    
    var bottom: CGFloat {
        guard let showFrame = showFrame else { return 0 }
        return showFrame.size.height * (1 - progress)
    }
    
    func setProgress(progress: CGFloat, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        let needDuration = TimeInterval(abs(progress - self.progress) * duration)
        if animated {
            UIView.animate(withDuration: needDuration, delay: 0, options: [.beginFromCurrentState], animations: { [weak self] in
                self?.progress = progress
            }, completion: { (finish) in
                completion?(finish)
            })
        } else {
            self.progress = progress
        }
    }
    
    func setTranslation(_ translation: CGFloat) {
        guard let bounds = keyboard?.bounds else { return }
        progress = min(max(translation / bounds.height, 0), 1)
    }
    
    override init() {
        super.init()
        
        weak var weakSelf = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notif) in
            weakSelf?.willShowHandler?(notif)
            guard let userInfo = notif.userInfo else { return }
            guard var end = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
            weakSelf?.showFrame = end
            end.origin.y += end.size.height
            weakSelf?.hideFrame = end
            weakSelf?.setProgress(progress: 0, animated: true)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil) { (notif) in
            weakSelf?.didShowHandler?(notif)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notif) in
            weakSelf?.willHideHandler?(notif)
            weakSelf?.setProgress(progress: 1, animated: true)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: nil) { (notif) in
            weakSelf?.didHideHandler?(notif)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil) { (notif) in
            weakSelf?.willChangeHandler?(notif)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil, queue: nil) { (notif) in
            weakSelf?.didChangeHandler?(notif)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @nonobjc func setWillShowHandler(_ handler: NotificationHandler?) { willShowHandler = handler }
    @nonobjc func setDidShowHandler(_ handler: NotificationHandler?) { didShowHandler = handler }
    @nonobjc func setWillHideHandler(_ handler: NotificationHandler?) { willHideHandler = handler }
    @nonobjc func setDidHideHandler(_ handler: NotificationHandler?) { didHideHandler = handler }
    @nonobjc func setWillChangeHandler(_ handler: NotificationHandler?) { willChangeHandler = handler }
    @nonobjc func setDidChangeHandler(_ handler: NotificationHandler?) { didChangeHandler = handler }
    @nonobjc func setProgressHandler(_ handler: ProgressHandler?) { progressHandler = handler }
}
