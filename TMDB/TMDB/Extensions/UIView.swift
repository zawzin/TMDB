//
//  UIView.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit

public extension UIView {
    
    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func roundedShadow(opacity: Float, offset:CGSize, color: UIColor, cornerRadius: CGFloat) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = false
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       layer.mask = mask
    }
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
        }
    }
}
