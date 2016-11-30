//
//  BlurredUIImageView.swift
//  bestway-ios
//
//  Created by Clément Peyrabere on 29/11/2016.
//  Copyright © 2016 ESGI. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
