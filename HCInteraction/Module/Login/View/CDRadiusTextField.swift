//
//  CDRadiusTextField.swift
//  HCInteraction
//
//  Created by 高炼 on 17/4/25.
//  Copyright © 2017年 高炼. All rights reserved.
//

import UIKit

class CDRadiusTextField: UITextField {
    @IBInspectable
    var verticalMargin: CGFloat = 0
    
    @IBInspectable
    var leftTint: UIColor = UIColor.gray {
        didSet {
            guard let leftView = leftView as? UIImageView else { return }
            leftView.tintColor = leftTint
            leftView.image = leftImage?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            let v = UIImageView(image: leftImage)
            v.contentMode = .center
            leftView = v
        }
    }
    
    //MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        if leftView == nil || leftView?.superview == nil {
            return CGRect.zero
        }
        return CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        if rightView == nil || rightView?.superview == nil {
            return CGRect.zero
        }
        return CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
    }
    
    override var clearButtonMode: UITextFieldViewMode {
        get {
            if leftView == nil {
                return super.clearButtonMode
            }
            else {
                return .never
            }
        }
        set {
            super.clearButtonMode = newValue
        }
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        switch clearButtonMode {
        case .unlessEditing where isEditing, .whileEditing where !isEditing, .never:
            return CGRect.zero
        default: break
        }
        
        return super.clearButtonRect(forBounds: bounds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.bounds.height / 2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds.insetBy(dx: verticalMargin, dy: 0)
        rect.origin.x += leftViewRect(forBounds: bounds).width
        rect.size.width -= leftViewRect(forBounds: bounds).width
        rect.size.width -= rightViewRect(forBounds: bounds).width
        rect.size.width -= clearButtonRect(forBounds: bounds).width
        
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    //MARK: - Configure
    private func configure() {
        leftViewMode = .always
        rightViewMode = .always
    }
}
