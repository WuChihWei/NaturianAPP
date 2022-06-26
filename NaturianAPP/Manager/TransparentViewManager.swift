//
//  TransparentView.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/22.
//

import Foundation
import UIKit

struct AddDropDownField {
    
    static let shared = AddDropDownField()
    
    func addWithoutTransparent(radius: Int, tableView: UITableView, view: UIView, frames: CGRect) {
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        view.addSubview(tableView)
        tableView.layer.cornerRadius = CGFloat(radius)
        tableView.reloadData()
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            
            tableView.frame = CGRect(x: frames.origin.x,
                                          y: frames.origin.y + frames.height + 5,
                                          width: frames.width,
                                          height: CGFloat(200))
        }, completion: nil)
    }
}
