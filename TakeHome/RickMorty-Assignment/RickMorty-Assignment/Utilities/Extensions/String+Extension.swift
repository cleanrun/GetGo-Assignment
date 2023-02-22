//
//  String+Extension.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import Foundation

extension StringProtocol {
    subscript(_ offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ range: Range<Int>) -> SubSequence {
        prefix(range.lowerBound+range.count).suffix(range.count)
    }
    
    subscript(_ range: ClosedRange<Int>) -> SubSequence {
        prefix(range.lowerBound+range.count).suffix(range.count)
    }
    
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
        prefix(range.upperBound.advanced(by: 1))
    }
    
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence {
        prefix(range.upperBound)
    }
    
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
        suffix(Swift.max(0, count-range.lowerBound))
    }
}

extension LosslessStringConvertible {
    var string: String {
        .init(self)
    }
}

extension BidirectionalCollection {
    subscript(safe offset: Int) -> Element? {
        guard !isEmpty, let i = index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
        return self[i]
    }
}

extension String {
    enum StringDateFormat {
        case created
        case airDate
        
        var beforeFormat: String {
            switch self {
            case .created:
                return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            case .airDate:
                return "MMMM dd, yyyy"
            }
        }
        
        var afterFormat: String {
            switch self {
            case .created:
                return "HH:mm, d MMMM yyyy"
            case .airDate:
                return "d MMMM yyyy"
            }
        }
    }
    
    func getDateWithFormat(using format: StringDateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.beforeFormat
        
        guard let date = dateFormatter.date(from: self) else { fatalError("Wrong date format") }
        
        dateFormatter.dateFormat = format.afterFormat
        return dateFormatter.string(from: date)
    }
}
