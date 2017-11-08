//
//  UIView+category.swift
//  UI_Overload
//
//  Created by <https://github.com/NorthDogLi> on 2017/7/31.
//  Copyright © 2017年 <https://github.com/NorthDogLi>. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    public var ND_X : CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
            
        }
    }
    
    public var ND_Y : CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    public var ND_RightX : CGFloat {
        get{
            return self.ND_X + self.ND_Width
        }
        set{
            var rect = self.frame
            rect.origin.x = newValue - self.width
            self.frame = rect
        }
    }
    
    public var ND_LeftX : CGFloat {
        get{
            return self.ND_X
        }
        set{
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    public var ND_Top : CGFloat {
        get{
            return self.ND_Y
        }
        set{
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    public var ND_Bottom : CGFloat {
        get{
            return self.ND_Y + self.ND_Height
        }
        set{
            var rect = self.frame
            rect.origin.y = newValue - self.ND_Height
            self.frame = rect
        }
    }
    
    public var ND_Width : CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    public var ND_Height : CGFloat {
        get{
            return self.frame.size.height
        }
        set{
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    public var ND_CenterX : CGFloat {
        get{
            return self.center.x
        }
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    public var ND_CenterY : CGFloat {
        get{
            return self.center.y
        }
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
    public var ND_Origin : CGPoint {
        get{
            return self.frame.origin
        }
        set{
            var rect = self.frame
            rect.origin = newValue
            self.frame = rect
        }
    }
}
