import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var socialLinkLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logOutButton: UIButton?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc
    private func didTapButton() {
    }
    
    private func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    private func translatesMaskToConstraints (_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "profile")
        let profileImageView = UIImageView(image: profileImage)
        translatesMaskToConstraints(profileImageView)
        addSubview(profileImageView)
        
        
        guard let logOutImage = UIImage(named: "logOut") else {return}
        let logOutButton = UIButton.systemButton(
            with: logOutImage,
            target: self,
            action: #selector(Self.didTapButton))
        logOutButton.tintColor = .ytRed
        translatesMaskToConstraints(logOutButton)
        addSubview(logOutButton)
        
        let nameLabel = UILabel()
        nameLabel.text = "Aur Daniel"
        nameLabel.textColor = .ytWhite
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        translatesMaskToConstraints(nameLabel)
        addSubview(nameLabel)
        
        
        let socialLinkLabel = UILabel()
        socialLinkLabel.text = "t/me.aurdaniel"
        socialLinkLabel.textColor = .ytGray
        socialLinkLabel.font = .systemFont(ofSize: 13)
        translatesMaskToConstraints(socialLinkLabel)
        addSubview(socialLinkLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!!!"
        descriptionLabel.textColor = .ytWhite
        descriptionLabel.font = .systemFont(ofSize: 13)
        translatesMaskToConstraints(descriptionLabel)
        addSubview(descriptionLabel)
        
        
        NSLayoutConstraint.activate([
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logOutButton.widthAnchor.constraint(equalToConstant: 44),
            logOutButton.heightAnchor.constraint(equalToConstant: 44),
            logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            socialLinkLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            socialLinkLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: socialLinkLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
            
        ])
        
        
    }
    
    
    
}
