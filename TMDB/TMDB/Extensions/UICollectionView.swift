//
//  UICollectionView.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit

public extension UICollectionView {
    
    func register(nib nibName: String, bundle: Bundle? = nil) {
        let nib = UINib(nibName: nibName, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    func register(nibs nibNames: [String], bundle: Bundle? = nil) {
        nibNames.forEach {
            self.register(UINib(nibName: $0 , bundle: bundle), forCellWithReuseIdentifier: $0)
        }
    }
}
