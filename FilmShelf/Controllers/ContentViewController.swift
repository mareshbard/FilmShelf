import UIKit

class ContentViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        tabs = [
            UITab(title: "Filmes", image: UIImage(systemName: "popcorn"), identifier: "0") { _ in
                
                let homeVC = HomeViewController()
                homeVC.title = "Filmes"
                let nav = UINavigationController(rootViewController: homeVC)
                nav.navigationBar.prefersLargeTitles = true
                return nav
            },
            UITab(title: "Perfil", image: UIImage(systemName: "person"), identifier: "1") { _ in
                let profileVC = ProfileViewController()
                profileVC.title = "Perfil"
                let nav = UINavigationController(rootViewController: profileVC)
                nav.navigationBar.prefersLargeTitles = true
                return nav            }
        ]
    }
}

extension ContentViewController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelectTab selectedTab: UITab,
        previousTab: UITab?
    ) {
        print(selectedTab.identifier)
    }
}

#Preview {
    ContentViewController()
}
