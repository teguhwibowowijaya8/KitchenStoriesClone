//
//  WelcomeViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 08/04/23.
//

import UIKit

enum SignButtonTag: Int {
    case signUp
    case signIn
}

class WelcomeViewController: UIViewController {
    static let identifier = "WelcomeViewController"
    
    private var welcomeViewModel: WelcomeViewModel!
    
    @IBOutlet weak var backgroundImageView: BackgroundImageView!
    
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
            welcomeGreetingsPageControl.currentPage = 0
            
            backgroundImageView.image = BackgroundImage.getBy(index: welcomeGreetingsPageControl.currentPage)?.image
            
            welcomeGreetingsPageControl.addTarget(self, action: #selector(onPageControlValueChanged), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var signUpButton: RoundedCornersButton! {
        didSet {
            signUpButton.buttonTitle = "Sign Up"
            signUpButton.tag = SignButtonTag.signUp.rawValue
            signUpButton.addTarget(self, action: #selector(onSignButtonSelected), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signInButton: RoundedCornersButton! {
        didSet {
            signInButton.buttonTitle = "Sign In"
            signInButton.tag = SignButtonTag.signIn.rawValue
            signInButton.addTarget(self, action: #selector(onSignButtonSelected), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewModel()
        setupCollectionView()
        setPageControlCount()
    }
    
    private func setupViewModel() {
        welcomeViewModel = WelcomeViewModel()
    }
    
    private func setPageControlCount() {
        welcomeGreetingsPageControl.numberOfPages = welcomeViewModel.greetingsTitle.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc func onPageControlValueChanged(_ sender: UIPageControl) {
        let index = sender.currentPage
        let selectedIndexPath = IndexPath(row: index, section: 0)
        welcomeGreetingsCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        changeBackgroundImage(to: index)
    }
    
    private func changeBackgroundImage(to index: Int) {
        let backgroundImage: UIImage?
        if let image = BackgroundImage.getBy(index: index % 3)?.image {
            backgroundImage = image
        } else {
            backgroundImage = BackgroundImage.background1.image
        }
        
        backgroundTransition(to: backgroundImage)
    }
    
    private func backgroundTransition(to image: UIImage?) {
        if backgroundImageView.image == image { return }
        UIView.transition(with: backgroundImageView, duration: 0.5, options: .transitionCrossDissolve) {
            self.backgroundImageView.image = image
        }
    }
    
    @objc func onSignButtonSelected(_ sender: UIButton) {
        let nextViewController: UIViewController
        
        switch SignButtonTag(rawValue: sender.tag) {
        case .signIn:
            nextViewController = LoginViewController()
        case .signUp:
            nextViewController = RegisterViewController()
        case .none:
            return
        }
        
        navigationController?.pushViewController(nextViewController, animated: true)
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
        return welcomeViewModel.greetingsTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let welcomeGreetingCell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeGreetingCollectionViewCell.identifier, for: indexPath) as? WelcomeGreetingCollectionViewCell
        else { return UICollectionViewCell() }
        
        welcomeGreetingCell.setCell(
            title: welcomeViewModel.greetingsTitle[indexPath.row],
            subtitle: welcomeViewModel.greetingsSubtitle[indexPath.row]
        )
        
        return welcomeGreetingCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        let currPage = Int(offSet + horizontalCenter) / Int(width)
        welcomeGreetingsPageControl.currentPage = currPage
        changeBackgroundImage(to: currPage)
    }
}
