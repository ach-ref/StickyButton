//
//  StickyButtonManager.swift
//  StickyButton
//
//  Created by Achref Marzouki on 24/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit

/// A global manager of a unique instance of the `StickyButton` type.
@objcMembers
open class StickyButtonManager: NSObject {
    
    // MARK: - Shared instance
    
    /// The shared and unique instance.
    public static let shared: StickyButtonManager = StickyButtonManager()
    
    // MARK: - Properties
    
    /// The `StickyButton` instance.
    open var button: StickyButton {
        return controller.stickyButton
    }
    
    /// A read-only prperty representing the visibility state of window (and the button).
    open var isHidden: Bool {
        return window.isHidden
    }
    
    // MARK: - Private
    
    /// The window on which the view controller will be managed.
    private lazy var window: StickyButtonWindow = {
        let window = StickyButtonWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        return window
    }()
    
    /// The view controller responsible of adding the sticky button to it's view.
    private lazy var controller: StickyButtonViewController = {
        return StickyButtonViewController()
    }()
    
    // MARK: - UI
    
    /// Shows the sticky button over all views.
    open func show() {
        // make sure the window scene is set correctly
        if #available(iOS 13.0, *), window.windowScene == nil {
            let currentWinwdowScene = UIApplication.shared.connectedScenes.first
            window.windowScene = currentWinwdowScene as? UIWindowScene
        }
        window.isHidden = false
    }
    
    /// Hides the sticky button.
    open func hide() {
        window.isHidden = true
    }
    
    /// Toggle the visibility state of the sticky button.
    open func toggle() {
        
        guard window.isHidden else {
            hide()
            return
        }
        
        show()
    }
}
