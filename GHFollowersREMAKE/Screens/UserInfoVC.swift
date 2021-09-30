//
//  UserInfoVC.swift
//  GHFollowersREMAKE
//
//  Created by billy pak on 5/5/21.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var itemViews: [UIView] = []
    
    var username: String!
    weak var delegate: UserInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        configureViewController()
        layoutUI()
        getUserInfo()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username, completed: {[weak self] result in
            guard let self = self else { return }
            
            
            switch result {
            
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went Wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        })
    }
    
    func configureUIElements(with user: User) {
        
        //2 ways to set delegate, GFRepoItemVC has initializer as delegate
        //let repoItemVC = GFRepoItemVC(user: user, delegate: self)
        //this line not necessary because declared in add function
                
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub Since \(user.createdAt.convertToMonthYearFormat())"
    }
    
    func layoutUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        
        headerView.backgroundColor = .systemBackground

        
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 150
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

}

extension UserInfoVC: GFRepoItemVCDelegate, GFFollowerItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "url to this user is invalid", buttonTitle: "OK")
            return
        }
        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers > 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This user has no followers", buttonTitle: "Ok")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
    
}

/*
extension UserInfoVC: ItemInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "Url to this user is invalid", buttonTitle: "OK")
            return
        }
        
        presentSafariVC(with: url)

    }
    
    func didTapGetFollowers(for user: User) {
        
        guard user.followers > 0 else {
            presentGFAlertOnMainThread(title: "no Followers", message: "This user has no followers", buttonTitle: "ok")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}
 */
