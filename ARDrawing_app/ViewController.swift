//
//  ViewController.swift
//  ARDrawing_app
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var mSceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        mSceneView.delegate = self
        
        // Show statistics such as fps and timing information
        mSceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        mSceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        mSceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        writingLine(touch: touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        writingLine(touch: touch)
    }
    
    func writingLine(touch: UITouch) {
        let result = mSceneView.hitTest(touch.location(in: mSceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else {return}
        let hitTransform = SCNMatrix4.init(hitResult.worldTransform)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createBall(position: hitVector)
    }
    
    func createBall(position: SCNVector3) {
        var ballShape = SCNSphere(radius: 0.01)
        var ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
        mSceneView.scene.rootNode.addChildNode(ballNode)
    }
    
    @IBAction func removeNode(_ sender: Any) {
        // 全てのNodeに対して処理を行う
        mSceneView.scene.rootNode.enumerateChildNodes {(node, _) in
            // Nodeを削除
            node.removeFromParentNode()
        }
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
