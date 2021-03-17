//
//  PrimaryMediumButton.swift
//  ComponentTest
//
//  Created by SIDDHANT-TCS on 16/2/2564 BE.
//

import UIKit

@IBDesignable
public final class PrimaryMediumButton: TTBBaseButton {
    
    public override func draw(_ rect: CGRect) {
        buttonDesign = .primary(.medium)
        super.draw(rect)
    }
}

