//
//  CGPoint+SpriteKit.swift
//  SpaceSwift
//
//  Created by Gerrit Grunwald on 26.12.19.
//  Copyright © 2019 Gerrit Grunwald. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    func flipCoordinates() -> CGPoint {
        return CGPoint(x: x, y: UIScreen.main.bounds.height - y)
    }
}
