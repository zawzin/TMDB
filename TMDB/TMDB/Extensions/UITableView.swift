//
//  UITableView.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit

public extension UITableView {
    
    func register(nib nibName: String, bundle: Bundle? = nil) {
        self.register(UINib(nibName: nibName , bundle: bundle), forCellReuseIdentifier: nibName)
    }
    
    func registerHeaderFooter(nib nibName: String, bundle: Bundle? = nil) {
        register(UINib(nibName: nibName , bundle: bundle), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func register(nibs nibNames: [String], bundle: Bundle? = nil) {
        nibNames.forEach {
            self.register(UINib(nibName: $0 , bundle: bundle), forCellReuseIdentifier: $0)
        }
    }
}
