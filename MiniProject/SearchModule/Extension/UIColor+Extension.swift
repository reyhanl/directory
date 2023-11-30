//
//  UIColor+Extension.swift
//  MiniProject
//
//  Created by reyhan muhammad on 13/08/23.
//

import UIKit


extension UIColor{
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedHex = cleanedHex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: cleanedHex).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var isDarkMode: Bool{
        if let window = UIApplication.shared.windows.first {
            if window.traitCollection.userInterfaceStyle == .dark {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    static var secondaryForegroundColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "989899"):.darkGray
        return color
        
    }
    
    static var primaryForegroundColor: UIColor{
        let color: UIColor = isDarkMode ? .white:.black
        return color
        
    }
    
    static var secondaryBackgroundColor: UIColor{
        let color = isDarkMode ? UIColor(hex: "2A2A2C"):UIColor(hex: "F2F2F2", alpha: 1)
        return color
    }
    
}
