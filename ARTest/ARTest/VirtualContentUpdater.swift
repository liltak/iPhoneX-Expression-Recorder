//
//  VirtualContentUpdater.swift
//  ARTest
//
//  Created by Takuya kato on 2018/07/06.
//  Copyright © 2018 Takuya kato. All rights reserved.
//

import Foundation
import UIKit
import ARKit


class VirtualContentUpdater: NSObject, ARSCNViewDelegate {
    
    //表示 or 更新用
    var virtualFaceNode: VirtualFaceNode? {
        didSet {
            setupFaceNodeContent()
        }
    }
    //セッションを再起動する必要がないように保持用
    private var faceNode: SCNNode?
    private let serialQueue = DispatchQueue(label: "com.example.serial-queue")

    //マスクのセットアップ
    private func setupFaceNodeContent() {
        guard let faceNode = faceNode else { return }
        
        //全ての子ノードを消去
        for child in faceNode.childNodes {
            child.removeFromParentNode()
        }
        //新しいノードを追加
        if let content = virtualFaceNode {
            faceNode.addChildNode(content)
        }
    }
    
    //MARK: - ARSCNViewDelegate
    //新しいARアンカーが設置された時に呼び出される
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        faceNode = node
        serialQueue.async {
            self.setupFaceNodeContent()
        }
    }
    
    //ARアンカーが更新された時に呼び出される
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        virtualFaceNode?.update(withFaceAnchor: faceAnchor) //マスクをアップデートする
        let currentBlendShapes = faceAnchor.blendShapes;
        var strArray = [Float]()
        if blendshape == true{
            //strArray.append("Time")
            //for (index, value) in currentBlendShapes.enumerated() {

                //strArray.append("\(value.key)")
            //}
            //strArray.append("rot[0][0]")
            //strArray.append("rot[0][1]")
            //strArray.append("rot[0][2]")
            //strArray.append("rot[0][3]")
            //strArray.append("rot[1][0]")
            //strArray.append("rot[1][1]")
            //strArray.append("rot[1][2]")
            //strArray.append("rot[1][3]")
            //strArray.append("rot[2][0]")
            //strArray.append("rot[2][1]")
            //strArray.append("rot[2][2]")
            //strArray.append("rot[2][3]")
            //strArray.append("rot[3][0]")
            //strArray.append("rot[3][1]")
            //strArray.append("rot[3][2]")
            //strArray.append("rot[3][3]")
            blendshape = false
            //expressionarray.append(strArray)
        }
        if preview != true{
            var strArray = [Float]()
            strArray.append(Float(time[0]))
            
            for (index, value) in currentBlendShapes.enumerated() {
                strArray.append(Float(value.value))
            }
            let currentTransform = faceAnchor.transform;
            strArray.append(asin(Float(currentTransform[0][1])))
            strArray.append(atan2( Float(currentTransform[0][2]), Float(currentTransform[0][0])))
            strArray.append(atan2(Float(-currentTransform[2][1]), Float(currentTransform[1][1])))
            //strArray.append(currentTransform[3][0])
            //strArray.append(currentTransform[3][1])
            //strArray.append(currentTransform[3][2])
            
            //strArray.append(currentTransform[0][0])
            //strArray.append(currentTransform[0][1])
            //strArray.append(currentTransform[0][2])
            //strArray.append(currentTransform[0][3])
            //strArray.append(currentTransform[1][0])
            //strArray.append(currentTransform[1][1])
            //strArray.append(currentTransform[1][2])
            //strArray.append(currentTransform[1][3])
            //strArray.append(currentTransform[2][0])
            //strArray.append(currentTransform[2][1])
            //strArray.append(currentTransform[2][2])
            //strArray.append(currentTransform[2][3])
            //strArray.append(currentTransform[3][0])
            //strArray.append(currentTransform[3][1])
            //strArray.append(currentTransform[3][2])
            //strArray.append(currentTransform[3][3])
            
            expressionarray.append(strArray)
        }
    }
}
