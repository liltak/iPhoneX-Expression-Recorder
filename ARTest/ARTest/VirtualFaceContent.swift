//
//  VirtualFaceContent.swift
//  ARTest
//
//  Created by Takuya kato on 2018/07/06.
//  Copyright © 2018 Takuya kato. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

protocol VirtualFaceContent {
    func update(withFaceAnchor: ARFaceAnchor)
}

typealias VirtualFaceNode = VirtualFaceContent & SCNNode
