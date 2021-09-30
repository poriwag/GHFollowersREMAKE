//
//  Date+Ext.swift
//  GHFollowersREMAKE
//
//  Created by billy pak on 5/16/21.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
