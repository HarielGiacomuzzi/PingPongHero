//
//  GameController.swift
//  PingPongHero
//
//  Created by bruno raupp kieling on 7/20/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreMotion

class GameController: UIViewController {
    
    var timer1 = NSTimer()
    var timer2 = NSTimer()
    var queue = NSOperationQueue()
    lazy var motionManager = CMMotionManager()
    var hit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkForHit"), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func checkForHit() {
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timeToHitFinished"), userInfo: nil, repeats: false)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler:
            {data, error in
                if (data.userAcceleration.z > 0.5 || data.userAcceleration.z < -0.5) && data.gravity.x < 0 {
                    self.motionManager.stopDeviceMotionUpdates()
                    println(data.userAcceleration.z)
                    self.hit = true
                }
                
        })
        
    }
    
    func timeToHitFinished() {
        if(!hit){
            motionManager.stopDeviceMotionUpdates()
        }else {
            hit = false
            didHitBall()
            
        }
    }
    
    func didHitBall() {
        if timer2.valid {
            timer1.invalidate()
            timer2.invalidate()
            sendBall()
        } else {
            timer1.invalidate()
            timer2.invalidate()
        }
        
    }
    
    func sendBall() {
        timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkForHit"), userInfo: nil, repeats: false)
    }
    
}