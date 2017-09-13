//
//  UIImageView+NDExtension.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/9/7.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit
import SDWebImage.UIImageView_WebCache
import SDWebImage.SDWebImageDownloader

extension UIImageView {
    
    /**
     请求图片并剪裁
     
     @param url 图片URL
     @param placeHoldImage 占位图
     @param isCircle 是否需要剪裁
     */
    public func setURLImageWithURL(url:URL, placeHoldImage:UIImage, isCircle:Bool) {
        if isCircle {
            self.sd_setImage(with: url, placeholderImage: placeHoldImage.circleImage(), options: .retryFailed) { (image, error, cachetype, imageURL) in
                let resultImage = image?.circleImage()
                // 处理结果图片
                if (resultImage == nil) {
                    return
                }
                self.image = resultImage
            }
            
        }else {
            self.sd_setImage(with: url, placeholderImage: placeHoldImage, options: .retryFailed) { (image, error, cachetype, imageURL) in
                // 处理结果图片
                if (image == nil) {
                    return
                }
                self.image = image
            }
        }
    }
    /**
     图片模糊效果处理
     高斯模糊
     float : 模糊程度
     */
    public func setImageViewBlur(url:URL, float:CGFloat) {
        self.sd_setImage(with: url) { (image, error, cachetype, imageURL) in
            // 处理结果图片
            if (image == nil) {
                return
            }
            self.image = image?.gaussianBlur(blurAmount: float)
        }
    }
    
    /**
      下载图片返回图片并且裁剪  
      返回图片大小
     */
    public func getDownloadImage(urlString:String?, size:@escaping (CGSize) ->() ) {
        SDWebImageDownloader.shared().downloadImage(with: URL.init(string: urlString!), options: .useNSURLCache, progress: nil) { (image, data, error, finished) in
            
            self.image = image//?.circleImage()
            size((image?.size)!)
        }
    }
    
}
