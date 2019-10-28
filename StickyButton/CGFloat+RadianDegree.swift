//
//  CGFloat+RadianDegree.swift
//  StickyButton
//
//  Created by Achref Marzouki on 23/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit

extension CGFloat {
    
    var radianValue: CGFloat {
        return self * .pi / 180
    }
    
    var degreeValue: CGFloat {
        return self * 180 / .pi
    }
}
