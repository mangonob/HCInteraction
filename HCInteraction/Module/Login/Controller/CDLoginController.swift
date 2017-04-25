//
//  CDLoginController.swift
//  HCInteraction
//
//  Created by 高炼 on 17/4/25.
//  Copyright © 2017年 高炼. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class CDLoginController: UIViewController {
    let keyMonitor = CDKeyboardMonitor()
    @IBOutlet weak var keyboardBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var accountTextField: CDRadiusTextField!
    @IBOutlet weak var passwordTextField: CDRadiusTextField!
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let logining = Variable(false)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyMonitor.setProgressHandler { [weak self] (progress) in
            self?.keyboardBottomConstraint.constant = self?.keyMonitor.bottom ?? 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.overrideInheritedCurve, .overrideInheritedOptions, .overrideInheritedDuration], animations: {
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        passwordTextField.rightView = indicator
        indicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
