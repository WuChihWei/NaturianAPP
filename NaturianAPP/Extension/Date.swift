//
//  Date.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/7/11.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
