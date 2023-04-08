//
//  String+CharArray.swift
//
//  Created by Jeffrey Thompson on 1/20/23.
//

import Foundation

extension String {
    
    var multiLineCharArray: [[String]] {
        let lines = self
            .split(whereSeparator: \.isNewline)
            .map { String($0) }
        return lines.map { $0.characterArray }
    }
    
    var characterArray: [String] {
        Array(self).map { String($0) }
    }
}
