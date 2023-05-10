//
//  ProfileViewController.swift
//  KitchenStories
//
//  Created by Teguh Wibowo Wijaya on 06/04/23.
//

import UIKit

enum ProfileViewSection {
    case profileAccount
    case profileSettings
}

class ProfileViewController: UIViewController {
    static let tabTitle = "Profile"
    static let tabImage = UIImage(systemName: "person")
    static let tabSelectedImage = UIImage(systemName: "person.fill")
    
    private let headerVerticalSpacing: CGFloat = 5
    private let headerSeparatorHeight: CGFloat = 1
    
    private var profileViewModel: ProfileViewModel!
    
    private lazy var profileTableView: UITableView = {
       let profileTableView = UITableView()
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        
        return profileTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        setupViewModel()
        setupTableView()
        addSubviews()
        setComponentsConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupViewModel() {
        profileViewModel = ProfileViewModel()
        profileViewModel.delegate = self
        profileViewModel.getUserProfile()
    }
    
    private func setupTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorStyle = .none
        profileTableView.contentInsetAdjustmentBehavior = .never
        profileTableView.sectionHeaderTopPadding = 0
        
        profileTableView.register(ProfileAccountTableViewCell.self, forCellReuseIdentifier: ProfileAccountTableViewCell.identifier)
        profileTableView.register(ProfileSettingTableViewCell.self, forCellReuseIdentifier: ProfileSettingTableViewCell.identifier)
        profileTableView.register(HeaderTitleTableViewCell.self, forCellReuseIdentifier: HeaderTitleTableViewCell.identifier)
    }
    
    private func addSubviews() {
        view.addSubview(profileTableView)
    }
    
    private func setComponentsConstraints() {
        NSLayoutConstraint.activate([
            profileTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            profileTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension ProfileViewController: ProfileViewModelDelegate {
    func handleOnFetchUserCompleted() {
        if let errorMessage = profileViewModel.errorMessage {
            print("error: \(errorMessage)")
        } else {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
        }
    }
    
    func handleOnSuccessSignOut() {
        let welcomeVc = WelcomeViewController(nibName: WelcomeViewController.identifier, bundle: nil)
        
        Utilities.changeViewControllerRoot(to: welcomeVc)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileViewModel.compositions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch profileViewModel.compositions[section] {
        case .profileAccount:
            return 1
            
        case .profileSettings:
            return profileViewModel.settingSections[section - 1].settings.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch profileViewModel.compositions[indexPath.section] {
        case .profileAccount:
            return profileAccountCell(of: tableView, cellForRowAt: indexPath)
            
        case .profileSettings:
            if indexPath.row == 0 {
                return profileSettingHeaderCell(of: tableView, cellForRowAt: indexPath)
            }
            return profileSettingCell(of: tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch profileViewModel.compositions[indexPath.section] {
        case .profileAccount:
            return true
            
        case .profileSettings:
            if indexPath.row == 0 { return false }
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch profileViewModel.compositions[indexPath.section] {
        case .profileAccount:
            tableView.deselectRow(at: indexPath, animated: true)
            
            if let userProfile = profileViewModel.userProfile {
                let profileDetailVc = ProfileDetailViewController(userProfile: userProfile)
                profileDetailVc.title = "Profile Detail"
                self.navigationController?.pushViewController(profileDetailVc, animated: true)
            }
            
        case .profileSettings:
            if indexPath.row != 0 { tableView.deselectRow(at: indexPath, animated: true) }
            
            if profileViewModel.settingSections[indexPath.section - 1].settings[indexPath.row - 1].type == .logOut {
                profileViewModel.signOut()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .gray
        
        let wraperView = UIView()
        wraperView.addSubview(separatorView)
        
        let headerTopSpacing = section == 0 ? 0 : headerVerticalSpacing
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: wraperView.topAnchor, constant: headerTopSpacing),
            separatorView.leftAnchor.constraint(equalTo: wraperView.leftAnchor, constant: Constant.horizontalSpacing),
            separatorView.rightAnchor.constraint(equalTo: wraperView.rightAnchor, constant: -Constant.horizontalSpacing),
            separatorView.bottomAnchor.constraint(equalTo: wraperView.bottomAnchor, constant: -headerVerticalSpacing),
        ])
        
        return wraperView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return headerSeparatorHeight + (headerVerticalSpacing * 2)
        }
        
        return headerSeparatorHeight + headerVerticalSpacing
    }
}

extension ProfileViewController {
    private func profileAccountCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileAccountCell = tableView.dequeueReusableCell(withIdentifier: ProfileAccountTableViewCell.identifier, for: indexPath) as? ProfileAccountTableViewCell
        else { return UITableViewCell() }
        
        var profileAccountParams: ProfileAccountCellParams?
        if let profile = profileViewModel.userProfile {
            profileAccountParams = ProfileAccountCellParams(
                userImageUrlString: profile.imageUrlString,
                userName: profile.name,
                abbreviation: profile.abbreviation
            )
        }
        
        profileAccountCell.setupCell(profileAccount: profileAccountParams, isLoading: profileViewModel.isLoading)
        
        return profileAccountCell
    }
    
    private func profileSettingCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileSettingCell = tableView.dequeueReusableCell(withIdentifier: ProfileSettingTableViewCell.identifier, for: indexPath) as? ProfileSettingTableViewCell
        else { return UITableViewCell() }
        
        let settingOfIndex = profileViewModel.settingSections[indexPath.section - 1].settings[indexPath.row - 1]
        let profileSettingParams = ProfileSettingCellParams(
            settingImageSymbolName: settingOfIndex.symbolImageName,
            settingName: settingOfIndex.type.rawValue,
            settingTintColor: settingOfIndex.tintColor
        )
        
        profileSettingCell.setupCell(profileSetting: profileSettingParams, isLoading: profileViewModel.isLoading)
        
        return profileSettingCell
    }
    
    private func profileSettingHeaderCell(of tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileSettingHeaderCell = tableView.dequeueReusableCell(withIdentifier: HeaderTitleTableViewCell.identifier, for: indexPath) as? HeaderTitleTableViewCell
        else { return UITableViewCell() }
        
        profileSettingHeaderCell.setupCell(
            title: profileViewModel.settingSections[indexPath.section - 1].section.rawValue,
            showSeeAllButton: false,
            isLoading: profileViewModel.isLoading
        )
        
        return profileSettingHeaderCell
    }
}
