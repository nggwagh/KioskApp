//
//  KioskTimedApplication.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 29/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation

import UIKit

extension Notification.Name {
    
    static let appIsIdle = Notification.Name("appTimeout")
    static let appDetectedUserTouch = Notification.Name("appDetectedUserTouch")
    static let appIsIdleOnQuestionaire = Notification.Name("appTimeoutForQuestionaire")
}

class KioskTimedApplication: UIApplication {
    
    override init() {
        super.init()
        resetIdleTimer()
    }
    
    // the timeout in seconds, after which should perform custom actions
    // such as disconnecting the user
    private var timeoutInSeconds: TimeInterval {
        // 2 minutes
//        return 30;
        return 5 * 60
    }
    
    // the timeout in seconds for Questionaire, after which should perform custom actions
    // such as disconnecting the user
    private var timeoutForQuestionaireInSeconds: TimeInterval {
        return 40
    }
    
    private var idleTimer: Timer?
    private var idleTimerForQuestionaire: Timer?
    
    // resent the timer because there was user interaction
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        
        if let idleTimerForQuestionaire = idleTimerForQuestionaire {
            idleTimerForQuestionaire.invalidate()
        }
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(KioskTimedApplication.timeHasExceeded),
                                         userInfo: nil,
                                         repeats: false)
            
        idleTimerForQuestionaire = Timer.scheduledTimer(timeInterval: timeoutForQuestionaireInSeconds,
                                             target: self,
                                             selector: #selector(KioskTimedApplication.timeHasExceededForQuestionaire),
                                             userInfo: nil,
                                             repeats: false)
    }
    
    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    @objc private func timeHasExceeded() {
        NotificationCenter.default.post(name: .appIsIdle, object: nil)
    }
    
    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    @objc private func timeHasExceededForQuestionaire() {
        NotificationCenter.default.post(name: .appIsIdleOnQuestionaire, object: nil)
    }
    
    override func sendEvent(_ event: UIEvent) {
        
        super.sendEvent(event)
        
        NotificationCenter.default.post(name: .appDetectedUserTouch, object: nil)
        
        if idleTimer != nil {
            self.resetIdleTimer()
        }
        
        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouchPhase.began {
                self.resetIdleTimer()
            }
        }
    }
}
