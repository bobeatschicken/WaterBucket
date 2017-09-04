//
//  GameScene.swift
//  WaterBucket
//
//  Created by Christopher Yang on 7/5/16.
//  Copyright (c) 2016 MakeSchool. All rights reserved.
//

import SpriteKit
/* Tracking enum for game state */
enum GameState {
    case Title, Ready, Playing, GameOver
}
/* Game management */
var state: GameState = .Title




class GameScene: SKScene, SKPhysicsContactDelegate {
    var bucket: WaterBucket!
    var droplet: SKSpriteNode!
   // var droplets: [WaterDroplet] = []
    var playButton: MSButtonNode!
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    var lives: Int =  3 {
        didSet {
            livesLabel.text = String(lives)
        }
    }
    let increase = 0.1
    var previousNumber: UInt32? // used in randomNumber()

    override func didMoveToView(view: SKView) {
        scoreLabel = childNodeWithName("scoreLabel") as! SKLabelNode
        bucket = childNodeWithName("bucket") as! WaterBucket
        droplet = childNodeWithName("droplet") as! SKSpriteNode
        livesLabel = childNodeWithName("livesLabel") as! SKLabelNode
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake( 0.0, -1.0);

        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            bucket.position.x = touch.locationInNode(self).x
        }
       
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            bucket.position.x = touch.locationInNode(self).x
        }
    
  //      fall(droplet, fallSpeed: 10)
    }
    func didBeginContact(contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        
        /* Check if either physics bodies was a seal */
        print("Contact was made")

        if contactA.categoryBitMask == 2 || contactB.categoryBitMask == 2 {
            score += 1
            self.physicsWorld.gravity = CGVectorMake( 0.0, -1.0 - CGFloat(increase));
            
            print(CGFloat(increase))
            if lives > 0 {
                spawnDroplets()
            }
        }
        if contactA.categoryBitMask == 3 || contactB.categoryBitMask == 3 {
            lives -= 1
            if lives > 0 {
                spawnDroplets()
            }
        }
    }
    func randomNumber() -> UInt32 {
        var randomNumber = arc4random_uniform(320)
        while previousNumber == randomNumber {
            randomNumber = arc4random_uniform(320)
        }
        previousNumber = randomNumber
        return randomNumber
    }
    func spawnDroplets() {

        droplet.runAction(SKAction.moveTo(CGPointMake(CGFloat(randomNumber()),550), duration: 0))
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    func dropletMove() {
        let action = SKAction.moveToY(0, duration: 5.0)
        droplet.runAction(SKAction.repeatActionForever(action))


    }
}
