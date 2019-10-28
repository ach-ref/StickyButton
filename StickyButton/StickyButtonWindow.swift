//
//  StickyButtonWindow.swift
//  StickyButton
//
//  Created by Achref Marzouki on 24/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit

/// A `UIWindow` subclass responsible for managing the sticky view controller.
open class StickyButtonWindow: UIWindow {

    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.windowLevel = UIWindow.Level.normal
        if #available(iOS 13.0, *) {
            let currentWinwdowScene = UIApplication.shared.connectedScenes.first
            windowScene = currentWinwdowScene as? UIWindowScene
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touches detection
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        let stickyButtonViewController = rootViewController as? StickyButtonViewController
        if let stickyButton = stickyButtonViewController?.stickyButton {
            // if menu is open
            if stickyButton.isOpen {
                return true
            }
            
            if stickyButton.frame.contains(point) {
                return true
            }
        }
        return false
    }
}
