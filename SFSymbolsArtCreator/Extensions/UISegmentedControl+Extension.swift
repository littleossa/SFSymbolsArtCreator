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
            [.font: UIFont.systemFont(ofSize: 16.0, weight: .bold),
             .foregroundColor : UIColor.paleGray],
            for: .selected
        )
        self.appearance().setTitleTextAttributes(
            [.foregroundColor : UIColor.systemGray],
            for: .normal
        )
    }
}
