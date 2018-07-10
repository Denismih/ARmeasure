//
//  ViewController.swift
//  ARmeasure
//
//  Created by Admin on 09.07.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var target: UIView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    var firstBox : SCNNode?
    var secondBox : SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func setPoint(_ sender: Any) {
        if firstBox == nil {
            firstBox = addBox()
            btn.setTitle("Set End Point", for: .normal)
        } else if secondBox == nil {
            secondBox = addBox()
            
            if secondBox != nil {
                calcDistance()
                btn.setTitle("Reset", for: .normal)
            }
        } else {
            firstBox?.removeFromParentNode()
            firstBox?.removeFromParentNode()
            firstBox = nil
            secondBox = nil
            btn.setTitle("Set Start Point", for: .normal)
            
        }
    }
    
    func calcDistance() {
        if let firstBox = firstBox {
            if let secondBox = secondBox {
                let vector = SCNVector3Make(secondBox.position.x - firstBox.position.x, secondBox.position.z - firstBox.position.z, secondBox.position.z - firstBox.position.z)
                let dist = sqrt(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)
                self.result.text = "\(dist)m"
            }
        }
    }
    
    func addBox() -> SCNNode? {
        let userTouch = sceneView.center
        let testResults = sceneView.hitTest(userTouch, types: .featurePoint)
        if let res = testResults.first {
            let box = SCNBox(width: 0.005, height: 0.005, length: 0.005, chamferRadius: 0.005)
            let matirial = SCNMaterial()
            matirial.diffuse.contents = UIColor.green
            box.firstMaterial = matirial
            
            let node = SCNNode(geometry: box)
            node.position = SCNVector3(res.worldTransform.columns.3.x,res.worldTransform.columns.3.y,res.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(node)
            return node
        }
        return nil
    }
}
