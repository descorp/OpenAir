//
//  StringExtension.swift
//  Panagram
//
//  Created by Sameh Mabrouk on 25/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

extension String {

    func isAnagramOfString(s: String) -> Bool {
        //1
        let lowerSelf = self.lowercased().replacingOccurrences(of: " ", with: "")
        let lowerOther = s.lowercased().replacingOccurrences(of: " ", with: "")
        //2
        return lowerSelf.characters.sorted() == lowerOther.characters.sorted()
    }
    
    func isPalindrome() -> Bool {
        //1
        let f = self.lowercased().replacingOccurrences(of: " ", with: "")
        //2
        let s = String(f.characters.reversed())
        //3
        return  f == s
    }
}
