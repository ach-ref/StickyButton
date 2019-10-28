//
//  ViewController.swift
//  StickyButtonExample
//
//  Created by Achref Marzouki on 25/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit
import StickyButton

class ViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var stickyButton: StickyButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial settings
        setupView()
    }

    private func setupView() {
        // text field
        firstTextField.delegate = self
        secondTextField.delegate = self
        
        // just set items
        var stickyButtonItems: [StickyButtonItem] = []
        stickyButtonItems.append(StickyButtonItem(title: "Home", image: UIImage(named: "home")) { item in
            self.view.backgroundColor = .white
            self.present(self.alertConroller(forType: "Home"), animated: true, completion: nil)
        })
        stickyButtonItems.append(StickyButtonItem(title: "I am an item with a title & an icon", image: UIImage(named: "cells")) { item in
            self.view.backgroundColor = .systemGreen
        })
        stickyButton.setMenuItems(stickyButtonItems)
        
        // custom item
        let stickyItem = StickyButtonItem(title: "I am a custom item", image: UIImage(named: "gear")) { item in
            self.view.backgroundColor = .systemPurple
            self.present(self.alertConroller(forType: "Custom"), animated: true, completion: nil)
        }
        stickyItem.titleFontName = "BradleyHandITCTT-Bold"
        stickyItem.titleFontSize = 17
        stickyItem.titleTextColor = .white
        stickyItem.titleBackgroundColor = .systemPurple
        stickyItem.iconBackgroundColor = .systemPurple
        stickyButton.addItem(stickyItem)
        
        // add item with title, icon and handler
        stickyButton.addItem(title: "I am an item without an icon", icon: nil) { item in
            self.view.backgroundColor = .systemRed
            self.present(self.alertConroller(forType: "Without Icon"), animated: true, completion: nil)
        }
    }
    
    // MARK: - Helpers
    
    private func alertConroller(forType type: String) -> UIAlertController {
        let message = "You just tapped the \"\(type)\" button !"
        let alertController = UIAlertController(title: "Sticky Button", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        return alertController
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstTextField {
            secondTextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

