//
//  UISegmentController+Extension.swift
//  SFSymbolsArtCreator
//
//

import UIKit

extension UISegmentedControl {
    
    /// set appearance for this app
    static func setAppearance() {
        
        self.appearance().selectedSegmentTintColor = .tintColor
        self.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor.paleGray],
            for: .selected
        )
        self.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor.systemGray],
            for: .normal
        )
    }
}
