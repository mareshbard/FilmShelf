import UIKit

class ContentViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        tabs = [
            UITab(title: "Filmes", image: UIImage(systemName: "popcorn"), identifier: "0") { _ in
                
                let homeVC = HomeViewController()
                homeVC.title = "Filmes"
                return UINavigationController(rootViewController: homeVC)
            },
            UITab(title: "Perfil", image: UIImage(systemName: "person"), identifier: "1") { _ in
                let profileVC = ProfileViewController()
                profileVC.title = "Perfil"
                return UINavigationController(rootViewController: profileVC)
            }
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
