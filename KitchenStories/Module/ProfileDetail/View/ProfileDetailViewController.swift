//
//  ProfileDetailViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/05/23.
//

import UIKit

enum ProfileDetailSection {
    case profilePhoto
    case profileInfo
    case saveDetail
}

class ProfileDetailViewController: UIViewController {
    
    var userProfile: UserProfileModel
    
    private var profileDetailViewModel: ProfileDetailViewModel!
    
    private let profilePhotoCellIdentifier = ProfilePhotoTableViewCell.identifier
    private let profileInfoCellIdentifier = ProfileInfoTableViewCell.identifier
    private let saveProfileCellIdentifier = SaveUserProfileTableViewCell.identifier
    
    private lazy var profileDetailTableView: UITableView = {
       let profileDetailTableView = UITableView()
        profileDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return profileDetailTableView
    }()
    
    init(userProfile: UserProfileModel) {
        self.userProfile = userProfile
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupViewModel()
        setupTableView()
        addSubviews()
        setComponentsConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViewModel() {
        profileDetailViewModel = ProfileDetailViewModel(userProfile: userProfile)
    }

    private func setupTableView() {
        profileDetailTableView.delegate = self
        profileDetailTableView.dataSource = self
        profileDetailTableView.separatorStyle = .none
        
        profileDetailTableView.register(ProfilePhotoTableViewCell.self, forCellReuseIdentifier: profilePhotoCellIdentifier)
        
        let profileInfoCell = UINib(nibName: profileInfoCellIdentifier, bundle: nil)
        profileDetailTableView.register(profileInfoCell, forCellReuseIdentifier: profileInfoCellIdentifier)
        
        profileDetailTableView.register(SaveUserProfileTableViewCell.self, forCellReuseIdentifier: SaveUserProfileTableViewCell.identifier)
    }
    
    private func addSubviews() {
        view.addSubview(profileDetailTableView)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            profileDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileDetailTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            profileDetailTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            profileDetailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ProfileDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileDetailViewModel.compositions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch profileDetailViewModel.compositions[indexPath.section] {
        case .profilePhoto:
            return profilePhotoCell(tableView, cellForRowAt: indexPath)
            
        case .profileInfo:
            return profileInfoCell(tableView, cellForRowAt: indexPath)
            
        case .saveDetail:
            return saveProfileCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ProfileDetailViewController {
    private func profilePhotoCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profilePhotoCell = tableView.dequeueReusableCell(withIdentifier: profilePhotoCellIdentifier, for: indexPath) as? ProfilePhotoTableViewCell
        else { return UITableViewCell() }
        
        let profilePhotoParams = ProfilePhotoCellParams(
            userImageUrlString: userProfile.imageUrlString,
            userNameAbbreviation: userProfile.abbreviation.uppercased()
        )
        
        profilePhotoCell.setupCell(
            profilePhoto: profilePhotoParams,
            isLoading: profileDetailViewModel.isLoading
        )
        
        return profilePhotoCell
    }
    
    private func profileInfoCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileInfoCell = tableView.dequeueReusableCell(withIdentifier: profileInfoCellIdentifier, for: indexPath) as? ProfileInfoTableViewCell
        else { return UITableViewCell() }
        
        guard let profileInfo = profileDetailViewModel.userDetails[indexPath.section]
        else {
            profileInfoCell.setupCell(fieldInfo: nil, isLoading: true)
            return profileInfoCell
        }
        
        let infoType = profileDetailViewModel.textFieldCompositions[indexPath.section - 1]
        let errorMessage = profileDetailViewModel.fieldErrorMessage[infoType] ?? nil
        
        let profileInfoParams = ProfileInfoCellParams(
            fieldName: profileInfo.title,
            fieldDefaultValue: profileInfo.value,
            fieldErrorMessage: errorMessage
        )
        
        profileInfoCell.setupCell(fieldInfo: profileInfoParams, isLoading: profileDetailViewModel.isLoading)
        
        return profileInfoCell
    }
    
    private func saveProfileCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let saveProfileCell = tableView.dequeueReusableCell(withIdentifier: saveProfileCellIdentifier, for: indexPath) as? SaveUserProfileTableViewCell
        else { return UITableViewCell() }
        
        saveProfileCell.delegate = self
        
        return saveProfileCell
    }
}

extension ProfileDetailViewController: SaveUserProfileCellDelegate {
    func handleSaveUserInformation() {
        navigationController?.popViewController(animated: true)
    }
}
