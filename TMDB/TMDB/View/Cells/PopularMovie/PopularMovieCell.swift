//
//  PopularMovieCell.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit

protocol PopularMovieCellDelegate {
    func onTapFavourite(cell: PopularMovieCell)
}

class PopularMovieCell: UICollectionViewCell {

    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    var data: Movie! {
        didSet{
            ivMovie.bindImage(with: data.getFullposterPath())
            lblName.text = data.title
            lblReleaseDate.text = data.releaseDate
            btnFav.isSelected = data.isFavourite
        }
    }
    
    var delegate: PopularMovieCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnFav.viewCornerRadius = btnFav.frame.height / 2
        btnFav.setImage(.favBorder, for: .normal)
        btnFav.setImage(.favFill, for: .selected)
        btnFav.addTarget(self, action: #selector(didTappedFavourite(_:)), for: .touchUpInside)
    }

    @objc func didTappedFavourite(_ sender: UIButton) {
        self.delegate?.onTapFavourite(cell: self)
    }
}
