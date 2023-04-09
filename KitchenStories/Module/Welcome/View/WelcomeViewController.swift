//
//  WelcomeViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 08/04/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let greetingsTitle = [
        "Get Inspired",
        "Sharpen your skills",
        "Share your recipes"
    ]
    
    private let greetingsSubtitle = [
        "Discover delicious reciped and stunning food stories",
        "With our cooking videos and top tips",
        "With our international community"
    ]
    
    @IBOutlet weak var backgroundImageView: BackgroundImageView! {
        didSet {
            backgroundImageView.image = Constant.kitchenBackgroundImage2
        }
    }
    
    @IBOutlet weak var welcomeTitleLabel: UILabel! {
        didSet {
            welcomeTitleLabel.text = "Kitchen Stories"
            welcomeTitleLabel.font = .systemFont(ofSize: 30, weight: .semibold)
            welcomeTitleLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var welcomeSubtitleLabel: UILabel! {
        didSet {
            welcomeSubtitleLabel.text = "ANYONE CAN COOK"
            welcomeSubtitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
            welcomeSubtitleLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var welcomeGreetingsCollectionView: UICollectionView!
    
    @IBOutlet weak var welcomeGreetingsPageControl: UIPageControl! {
        didSet {
            welcomeGreetingsPageControl.pageIndicatorTintColor = .gray
            welcomeGreetingsPageControl.currentPageIndicatorTintColor = .white
            welcomeGreetingsPageControl.numberOfPages = greetingsTitle.count
            welcomeGreetingsPageControl.currentPage = 0
            
            welcomeGreetingsPageControl.addTarget(self, action: #selector(onPageControlValueChanged), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var signUpButton: RoundedCornersButton! {
        didSet {
            signUpButton.buttonTitle = "Sign Up"
        }
    }
    
    @IBOutlet weak var signInButton: RoundedCornersButton! {
        didSet {
            signInButton.buttonTitle = "Sign In"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        setupCollectionView()
    }
    
    @objc func onPageControlValueChanged(_ sender: UIPageControl) {
        let selectedIndexPath = IndexPath(row: sender.currentPage, section: 0)
        welcomeGreetingsCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        welcomeGreetingsCollectionView.collectionViewLayout = flowLayout
        welcomeGreetingsCollectionView.delegate = self
        welcomeGreetingsCollectionView.dataSource = self
        welcomeGreetingsCollectionView.isPagingEnabled = true
        welcomeGreetingsCollectionView.showsHorizontalScrollIndicator = false
        welcomeGreetingsCollectionView.backgroundColor = .clear
        
        welcomeGreetingsCollectionView.register(WelcomeGreetingCollectionViewCell.self, forCellWithReuseIdentifier: WelcomeGreetingCollectionViewCell.identifier)
    }

}

extension WelcomeViewController:  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.width - 60, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}

extension WelcomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        greetingsTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let welcomeGreetingCell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeGreetingCollectionViewCell.identifier, for: indexPath) as? WelcomeGreetingCollectionViewCell
        else { return UICollectionViewCell() }
        
        welcomeGreetingCell.setCell(
            title: greetingsTitle[indexPath.row],
            subtitle: greetingsSubtitle[indexPath.row]
        )
        
        return welcomeGreetingCell
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        welcomeGreetingsPageControl.currentPage = Int(welcomeGreetingsCollectionView.contentOffset.x) / Int(welcomeGreetingsCollectionView.frame.width)
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        welcomeGreetingsPageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
}
