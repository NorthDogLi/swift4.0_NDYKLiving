//
//  NDTools.swift
//  UI_Overload
//
//  Created by 李家奇_南湖国旅 on 2017/8/1.
//  Copyright © 2017年 李家奇_南湖国旅. All rights reserved.
//

import UIKit

class NDTools: NSObject {
    
    
    //单例创建
    static let shareTool : NDTools = {
        let Tool = NDTools()
        
        return Tool
    }()
    public var isShowBar : Bool = true
    
    //获取当前时间
    func getDate() -> String{
        let dateFormat = DateFormatter.init()
        dateFormat.dateFormat = "yyyy.MM.dd"
        
        let date = NSDate.init()
        let dateString = dateFormat.string(from: date as Date)
        
        return dateString
    }
    
    /**
     text：正则表达式
     matcherStr:需要进行判断的字符串
     */
    func containsBOOL(text : NSString, matcherStr : String) -> Bool {
        let mailPattern = text
        let matcher = MyRegex(mailPattern as String)
        
        if matcher.match(input: matcherStr) {
            return true
        }else{
            return false
        }
    }

    //MARK: 正则--->密码的强度必须是包含大小写字母和数字的组合，不能使用特殊字符，长度在6,13之间。
    func containsPassword(password : String) -> Bool {
        
        return containsBOOL(text: "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,13}$", matcherStr: password)
    }
    
    
    //MARK: 正则--->字符串仅能是中文。
    func containsUTF8_china(text : String) -> Bool{
        
        return containsBOOL(text:"^[\\u4e00-\\u9fa5]{0,}$", matcherStr: text)
    }
    
    
    //MARK: 正则--->身份证判断
    func validateIdCard(cardtext : String) -> Bool {
        
        return containsBOOL(text:"^(\\d{14}|\\d{17})(\\d|[xX])$", matcherStr: cardtext)
    }
    
    
    //MARK: 正则--->手机号判断
    func validateContactNumber(mobileNum:String) -> Bool {
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700
         */
        let MOBILE = containsBOOL(text: "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$", matcherStr: mobileNum)
        
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        let CM = containsBOOL(text:"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)", matcherStr: mobileNum
        )
        /**
         * 中国联通：China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        let CU = containsBOOL(text:"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)", matcherStr: mobileNum)
        
        /**
         * 中国电信：China Telecom
         * 133,153,180,181,189,177,1700
         */
        let CT = containsBOOL(text: "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)", matcherStr: mobileNum)
        
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        let PHS = containsBOOL(text: "^(0\\d{2}-\\d{8}(-\\d{1,4})?)|(0\\d{3}-\\d{7,8}(-\\d{1,4})?)$", matcherStr: mobileNum)
        
        if  MOBILE==true ||
            CM==true ||
            CU==true ||
            CT==true ||
            PHS==true {
            
            return true
        }else {
            return false
        }
    }
    
    //MARK: 指定起始点和终点画线
    func drawLineLayerWithStartPoint(startPoint : CGPoint, endPonint: CGPoint, color : UIColor) -> CAShapeLayer {
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPonint)
        linePath.close()
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = 0.5
        lineLayer.strokeColor = color.cgColor
        
        return lineLayer
    }
    
    //MARK:  颜色转化成Image对象
    func imageWithColor(color : UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    /**
     *返回值是该字符串所占的大小(width, height)
     *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
     *maxSize : 
     为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT,
     如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
     */
    //MARK:返回值是该字符串所占的大小(width, height)
    func sizeWithFont(font : UIFont, width : CGFloat, text : String) -> CGSize {
        
        let attrs:NSDictionary = [NSFontAttributeName : font]
        
        let size = CGSize.init(width: width, height: CGFloat(MAXFLOAT))
        
        return text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs as? [String : Any], context: nil).size
    }
    
    //MARK: 根据URL生成二维码，并以image形式返回
    func getNDQRCodeimage(URLString:String, iconName:String?) -> UIImage {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        /// allowLossyConversion 在转换过程中是否可以移除或者改变字符
        let data = URLString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        filter?.setValue(data, forKey: "inputMessage")
        /// L M Q H 修正等级，应该跟采样有关
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let outputImage = filter?.outputImage
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1, alpha: 0), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 10, y: 10))))
        //中间放logo
        if let icon_name = iconName {
            
            if let iconImage = UIImage(named: icon_name) {
                
                let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
                UIGraphicsBeginImageContext(rect.size)
                codeImage.draw(in: rect)
                let avatarSize = CGSize(width: rect.size.width*0.15, height: rect.size.height*0.15)
                
                let x = (rect.width - avatarSize.width) * 0.5
                let y = (rect.height - avatarSize.height) * 0.5
                iconImage.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
                
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return resultImage!
            }
        }
        
        return codeImage
    }
    
    
    //MARK: 颜色生成图片
    func colorWithImage(color:UIColor, size:CGSize) -> UIImage {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //MARK: 获得当前日期 matter=""默认格式为YYYY-MM-dd 否则为matter
    func getDate(matter:String?) -> String {
        let matter = matter
        
        let currentDate = NSDate.init()
        let formatter = DateFormatter.init()
        formatter.dateFormat = matter=="" ? "YYYY-MM-dd":matter
        
        formatter.locale = NSLocale.init(localeIdentifier: "zh_CN") as Locale!
        let dateString = formatter.string(from: currentDate as Date)
        
        return dateString;
    }
    
    
}

//正则匹配
struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
