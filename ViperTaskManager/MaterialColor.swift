//
//  MaterialColor.swift
//  ViperTaskManager
//
//  Created by Aaron Lee on 19/11/16.
//  Copyright © 2016 One Fat Giraffe. All rights reserved.
//

import UIKit

class MaterialColor: UIColor {
    
    
    private class func colorWithHex(_ hex: Int, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return UIColor(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    // Some convenience methods to create colors.  These colors will be as calibrated as possible.
    // These colors are cached.
    override class var darkGray: UIColor {
        return MaterialColor.colorWithHex(0x424242)
    }
    override class var lightGray: UIColor {
        return MaterialColor.colorWithHex(0xBDBDBD)
    }
    override class var black: UIColor {
        return MaterialColor.colorWithHex(0x212121)
    }
    override class var gray: UIColor {
        return MaterialColor.colorWithHex(0x9E9E9E)
    }
    override class var red: UIColor {
        return MaterialColor.colorWithHex(0xF44336)
    }
    override class var green: UIColor {
        return MaterialColor.colorWithHex(0x4CAF50)
    }
    override class var blue: UIColor {
        return MaterialColor.colorWithHex(0x2196F3)
    }
    override class var cyan: UIColor {
        return MaterialColor.colorWithHex(0x00BCD4)
    }
    override class var yellow: UIColor {
        return MaterialColor.colorWithHex(0xFFEB3B)
    }
    override class var magenta: UIColor {
        return MaterialColor.colorWithHex(0xF06292)
    }
    override class var orange: UIColor {
        return MaterialColor.colorWithHex(0xFF9800)
    }
    override class var purple: UIColor {
        return MaterialColor.colorWithHex(0x9C27B0)
    }
    override class var brown: UIColor {
        return MaterialColor.colorWithHex(0x795548)
    }
    
    class var deepPurple: UIColor {
        return MaterialColor.colorWithHex(0x673AB7)
    }
    class var pink: UIColor {
        return MaterialColor.colorWithHex(0xE91E63)
    }
    class var indigo: UIColor {
        return MaterialColor.colorWithHex(0x3F51B5)
    }
    class var lightBlue: UIColor {
        return MaterialColor.colorWithHex(0x03A9F4)
    }
    class var teal: UIColor {
        return MaterialColor.colorWithHex(0x009688)
    }
    class var lightGreen: UIColor {
        return MaterialColor.colorWithHex(0x8BC34A)
    }
    class var lime: UIColor {
        return MaterialColor.colorWithHex(0xCDDC39)
    }
    class var amber: UIColor {
        return MaterialColor.colorWithHex(0xFFC107)
    }
    class var deepOrange: UIColor {
        return MaterialColor.colorWithHex(0xFF5722)
    }
    class var blueGray: UIColor {
        return MaterialColor.colorWithHex(0x607D8B)
    }
}
