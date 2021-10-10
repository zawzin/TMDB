//
//  ViewController.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit
import RxSwift

enum MovieSection: String, CaseIterable {
    case upcoming = "Upcoming"
    case popular = "Popular"
}

class HomeViewController: BaseViewController, Storyboarded {
    
    static var storyboardName: String = Constants.Storyboard.main
    
    @IBOutlet weak var colHome: UICollectionView!
    
    static let sectionHeaderElementKind = "sectionHeaderElementKind"
    private var viewModel: HomeViewModel!
    private let bag = DisposeBag()
    
    var upcomings: [Movie] = []
    var populars: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCollectionView()
        self.initViewModel()
    }
    
    private func setUpCollectionView() {
        colHome.dataSource = self
        colHome.delegate = self
        colHome.register(nibs: [
            UpcomingMovieCell.className,
            PopularMovieCell.className
        ])
        colHome.collectionViewLayout = generateLayout()
        colHome.register(UINib(nibName: MovieHeaderView.className, bundle: nil), forSupplementaryViewOfKind: HomeViewController.sectionHeaderElementKind, withReuseIdentifier: MovieHeaderView.className)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        colHome.refreshControl = refreshControl
    }
    
    private func initViewModel() {
        viewModel = HomeViewModel()
        
        viewModel.refreshData()
        
        viewModel.isLoadingObs
            .observe(on: MainScheduler.instance)
            .bind(to: self.isLoading)
            .disposed(by: self.bag)
        
        viewModel._errorObs
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                if error == nil { return }
                self?.showAlert(message: error ?? "") {
                    self?.viewModel.refreshData()
                }
            }).disposed(by: self.bag)
        
        let upcomingObs = viewModel.upcomingMoviesObs
        let popularObs = viewModel.popularMoviesObs
        Observable.combineLatest(upcomingObs, popularObs)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (upcomings, populars) in
                self?.upcomings = upcomings
                self?.populars = populars
                self?.colHome.reloadData()
            }).disposed(by: self.bag)

    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            
            let sectionLayoutKind = MovieSection.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .upcoming: return self.generateUpcomingLayout()
            case .popular: return self.generatePopularLayout()
            }
        }
        return layout
    }
    
    private func generateUpcomingLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(150),
            heightDimension: .absolute(280))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(56))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func generatePopularLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(56))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HomeViewController.sectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    @objc func pullToRefresh() {
        colHome.refreshControl?.endRefreshing()
        viewModel.refreshData()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MovieSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = MovieSection.allCases[section]
        switch section {
        case .upcoming: return self.upcomings.count
        case .popular: return self.populars.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = MovieSection.allCases[indexPath.section]
        let row = indexPath.row
        
        switch section {
        case .upcoming:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingMovieCell.className, for: indexPath) as? UpcomingMovieCell
            else {
                return UICollectionViewCell(frame: .zero)
            }
            
            cell.data = self.upcomings[row]
            cell.delegate = self
            
            return cell
            
        case .popular:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCell.className, for: indexPath) as? PopularMovieCell else {
                return UICollectionViewCell(frame: .zero)
            }
            
            cell.data = self.populars[row]
            cell.delegate = self
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = MovieSection.allCases[indexPath.section]
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: HomeViewController.sectionHeaderElementKind, withReuseIdentifier: MovieHeaderView.className, for: indexPath) as! MovieHeaderView
        switch section {
        case .upcoming: headerView.lblTitle.text = section.rawValue
        case .popular: headerView.lblTitle.text = section.rawValue
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let section = MovieSection.allCases[indexPath.section]
        
        switch section {
        case .upcoming:
            if (self.upcomings.count - 3) == indexPath.row {
                self.viewModel.loadUpcomingMovies(isLoadMore: true)
            }
            
        case .popular:
            if (self.populars.count - 3) == indexPath.row {
                self.viewModel.loadPopularMovies(isLoadMore: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = MovieSection.allCases[indexPath.section]
        
        let detailsVC = MovieDetailsViewController.instantiate()
        
        switch section {
        case .upcoming:
            let movie = self.upcomings[indexPath.row]
            detailsVC.movie = movie
            
        case .popular:
            let movie = self.populars[indexPath.row]
            detailsVC.movie = movie
        }
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension HomeViewController: UpcomingMovieCellDelegate, PopularMovieCellDelegate {
    
    func onTapFavourite(cell: PopularMovieCell) {
        self.viewModel.tappedFavourite(data: cell.data)
    }
    
    func onTapFavourite(cell: UpcomingMovieCell) {
        self.viewModel.tappedFavourite(data: cell.data)
    }
}
