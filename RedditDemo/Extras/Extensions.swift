//
//  Extensions.swift
//  RedditDemo
//
//  Created by Muhammad Usman on 22/10/2021.
//

import Foundation
import UIKit
import Kingfisher
import PocketSVG
import SwiftyGif

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func createContainer(image: UIImage?, textField: UITextField) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = image
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        textField.centerY(inView: view)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        view.addSubview(seperatorView)
        seperatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        return view
        
        
        
    }
    
    
}

extension UIView{
    static var typeName: String {
        return String(describing: self)
    }
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController{
    static var typeName: String {
        return String(describing: self)
    }
    static var identifier: String {
        return String(describing: self)
    }

    func pushView(_ vc:UIViewController?,_ isAnimated:Bool = true,isFromTabControllerPush:Bool = false){
        if let vc = vc {
            if(isFromTabControllerPush){
                if let tabVc = self.tabBarController{
                    tabVc.navigationController?.pushViewController(vc, animated: isAnimated)
                }else{
                    self.navigationController?.pushViewController(vc, animated: isAnimated)
                }
            }else{
                self.navigationController?.pushViewController(vc, animated: isAnimated)
            }
        }
    }

}

extension UIImageView{
    
    func loadGif(url:URL?,placeholder:PlaceHolder,mode:ContentMode = .scaleAspectFill,showBadge:Bool = false){
        self.kf.indicatorType = .activity
        //        print("Link : \(url?.absoluteString ?? "")")
        self.contentMode = mode
        self.superview?.subviews.forEach({ (items) in
            if items.tag == 21212 {
                items.isHidden = !showBadge
            }
        })
        let ext = url?.getFileExtension()
        if ext?.contains("gif") ?? false{
            var loader : UIActivityIndicatorView!
            if #available(iOS 13.0, *) {
                loader = UIActivityIndicatorView(style: .medium)
            } else {
                loader = UIActivityIndicatorView.init(style: .whiteLarge)
                // Fallback on earlier versions
            }
            self.image = placeholder.image
            self.setGifFromURL(url!, customLoader: loader)
        }
        else if ext?.contains("svg") ?? false{
            let processor = SVGProcessor(size: self.frame.size)
            self.kf.setImage(
                with: url,
                placeholder: placeholder.image,
                options: [
                    .processor(processor),
                    .downloader(KingFisherImage.shared.downloader),
                    .requestModifier(KingFisherImage.shared.modifier),
                    .alsoPrefetchToMemory,
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.none),
                    .cacheOriginalImage
                ])
        }else{
            //            let processor = DownsamplingImageProcessor(size: self.frame.size)
            //                |> RoundCornerImageProcessor(cornerRadius: 0)
            if let link = url {
                let cacheResult = ImageCache.default.imageCachedType(forKey: link.absoluteString)
                switch cacheResult.cached {
                case true:
                    ImageCache.default.retrieveImage(forKey: link.absoluteString) { (result) in
                        switch result {
                        case .success(_):
                            self.kf.setImage(
                                with: link,
                                placeholder: placeholder.image,
                                options: [
                                    .downloader(KingFisherImage.shared.downloader),
                                    .requestModifier(KingFisherImage.shared.modifier),
                                    .alsoPrefetchToMemory,
                                    //                                    .processor(processor),
                                    .scaleFactor(UIScreen.main.scale),
                                    .transition(.none),
                                    .cacheOriginalImage
                                ],completionHandler:{ result in
                                    switch result{
                                        
                                    case .success(let data):
                                        self.image = data.image
                                    case .failure://(let error)
                                        break
                                        //                                        print("Link : \(url?.absoluteString ?? "") , \(error.errorDescription ?? "")")
                                    }
                                    
                                })
                        case .failure(_):
                            let resource = ImageResource(downloadURL: link, cacheKey: link.absoluteString)
                            self.kf.setImage(with: resource,placeholder: placeholder.image,
                                             options: [
                                                .downloader(KingFisherImage.shared.downloader),
                                                .requestModifier(KingFisherImage.shared.modifier),
                                                .alsoPrefetchToMemory,
                                                //                                                .processor(processor),
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.none),
                                                .cacheOriginalImage
                                             ],completionHandler:{ result in
                                                 switch result{
                                                     
                                                 case .success(let data):
                                                     self.image = data.image
                                                 case .failure://(let error)
                                                     break
                                                     //                                                    print("Link : \(url?.absoluteString ?? "") , \(error.errorDescription ?? "")")
                                                 }
                                                 
                                             })
                        }
                    }
                case false:
                    self.kf.setImage(
                        with: link,
                        placeholder: placeholder.image,
                        options: [
                            .downloader(KingFisherImage.shared.downloader),
                            .requestModifier(KingFisherImage.shared.modifier),
                            .alsoPrefetchToMemory,
                            //                            .processor(processor),
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.none),
                            .cacheOriginalImage
                        ],completionHandler:{ result in
                            switch result{
                                
                            case .success(let data):
                                self.image = data.image
                            case .failure://(let error)
                                break
                                //                                print("Link : \(url?.absoluteString ?? "") , \(error.errorDescription ?? "")")
                            }
                            
                        })
                    
                }
            }else{
                self.image = placeholder.image
            }
        }
        
    }
}

