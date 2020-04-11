//
//  StickyButtonDelegate.swift
//  StickyButton
//
//  Created by Achref Marzouki on 11/04/2020.
//  Copyright © 2020 Achref Marzouki. All rights reserved.
//

import UIKit

/// A set of a handy methods to handle the `StickyButton` events.
public protocol StickyButtonDelegate: class {
    
    func stickyButtonShouldShowItems() -> Bool
    func stickyButtonWillShowItems()
    func stickyButtonDidShowItems()
    
    func stickyButtonShouldHideItems() -> Bool
    func stickyButtonWillHideItems()
    func stickyButtonDidHideItems()
    
    func stickyButtonShouldChangeSide() -> Bool
    func stickyButtonWillChangeSide()
    func stickyButtonDidChangeSide()
}

// MARK - Stikcy button delegate default implementation

public extension StickyButtonDelegate {
    
    func stickyButtonShouldShowItems() -> Bool { true }
    func stickyButtonWillShowItems() {}
    func stickyButtonDidShowItems() {}
    
    func stickyButtonShouldHideItems() -> Bool { true}
    func stickyButtonWillHideItems() {}
    func stickyButtonDidHideItems() {}
    
    func stickyButtonShouldChangeSide() -> Bool { true }
    func stickyButtonWillChangeSide() {}
    func stickyButtonDidChangeSide() {}
}
