//
//  String+Extension.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import Foundation
import UIKit

extension String{
    func isWordPresent(searchString: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "\\b\(self)\\b", options: .caseInsensitive)
            let range = NSRange(location: 0, length: searchString.utf16.count)
            
            if let _ = regex.firstMatch(in: searchString, options: [], range: range) {
                return true
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
        
        return false
    }
    
    func filterAndModifyTextAttributes(searchStringCharacters: String, fontSize: CGFloat = 17) -> NSMutableAttributedString {

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        let pattern = searchStringCharacters.lowercased()
        let range: NSRange = NSMakeRange(0, self.count)
        var regex = NSRegularExpression()
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
            regex.enumerateMatches(in: self.lowercased(), options: NSRegularExpression.MatchingOptions(), range: range) {
                (textCheckingResult, matchingFlags, stop) in
                let subRange = textCheckingResult?.range
                let attributes : [NSAttributedString.Key : Any] = [.font : UIFont.boldSystemFont(ofSize: fontSize), .foregroundColor: UIColor.red]
                attributedString.addAttributes(attributes, range: subRange!)
            }
        }catch{
            print(error.localizedDescription)
        }
        return attributedString
    }
}
