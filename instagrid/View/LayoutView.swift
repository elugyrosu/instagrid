//
//  Layout.swift
//  instagrid
//
//  Created by Jordan MOREAU on 25/03/2019.
//  Copyright © 2019 Jordan MOREAU. All rights reserved.
//

import UIKit

class LayoutView: UIView {
    
    @IBOutlet private var image2: UIImageView!
    @IBOutlet private var image4: UIImageView!
    
    var style: Style = .layout2 {
        didSet {
            setStyle(style)
        }
    }
    private func setStyle(_ style: Style){
        switch style {
            
        case .layout1:
            image2.isHidden = true
            image4.isHidden = false
        case .layout2:
            image2.isHidden = false
            image4.isHidden = true
        case .layout3:
            image2.isHidden = false
            image4.isHidden = false
        }
    }



}

