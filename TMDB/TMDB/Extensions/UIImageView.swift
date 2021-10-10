//
//  UIImageView.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func bindImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.kf.indicatorType = .activity
        kf.setImage(with: url, placeholder: UIImage.imgPlaceholder, options: [
            .cacheOriginalImage
        ], completionHandler: {
            result in
            switch result {
            case .success(let value):
                debugPrint("Success for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                self.image = UIImage.imgPlaceholder
                debugPrint("Failed: \(error.localizedDescription)")
            }
        })
    }
}
