//
//  UIView+extension.swift
//  FakeNFT
//
//  Created by Екатерина Иванова on 08.08.2023.
//
import UIKit

extension UIView {
    
    func applyCorners(cornerRadii: CGSize, corners: UIRectCorner) {
        // Specify which corners to round
//        let corners = UIRectCorner(arrayLiteral: [
//            UIRectCorner.topLeft,
//            UIRectCorner.topRight,
//            UIRectCorner.bottomLeft,
//            UIRectCorner.bottomRight
//        ])
//
        // Determine the size of the rounded corners
//        let cornerRadii = CGSize(
//            width: cornerRadius,
//            height: cornerRadius
//        )
        
        // A mask path is a path used to determine what
        // parts of a view are drawn. UIBezier path can
        // be used to create a path where only specific
        // corners are rounded
        let maskPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )
        
        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = self.bounds
        
        self.layer.mask = maskLayer
    }
    
}
