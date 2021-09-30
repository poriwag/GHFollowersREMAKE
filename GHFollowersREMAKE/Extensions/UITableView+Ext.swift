//
//  UITableView+Ext.swift
//  GHFollowersREMAKE
//
//  Created by billy pak on 7/14/21.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
