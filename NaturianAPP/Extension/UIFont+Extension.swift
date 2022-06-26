//
//  UIFont+Extension.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/25.
//

import Foundation
import UIKit

public enum Roboto: String {
    
    case typewriter = "Roboto"
    
    case light = "Roboto-Light"
    
    case regular = "Roboto-Regular"
    
    case medium = "Roboto-Medium"

    case bold = "Roboto-Bold"
    
    case black = "Roboto-Black"
  
    public func font(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
