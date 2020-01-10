//
//  ViewController.swift
//  18029192
//
//  Created by rm19adm on 12/12/2019.
//  Copyright © 2019 rm19adm. All rights reserved.
//

import UIKit


protocol subviewDelegate {
    func generateBall()
    func updateBallAngle(currentLocation: CGPoint)
}


class ViewController: UIViewController, subviewDelegate {
    
    var dynamicAnimator:                UIDynamicAnimator!
    var dynamicItemBehavior:            UIDynamicItemBehavior!
    var collisionBehavior:              UICollisionBehavior!
    var birdCollisionBehaviour:         UICollisionBehavior!
    var ballImageArray: [UIImageView]   = []
    var birdViewArray: [UIImageView]    = []
    var scoreX                          = 0
    
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    var vectorX: CGFloat!
    var vectorY: CGFloat!
    
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var Aim: DragImageView!
    

    let birdImageArray = [UIImage(named: "bird1.png")!,
                          UIImage(named: "bird2.png")!,
                          UIImage(named: "bird3.png")!,
                          UIImage(named: "bird4.png")!,
                          UIImage(named: "bird5.png")!,
                          UIImage(named: "bird6.png")!,
                          UIImage(named: "bird7.png")!,
                          UIImage(named: "bird9.png")!,
                          UIImage(named: "bird10.png")!,
                          UIImage(named: "bird11.png")!,
                          UIImage(named: "bird12.png")!,
                          UIImage(named: "bird13.png")!
                          
    ]
    
    
    func updateBallAngle(currentLocation: CGPoint){
        vectorX = currentLocation.x
        vectorY = currentLocation.y
    }
    
    
    func generateBall() {
        let ballImage = UIImageView(image: nil)
        ballImage.image = UIImage(named: "ball")
        ballImage.frame = CGRect(x: W*0.08, y: H*0.47, width: W*0.10, height: H*0.17)
        
        self.view.addSubview(ballImage)
    
        let angleX = vectorX - self.Aim.bounds.midX
        let angleY = vectorY - H*0.5
        
        ballImageArray.append(ballImage)
        dynamicItemBehavior.addItem(ballImage)
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: angleX*5, y: angleY*5), for: ballImage)
        collisionBehavior.addItem(ballImage)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
 
        startUp()
        self.Aim.center.x = self.W * 0.10
        self.Aim.center.y = self.H * 0.50
        Aim.myDelegate = self
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        dynamicItemBehavior = UIDynamicItemBehavior(items: ballImageArray)
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        dynamicAnimator.addBehavior(birdCollisionBehaviour)
        collisionBehavior = UICollisionBehavior(items: [])
        collisionBehavior = UICollisionBehavior(items: ballImageArray)
        //collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.addBoundary(withIdentifier: "LEFTBOUNDARY" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*0.0), to: CGPoint(x: self.W*0.0, y: self.H*1.0))
        collisionBehavior.addBoundary(withIdentifier: "TOPBOUNDARY" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*0.0), to: CGPoint(x: self.W*1.0, y: self.H*0.0))
        collisionBehavior.addBoundary(withIdentifier: "BOTTOMBOUNDARY" as NSCopying, from: CGPoint(x: self.W*0.0, y: self.H*1.0), to: CGPoint(x: self.W*1.0, y: self.H*1.0))
        dynamicAnimator.addBehavior(collisionBehavior)
       
    }
         
    override func didReceiveMemoryWarning() {
                   super.didReceiveMemoryWarning()
    }

    
    func createBirdImage(){
        let number = 5
        let birdSize = Int(self.H)/number-2
                   

        for index in 0...1000{
            let when = DispatchTime.now() + (Double(index)/2)
            DispatchQueue.main.asyncAfter(deadline: when) {
                               
                while true {
                                   
                    let randomHeight = Int(self.H)/number * Int.random(in: 0...number)
                    let birdView = UIImageView(image: nil)
                                   
                    birdView.image = self.birdImageArray.randomElement()
                    birdView.frame = CGRect(x: self.W-CGFloat(birdSize), y:  CGFloat(randomHeight), width: CGFloat(birdSize),
                    height: CGFloat(birdSize))
                                   
                    self.view.addSubview(birdView)
                    self.view.bringSubviewToFront(birdView)
                                   
                    for anyBirdView in self.birdViewArray {
                        if birdView.frame.intersects(anyBirdView.frame) {
                            birdView.removeFromSuperview()
                            continue
                        }
                    }
                                   
                    self.birdViewArray.append(birdView)
                    break;
                }
            }
        }
    }

        
    func startUp(){
            
        Score.text = "Score: " + String(scoreX)
            
        self.createBirdImage()
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
            
        Aim.frame = CGRect(x:W*0.02, y: H*0.4, width: W*0.2, height: H*0.2)
        Aim.myDelegate = self
            
        birdCollisionBehaviour = UICollisionBehavior(items: birdViewArray)
            
        self.birdCollisionBehaviour.action = {
            for ballView in self.ballImageArray {
                for birdView in self.birdViewArray {
                    let index = self.birdViewArray.firstIndex(of: birdView)
                    if ballView.frame.intersects(birdView.frame) {
                            birdView.removeFromSuperview()
                            self.birdViewArray.remove(at: index!)
                    }
                        
                    if self.birdViewArray.contains(birdView) == false {
                    self.scoreX = self.scoreX + 1
                       
                    }
                }
            }
                
            self.Score.text = "Score: " + String(self.scoreX)
        }
            
        dynamicAnimator.addBehavior(birdCollisionBehaviour)
    }
    
}

