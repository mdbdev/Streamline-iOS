//
//  AKModalView.swift
//  Streamline
//
//  Created by Vineeth Yeevani on 10/28/17.
//  Copyright © 2017 Stephen Jayakar. All rights reserved.
//

//
//  AKModalView.swift
//  AKModalView
//
//  Created by Akkshay Khoslaa on 7/20/16.
//  Copyright © 2016 Akkshay Khoslaa. All rights reserved.
//

import UIKit
import Spring

public enum ShowAnimation {
    case SlideFromBottom
    case SlideFromTop
    case SlideFromLeft
    case SlideFromRight
    case FadeIn
}

public enum DismissAnimation {
    case SlideToBottom
    case SlideToTop
    case SlideToLeft
    case SlideToRight
    case FadeOut
}

class AKModalView: UIView {
    
    //Public variables (settings)
    var dismissOnBackgroundTap = true
    var dismissCompletion: (() -> Void)?
    var showCompletion: (() -> Void)?
    var overlayColor = UIColor.black.withAlphaComponent(0.65)
    var showAnimation = ShowAnimation.SlideFromBottom
    var dismissAnimation = DismissAnimation.SlideToBottom
    var showAnimationDuration = 0.4
    var dismissAnimationDuration = 0.4
    var dismissEnabled = true
    var automaticallyCenter = true
    
    //Private variables
    private var overlay: UIView!
    private var modalView: UIView!
    
    // MARK: Public Methods
    
