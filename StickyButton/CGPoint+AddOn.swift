//
//  File.swift
//  StickyButton
//
//  Created by Achref Marzouki on 27/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit

extension CGPoint {
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}
