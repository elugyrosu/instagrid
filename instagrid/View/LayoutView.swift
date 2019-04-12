//
//  Layout.swift
//  instagrid
//
//  Created by Jordan MOREAU on 25/03/2019.
//  Copyright © 2019 Jordan MOREAU. All rights reserved.
//

import UIKit

class LayoutView: UIView {  // Layout depend of the isHidden property of 2 images
    
    @IBOutlet private var rightTopLayoutImage: UIImageView!
    @IBOutlet private var rightBottomLayoutImage: UIImageView!
    
    var style: Style = .layout2 {
        didSet {
            setStyle(style)
        }
    }
    private func setStyle(_ style: Style){
        switch style {
            
        case .layout1:
            rightTopLayoutImage.isHidden = true
            rightBottomLayoutImage.isHidden = false
        case .layout2:
            rightTopLayoutImage.isHidden = false
            rightBottomLayoutImage.isHidden = true
        case .layout3:
            rightTopLayoutImage.isHidden = false
            rightBottomLayoutImage.isHidden = false
        }
    }



}

