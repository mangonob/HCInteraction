//
//  CDGradientView.swift
//  HCInteraction
//
//  Created by 高炼 on 17/4/25.
//  Copyright © 2017年 高炼. All rights reserved.
//

import UIKit
import ChameleonFramework

class CDGradientView: UIView {
    override static var layerClass: AnyClass { return CAGradientLayer.classForCoder() }
    
    override var layer: CAGradientLayer {
        assert(super.layer is CAGradientLayer)
        return super.layer as! CAGradientLayer
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
    
    //MARK: - Configure
    private func configure() {
        isOpaque = false
        layer.colors = [UIColor.randomFlat.cgColor, UIColor.randomFlat.cgColor]
        layer.locations = [0, 1]
        layer.startPoint = CGPoint.zero
        layer.endPoint = CGPoint(x: 1, y: 1)
    }
}