    init(view: UIView) {
        super.init(frame: view.frame)
        modalView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        overlay                 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlay.backgroundColor = overlayColor
        if dismissOnBackgroundTap {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AKModalView.dismiss))
            overlay.addGestureRecognizer(tapGesture)
        }
        overlay.alpha = 0
        superview!.addSubview(overlay)
        superview?.bringSubview(toFront: overlay)
        
        SpringAnimation.springWithCompletion(duration: 0.2, animations: { _ in
            self.overlay.alpha = 1
        }, completion: { _ -> Void in
            if self.showAnimation == .SlideFromBottom {
                self.slideFromBottom()
            } else if self.showAnimation == .SlideFromTop {
                self.slideFromTop()
            } else if self.showAnimation == .SlideFromLeft {
                self.slideFromLeft()
            } else if self.showAnimation == .SlideFromRight {
                self.slideFromRight()
            } else if self.showAnimation == .FadeIn {
                self.fadeIn()
            }
        })
        
    }
    
    func dismiss() {
        if !dismissEnabled {
            return
        }
        if dismissAnimation == .SlideToBottom {
            slideToBottom()
        } else if dismissAnimation == .SlideToTop {
            slideToTop()
        } else if dismissAnimation == .SlideToRight {
            slideToRight()
        } else if dismissAnimation == .SlideToLeft {
            slideToLeft()
        } else if dismissAnimation == .FadeOut {
            fadeOut()
        }
    }
    
    // MARK: Private Methods
    
    private func slideFromBottom() {
        modalView.frame.origin.y = superview!.frame.maxY
        superview?.addSubview(modalView)
        superview?.bringSubview(toFront: modalView)
        SpringAnimation.springWithCompletion(duration: showAnimationDuration, animations: { _ in
            if self.automaticallyCenter {
                self.modalView.center = (self.superview?.center)!
            } else {
                self.modalView.frame.origin.y = self.frame.minY
            }
            
        }, completion: { _ -> Void in
            if self.showCompletion != nil {
                self.showCompletion!()
            }
        })
    }
    
    private func slideFromTop() {
        modalView.frame.origin.y = -modalView.frame.height
        superview?.addSubview(modalView)
        superview?.bringSubview(toFront: modalView)
        SpringAnimation.springWithCompletion(duration: showAnimationDuration, animations: { _ in
            self.modalView.center = (self.superview?.center)!
        }, completion: { _ -> Void in
            if self.showCompletion != nil {
                self.showCompletion!()
            }
        })
    }
    
    private func slideFromLeft() {
        modalView.frame.origin.x = -modalView.frame.width
        modalView.frame.origin.y = (superview?.center.y)!
        superview?.addSubview(modalView)
        superview?.bringSubview(toFront: modalView)
        SpringAnimation.springWithCompletion(duration: showAnimationDuration, animations: { _ in
            self.modalView.center = (self.superview?.center)!
        }, completion: { _ -> Void in
            if self.showCompletion != nil {
                self.showCompletion!()
            }
        })
    }
    
    private func slideFromRight() {
        modalView.frame.origin.x = (superview?.frame.width)!
        modalView.frame.origin.y = (superview?.center.y)!
        superview?.addSubview(modalView)
        superview?.bringSubview(toFront: modalView)
        SpringAnimation.springWithCompletion(duration: showAnimationDuration, animations: { _ in
            self.modalView.center = (self.superview?.center)!
        }, completion: { _ -> Void in
            if self.showCompletion != nil {
                self.showCompletion!()
            }
        })
    }
    
    private func fadeIn() {
        modalView.center = (superview?.center)!
        modalView.alpha = 0
        superview?.addSubview(modalView)
        superview?.bringSubview(toFront: modalView)
        SpringAnimation.springWithCompletion(duration: showAnimationDuration, animations: { _ in
            self.modalView.alpha = 1
        }, completion: { _ -> Void in
            if self.showCompletion != nil {
                self.showCompletion!()
            }
        })
    }
    
    private func slideToBottom() {
        SpringAnimation.springWithCompletion(duration: dismissAnimationDuration, animations: { _ in
            self.modalView.frame.origin.y = (self.superview?.frame.height)!
            self.overlay.alpha = 0
            
        }, completion: { _ -> Void in
            self.overlay.removeFromSuperview()
            self.modalView.removeFromSuperview()
            self.removeFromSuperview()
            if self.dismissCompletion != nil {
                self.dismissCompletion!()
            }
        })
    }
    
    private func slideToTop() {
        SpringAnimation.springWithCompletion(duration: dismissAnimationDuration, animations: { _ in
            self.modalView.frame.origin.y = -self.modalView.frame.height
            self.overlay.alpha = 0
        }, completion: { _ -> Void in
            self.overlay.removeFromSuperview()
            self.modalView.removeFromSuperview()
            self.removeFromSuperview()
            if self.dismissCompletion != nil {
                self.dismissCompletion!()
            }
        })
    }
    
    private func slideToRight() {
        SpringAnimation.springWithCompletion(duration: dismissAnimationDuration, animations: { _ in
            self.modalView.frame.origin.x = (self.superview?.frame.width)!
            self.overlay.alpha = 0
        }, completion: { _ -> Void in
            self.overlay.removeFromSuperview()
            self.modalView.removeFromSuperview()
            self.removeFromSuperview()
            if self.dismissCompletion != nil {
                self.dismissCompletion!()
            }
        })
    }
    
    private func slideToLeft() {
        SpringAnimation.springWithCompletion(duration: dismissAnimationDuration, animations: { _ in
            self.modalView.frame.origin.x = -self.modalView.frame.width
            self.overlay.alpha = 0
        }, completion: { _ -> Void in
            self.overlay.removeFromSuperview()
            self.modalView.removeFromSuperview()
            self.removeFromSuperview()
            if self.dismissCompletion != nil {
                self.dismissCompletion!()
            }
        })
    }
    
    private func fadeOut() {
        SpringAnimation.springWithCompletion(duration: dismissAnimationDuration, animations: { _ in
            self.modalView.alpha = 0
            self.overlay.alpha = 0
        }, completion: { _ -> Void in
            self.overlay.removeFromSuperview()
            self.modalView.removeFromSuperview()
            self.removeFromSuperview()
            if self.dismissCompletion != nil {
                self.dismissCompletion!()
            }
        })
    }
    
}
