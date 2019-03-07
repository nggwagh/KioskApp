//
//  StringUtils.swift
//  Kiosk
//
//  Created by Mayur Deshmukh on 24/04/18.
//  Copyright © 2018 Mayur Deshmukh. All rights reserved.
//

import Foundation

extension String {
    
    func isEmptyExcludingWhiteSpaces() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}

extension NSMutableAttributedString {
    
    func trimmedAttributedString(set: CharacterSet) -> NSMutableAttributedString {
        
        let invertedSet = set.inverted
        
        var range = (string as NSString).rangeOfCharacter(from: invertedSet)
        let loc = range.length > 0 ? range.location : 0
        
        range = (string as NSString).rangeOfCharacter(
            from: invertedSet, options: .backwards)
        let len = (range.length > 0 ? NSMaxRange(range) : string.characters.count) - loc
        
        let r = self.attributedSubstring(from: NSMakeRange(loc, len))
        return NSMutableAttributedString(attributedString: r)
    }
}

