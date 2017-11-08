//
//  UIImage+NDImage.swift
//  NDYingKe_swift4
//
//  Created by <https://github.com/NorthDogLi> on 2017/9/7.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit
import Accelerate.vImage

extension UIImage {
    
    public func circleImage() -> UIImage {
        let size = self.size
        let drawWH = size.width < size.height ? size.width : size.height
        
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(CGSize.init(width: drawWH, height: drawWH))
        // 2. 绘制一个圆形区域, 进行裁剪
        let context = UIGraphicsGetCurrentContext()
        let clipRect = CGRect.init(x: 0, y: 0, width: drawWH, height: drawWH)
        context!.addEllipse(in: clipRect)
        context?.clip();
        
        // 3. 绘制图片
        let drawRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        self.draw(in: drawRect)
        
        // 4. 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext();
        
        return resultImage!;
    }
    
    /** 将当前图片缩放到指定宽度
 
        parameter height: 指定宽度
 
        returns: UIImage，如果本身比指定的宽度小，直接返回
    */
    func scaleImageToWidth(_ width: CGFloat) -> UIImage {
        
        // 1. 判断宽度，如果小于指定宽度直接返回当前图像
        if size.width < width {
            return self
        }
        
        // 2. 计算等比例缩放的高度
        let height = width * size.height / size.width
        
        // 3. 图像的上下文
        let s = CGSize(width: width, height: height)
        // 提示：一旦开启上下文，所有的绘图都在当前上下文中
        UIGraphicsBeginImageContext(s)
        
        // 在制定区域中缩放绘制完整图像
        draw(in: CGRect(origin: CGPoint.zero, size: s))
        
        // 4. 获取绘制结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 6. 返回结果
        return result!
    }
    
    /**
        图片模糊效果处理
        高斯模糊
     */
    func gaussianBlur(blurAmount:CGFloat) -> UIImage {
        //高斯模糊参数(0-1)之间，超出范围强行转成0.5
        var blurAmount = blurAmount
        
        if (blurAmount < 0.0 || blurAmount > 1.0) {
            blurAmount = 0.6
        }
        
        var boxSize = Int(blurAmount * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img = self.cgImage
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        
        let inProvider =  img!.dataProvider
        let inBitmapData =  inProvider!.data
        
        inBuffer.width = vImagePixelCount(img!.width)
        inBuffer.height = vImagePixelCount(img!.height)
        inBuffer.rowBytes = img!.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        
        //手动申请内存
        let pixelBuffer = malloc(img!.bytesPerRow * img!.height)
        
        outBuffer.width = vImagePixelCount(img!.width)
        outBuffer.height = vImagePixelCount(img!.height)
        outBuffer.rowBytes = img!.bytesPerRow
        outBuffer.data = pixelBuffer
        
        var error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
        if (kvImageNoError != error) {
            error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                               UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            if (kvImageNoError != error) {
                error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                                   &outBuffer, nil, vImagePixelCount(0), vImagePixelCount(0),
                                                   UInt32(boxSize), UInt32(boxSize), nil, vImage_Flags(kvImageEdgeExtend))
            }
        }
        
        let colorSpace =  CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data,
                            width: Int(outBuffer.width),
                            height: Int(outBuffer.height),
                            bitsPerComponent: 8,
                            bytesPerRow: outBuffer.rowBytes,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let imageRef = ctx!.makeImage()
        
        //手动申请内存
        free(pixelBuffer)
        
        return UIImage(cgImage: imageRef!)
    }
    
}
