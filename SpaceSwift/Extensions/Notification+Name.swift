//
//  Notification+Name.swift
//  SpaceSwift
//
//  Created by Gerrit Grunwald on 04.01.20.
//  Copyright © 2020 Gerrit Grunwald. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var moveToGameOverScene: Notification.Name {
        return .init(rawValue: "GameScene.moveToGameOverScene")
    }

    static var moveToStartScene: Notification.Name {
        return .init(rawValue: "GameOverScene.moveToStartScene")
    }

    static var moveToGameScene: Notification.Name {
        return .init(rawValue: "StartScene.moveToGameScene")
    }
}
