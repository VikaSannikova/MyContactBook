//
//  ContactAvatarView.swift
//  MyContactBook
//
//  Created by user on 04.04.2021.
//

import UIKit

class ContactAvatarView: UIView {
    var initials: String? = nil
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = rect.width / 2;
        self.layer.masksToBounds = true;
        let path = UIBezierPath(ovalIn: rect)
        UIColor.random().setFill()
        path.fill()
        let text = NSAttributedString(string: self.initials ?? "")
        let textSize: CGSize = text.size()
        let viewCenter = CGPoint(x:(rect.width - textSize.width)/2, y: (rect.height - textSize.height)/2)
        text.draw(at:viewCenter)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
