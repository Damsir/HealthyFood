
import Foundation
import UIKit

@objc(WCIndicator) class WCIndicator: UIView {
    
    var _layer : CAReplicatorLayer!
    var _imageLayer : CALayer!
    var _gradientLayer : CAGradientLayer!
    var _textLayer : CATextLayer!
    var _image : UIImage!
    var _color : CGColorRef!
    var _textColor : CGColorRef {
        get{
            return self._color
        }
        set{
            self._color = newValue
        }
    }
     var _size : CGFloat!
     var _textSize : CGFloat {
        get{
           return self._size
        }
        set{
            self._size = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置颜色
        self._color = UIColor.orangeColor().CGColor
        self._layer = CAReplicatorLayer()
        self._imageLayer = CALayer()
        self._gradientLayer = CAGradientLayer()
        self._textLayer = CATextLayer()
        self.backgroundColor = UIColor.clearColor()
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start(loadInfo:String?,image:String) {
        
        if self._layer == nil {
            self._layer = CAReplicatorLayer()
            self._imageLayer = CALayer()
            self._gradientLayer = CAGradientLayer()
            self._textLayer = CATextLayer()
        }
        _image = UIImage(named: image)
        //初始化父层背景
        self._layer.masksToBounds = true
        self._layer.bounds = CGRectMake(0, 0, _image.size.width, _image.size.height * 1.5 + 10)
        self._layer.anchorPoint = CGPointMake(0.5, 0.0);
        self._layer.position = CGPointMake(self.frame.size.width/2, 10.0);
        
        //初始化子层图片
        _imageLayer.contentsScale = UIScreen.mainScreen().scale
        _imageLayer.contents = _image.CGImage
        _imageLayer.bounds = CGRectMake(0.0, 0.0, _image.size.width, _image.size.height)
        _imageLayer.anchorPoint = CGPointMake(0, 0)
        _imageLayer.position = CGPointMake(0, 10)
        self._layer.addSublayer(_imageLayer)
        
        //制作父层副本,并设置副本为原始图片倒影
        self._layer.instanceCount = 2;
        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, 1.0, -1.0, 1.0)
        transform = CATransform3DTranslate(transform, 0, -_image.size.height * 2 - 20 , 1.0);
        self._layer.instanceTransform = transform;
        
        //初始化渐变图层
        _gradientLayer.colors = [UIColor.whiteColor().colorWithAlphaComponent(0.25),UIColor.whiteColor().CGColor]
        _gradientLayer.bounds = CGRectMake(0, 0, self._layer.frame.size.width, _image.size.height * 0.5 + 10.0)
        _gradientLayer.cornerRadius = self._layer.frame.size.width / 2 - 10
        _gradientLayer.anchorPoint = CGPointMake(0.5, 0)
        _gradientLayer.position = CGPointMake(self.frame.size.width/2, _image.size.height + 10.0);
        _gradientLayer.zPosition = 1
        _gradientLayer.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(_gradientLayer)
        //设置镜像翻转
        var cover = CABasicAnimation()
        cover.keyPath = "transform"
        cover.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_4 * 1.2), 1.0, 0.0, 0.0))
        cover.removedOnCompletion = false
        cover.fillMode = kCAFillModeForwards
        _gradientLayer.addAnimation(cover, forKey: nil)
        
        //初始化文字图层
        _textLayer.contentsScale = UIScreen.mainScreen().scale
        _textLayer.fontSize = self._size
        _textLayer.foregroundColor = self._color
        _textLayer.alignmentMode = kCAAlignmentCenter
        _textLayer.bounds = CGRectMake(0, 0, _imageLayer.bounds.size.width + 50, 40)
        _textLayer.position = CGPointMake(_imageLayer.frame.size.width/2,_imageLayer.frame.size.height - 10)
        
        self._imageLayer .addSublayer(_textLayer)
        self.userInteractionEnabled = true
        self.layer.addSublayer(self._layer)
        
        var anim = CAKeyframeAnimation()
        anim.keyPath = "transform.translation.y"
        anim.values = [-2,-4,-6,-8,-6,-4,-2]
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        anim.duration = 0.8
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        self._imageLayer.addAnimation(anim, forKey: "shake")
        
       
        _textLayer.string = loadInfo
        var animation = CABasicAnimation()
        animation.keyPath = "position.y"
        var endPoint = _textLayer.frame.size.height - 20
        var distance = _textLayer.frame.origin.y + endPoint
        animation.fromValue = NSNumber(float: Float(distance))
        animation.toValue = NSNumber(float: Float(endPoint))
        animation.duration = 3.0
        animation.repeatCount = MAXFLOAT
        animation.autoreverses = true
        _textLayer .addAnimation(animation, forKey: "updown")
        
    }
    func success(successInfo:String) {
        self._textLayer.string = successInfo
        UIView.animateWithDuration(2.0, delay: 2.0, options:UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self._layer.removeFromSuperlayer()
            self._gradientLayer.removeFromSuperlayer()
            self._layer = nil
            self._gradientLayer = nil
            }) { (finished) -> Void in
                   
            }
    }
    func fail(failInfo:String) {
        self._textLayer.string = failInfo
        self._imageLayer.removeAnimationForKey("shake")
        self._textLayer.removeAnimationForKey("updown")
        self._textLayer.position = CGPointMake(_imageLayer.frame.size.width/2,_imageLayer.frame.size.height/2 + 20)
    }
    
}
