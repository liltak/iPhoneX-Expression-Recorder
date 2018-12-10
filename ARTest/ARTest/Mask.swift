//
//  Mask.swift
//  ARTest
//
//  Created by Takuya kato on 2018/07/06.
//  Copyright © 2018 Takuya kato. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class Mask: SCNNode, VirtualFaceContent {
    
    init(geometry: ARSCNFaceGeometry) {
        let material = geometry.firstMaterial //初期化
        material?.diffuse.contents = UIColor.gray //マスクの色
        material?.lightingModel = .physicallyBased //オブジェクトの照明のモデル
        
        super.init()
        self.geometry = geometry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    //ARアンカーがアップデートされた時に呼ぶ
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        guard let faceGeometry = geometry as? ARSCNFaceGeometry else { return }
        faceGeometry.update(from: anchor.geometry)
    }
}
