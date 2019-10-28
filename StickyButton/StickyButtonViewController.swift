//
//  StickyButtonViewController.swift
//  StickyButton
//
//  Created by Achref Marzouki on 24/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit

/// A `UIViewController` subclass responsible for managing the sticky button.
open class StickyButtonViewController: UIViewController {

    // MARK: - Properties
    
    /// The sticky button instance. It's initialized with a default size of `70`.
    public lazy var stickyButton: StickyButton = {
        let button = StickyButton(size: StickyButton.size)
        button.buttonBackgroundColor = .systemOrange
        button.buttonTintColor = .white
        return button
    }()
    
    // MARK: - View life cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // initial settings
        view.addSubview(stickyButton)
    }
}
