//
//  MovieDetailsViewController.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit

class MovieDetailsViewController: BaseViewController, Storyboarded {

    static var storyboardName: String = Constants.Storyboard.main
    
    @IBOutlet weak var ivBackdrop: UIImageView!
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblUserScore: UILabel!
    @IBOutlet weak var titleOverview: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    var movie: Movie!
    
    private var viewModel: MovieDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Details"
        
        self.setUpView()
        self.bindData()
        
        self.viewModel = MovieDetailsViewModel()
    }
    
    fileprivate func setUpView() {
        btnFav.viewCornerRadius = btnFav.frame.height / 2
        btnFav.setImage(.favBorder, for: .normal)
        btnFav.setImage(.favFill, for: .selected)
    }
    
    fileprivate func bindData() {
        ivBackdrop.bindImage(with: self.movie.getFullbackdropPath())
        ivMovie.bindImage(with: self.movie.getFullposterPath())
        lblTitle.text = self.movie.title
        lblReleaseDate.text = self.movie.releaseDate
        lblUserScore.text = "User Score: \((self.movie.voteAverage ?? 0) * 10) %"
        lblDesc.text = self.movie.overview
        btnFav.isSelected = self.movie.isFavourite
    }
    
    @IBAction func didTappedFav(_ sender: Any) {
        btnFav.isSelected.toggle()
        viewModel.tappedFavourite(data: self.movie)
    }
    
}