struct SVGProcessor: ImageProcessor {
    
    // `identifier` should be the same for processors with the same properties/functionality
    // It will be used when storing and retrieving the image to/from cache.
    let identifier = "svgprocessor"
    var size: CGSize!
    init(size: CGSize) {
        self.size = size
    }
    // Convert input data/image to target image and return it.
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            //            print("already an image")
            return image
        case .data(let data):
            //            print("svg string")
            if let svgString = String(data: data, encoding: .utf8){
                //let layer = SVGLayer(
                let path = SVGBezierPath.paths(fromSVGString: svgString)
                let layer = SVGLayer()
                layer.paths = path
                let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                layer.frame = frame
                let img = self.snapshotImage(for: layer)
                return img
            }
            return nil
        }
    }
    func snapshotImage(for view: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class KingFisherImage {
    static let shared = KingFisherImage()
    let modifier = AnyModifier { request in
        var r = request
        //        r.
        //        request.hos
        //        r.
        //        r.setValue("Bearer \(DataManager.sharedInstance.getPermanentlySavedUser()?.token ?? "")", forHTTPHeaderField: "Authorization")
        return r
    }
    var downloader:ImageDownloader {
        get{
            let downl = KingfisherManager.shared.downloader
            downl.trustedHosts = Set([APIConstants.BaseIp])
            return downl
        }
    }
}

enum PlaceHolder:String{
    case BannerImage = "banner_image"
    var image:UIImage? {
        UIImage.init(named: self.rawValue) ?? UIColor.gray.image()
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    
    @IBInspectable
    var shadowColorOverAll: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
                self.setNeedsLayout()
            }
        }
    }
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func fadeIn(duration: TimeInterval = 0.2) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.alpha = 1.0
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    func fadeOutHide(duration: TimeInterval = 0.2) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.alpha = 0.0
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomIn(_ duration: TimeInterval = 0.2) {
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    func Blinking(duration: TimeInterval = 0.8) {
        let alpha = self.alpha
        if alpha == 1.0 {
            self.alpha = 1.0
        }else{
            self.alpha = 0.1
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            if alpha == 1.0 {
                self.alpha = 0.1
            }else{
                self.alpha = 1.0
            }
        }) { (animationCompleted: Bool) -> Void in
            self.Blinking()
        }
    }
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomOut(_ duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
            self.isHidden = true
        }
    }
    
    func zoomInImage(duration: TimeInterval = 0.2) {
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = (delegate as! CAAnimationDelegate)
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTanslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }
    
    static func loadFromXib<T>(withOwner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: withOwner, options: (options as? [UINib.OptionsKey : Any])).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func round(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    func keepCenterAndApplyAnchorPoint(_ point: CGPoint) {
        
        guard layer.anchorPoint != point else { return }
        
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var c = layer.position
        c.x -= oldPoint.x
        c.x += newPoint.x
        
        c.y -= oldPoint.y
        c.y += newPoint.y
        
        layer.position = c
        layer.anchorPoint = point
    }
    
    func viewCenter(usePresentationLayerIfPossible: Bool) -> CGPoint {
        if usePresentationLayerIfPossible, let presentationLayer = layer.presentation() {
            return presentationLayer.position
        }
        return center
    }
    
    var screenWidth:CGFloat {
        get {
            DataManager.sharedInstance.getScreenWidth()//return UIScreen.main.bounds.height
        }
        set(newValue) {
            DataManager.sharedInstance.setScreenWidth(value: newValue)
        }
    }
    
    var screenHeight:CGFloat {
        get {
            DataManager.sharedInstance.getScreenHeight()//return UIScreen.main.bounds.height
        }
        set(newValue) {
            DataManager.sharedInstance.setScreenHeight(value: newValue)
        }
    }
    
    func hideView(){
        self.isHidden = true
    }
    
    func showView(){
        self.isHidden = false
    }
    
    
    
    
    //MARK: Set multi Color text
    func setAtterText(mainString : String? , attributedStringsArray : [String?]  , color : [UIColor?], attFont:[UIFont?],isUnderLine:[Bool]) {
        let attributedString1    = NSMutableAttributedString(string: mainString ?? "")
        for (index,objStr) in attributedStringsArray.enumerated() {
            let range1 = (mainString as NSString?)?.range(of: objStr ?? "") ?? .init()
            let attribute_font = [NSAttributedString.Key.font: attFont[index] ?? UIFont.systemFont(ofSize: CGFloat(12))]
            attributedString1.addAttributes(attribute_font, range:  range1)
            attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: color[index] ?? UIColor.clear, range: range1)
            if(isUnderLine[index]){
                attributedString1.addAttribute(NSAttributedString.Key.underlineColor, value: color[index] ?? UIColor.clear, range: range1)
                attributedString1.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range1)
                attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: color[index] ?? UIColor.clear, range: range1)
                attributedString1.addAttribute(NSAttributedString.Key.strokeColor, value: color[index] ?? UIColor.clear, range: range1)
                attributedString1.addAttribute(NSAttributedString.Key.underlineColor, value: color[index] ?? UIColor.clear, range: range1)
                
            }
        }
        if(self.isKind(of: UILabel.self)) {
            (self as! UILabel).attributedText = attributedString1
        }
        if(self.isKind(of: UITextView.self)) {
            (self as! UITextView).attributedText = attributedString1
        }
        if(self.isKind(of: UITextField.self)) {
            (self as! UITextField).attributedText = attributedString1
        }
        if(self.isKind(of: UIButton.self)) {
            (self as! UIButton).setAttributedTitle(attributedString1, for: .normal)
        }
    }
    
    enum AnimationKeyPath: String {
        case opacity = "opacity"
    }
    
    func flash(animation: AnimationKeyPath ,withDuration duration: TimeInterval = 0.5, repeatCount: Float = 5){
        let flash = CABasicAnimation(keyPath: AnimationKeyPath.opacity.rawValue)
        flash.duration = duration
        flash.fromValue = 1 // alpha
        flash.toValue = 0 // alpha
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = repeatCount
        
        layer.add(flash, forKey: nil)
    }
    
    func fadeInNew(_ duration: TimeInterval = 0.7,_ delay: TimeInterval = 0.7) {
        UIView.animate(withDuration: duration, delay: delay, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: {
            self.alpha = 0.7
        }, completion: { isDone in
            self.fadeOutNew()
        })
    }
    
    func fadeOutNew(_ duration: TimeInterval = 0.7,_ delay: TimeInterval = 0.7) {
        UIView.animate(withDuration: duration, delay: delay, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: {
            self.alpha = 1
        }, completion: { isDone in
            self.fadeInNew()
        })
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius//vCornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //            vCornerRadius = newValue
            self.setNeedsLayout()
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth//vBorderWidth
        }
        set {
            layer.borderWidth = newValue
            //            vBorderWidth = newValue
            self.setNeedsLayout()
            
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds//vMasksToBounds
        }
        set {
            layer.masksToBounds = newValue
            //            vMasksToBounds = newValue
            self.setNeedsLayout()
            
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get{
            
            return UIColor.init(cgColor: layer.borderColor ?? UIColor.clear.cgColor)//vBorderColour
        }
        set {
            
            layer.borderColor = newValue?.cgColor
            //            vBorderColour = newValue
            self.setNeedsLayout()
            
        }
    }
    
    
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
                self.setNeedsLayout()
            }
        }
    }
    
    func centerInSuperview() {
        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
        self.setNeedsLayout()
        
    }
    
    func equalAndCenterToSupper() {
        
        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
        leadingInSuperview()
        trailingInSuperview()
        topInSuperview()
        bottomInSuperview()
        self.setNeedsLayout()
        
        
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func centerHorizontallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    func centerVerticallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    func leadingInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.leadingMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    func trailingInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.trailingMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    func topInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.topMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    func bottomInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute:.bottomMargin, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    class func fromNib<T : UIView>() -> T {
        
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func  setAttributedTextForLabelAll(mainString : String? , attributedStringsArray : [String?]  , color : [UIColor?], attFont:[UIFont?]) {
        let attributedString1    = NSMutableAttributedString(string: mainString ?? "")
        for (index,objStr) in attributedStringsArray.enumerated() {
            let range1 = (mainString as NSString?)?.range(of: objStr ?? "") ?? .init()
            let attribute_font = [NSAttributedString.Key.font: attFont[index] ?? UIFont.systemFont(ofSize: CGFloat(12))]
            attributedString1.addAttributes(attribute_font, range:  range1)
            attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: color[index] ?? UIColor.clear, range: range1)
        }
        if(self.isKind(of: UILabel.self)) {
            (self as! UILabel).attributedText = attributedString1
        }
        if(self.isKind(of: UITextView.self)) {
            (self as! UITextView).attributedText = attributedString1
        }
        if(self.isKind(of: UITextField.self)) {
            (self as! UITextField).attributedText = attributedString1
        }
        if(self.isKind(of: UIButton.self)) {
            (self as! UIButton).setAttributedTitle(attributedString1, for: .normal)
        }
    }
    
    func addTopAndBottomBorders(color:UIColor = UIColor.black,thickness:CGFloat = 2.0) {
//        let thickness: CGFloat = thickness
        let topBorder = CALayer()
        let bottomBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: thickness)
        topBorder.backgroundColor = color.cgColor//UIColor.red.cgColor
        bottomBorder.frame = CGRect(x:0, y: self.frame.size.height - thickness, width: self.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = color.cgColor///UIColor.red.cgColor
        self.layer.addSublayer(topBorder)
        self.layer.addSublayer(bottomBorder)
    }
    
    func onlyTopBorder(color:UIColor = UIColor.black,thickness:CGFloat = 2.0) {
//        let thickness: CGFloat = thickness
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: thickness)
        topBorder.backgroundColor = color.cgColor//UIColor.red.cgColor

        self.layer.addSublayer(topBorder)
        
    }
    
    func onlyBottomBorder(color:UIColor = UIColor.black,thickness:CGFloat = 2.0) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.frame.size.height - thickness, width: self.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = color.cgColor///UIColor.red.cgColorself.layer.removeAllAnimations()

        self.layer.addSublayer(bottomBorder)
    }
    
    
}
