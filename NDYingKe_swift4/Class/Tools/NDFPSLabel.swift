//
//  NDFPSLabel.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/8/30.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit
import YYKit.NSAttributedString_YYText

class NDFPSLabel: UILabel {

    var _link = CADisplayLink.init()
    var _count : Int = 0
    var _lastTime = TimeInterval.init()
    var _font = UIFont.init()
    var _subFont = UIFont.init()
    let _llll = TimeInterval.init()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if frame.size.width == 0 && frame.size.height == 0 {
            //frame.size = CGSize.init(width: 55, height: 20)
        }
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = NSTextAlignment.center
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.7)
        
        _font = UIFont.init(name: "Menlo", size: 14)!
        _subFont = UIFont.init(name: "Menlo", size: 5)!
        _link = CADisplayLink.init(target: self, selector: #selector(tick(link:)))
        _link.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    func tick(link:CADisplayLink) {
        if _lastTime == 0 {
            _lastTime = link.timestamp
            
            return
        }
        
        _count = _count + 1
        let delta = link.timestamp - _lastTime
        if delta < 1 {
            return
        }
        _lastTime = link.timestamp
        let fps:CGFloat = CGFloat(_count) / CGFloat(delta)
        _count = 0
        
        let progress = fps / 60.0
        let color = UIColor.init(hue: 0.27 * (progress - 0.2), saturation: 1, brightness: 0.9, alpha: 1)
        
        let text = NSMutableAttributedString.init(string: String.init(format: "%d FPS", Int(round(fps))))
        text.setColor(color, range: NSMakeRange(0, text.length - 3))
        text.setColor(UIColor.white, range: NSMakeRange(text.length - 3, 3))
        text.font = _font;
        text.setFont(_subFont, range: NSMakeRange(text.length - 4, 1))
        
        self.attributedText = text;
        
    }
    
    deinit {
        _link.invalidate()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize.init(width: 50, height: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
