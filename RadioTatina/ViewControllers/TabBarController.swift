import UIKit
import SnapKit

class  TabBarController:  UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
        setTabBarApearence()
    }
    
    private func setTabBarApearence(){
        
        let positionOnX: CGFloat = 8
        let positionOnY: CGFloat = 12
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 1.7
        let roundLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height), cornerRadius: height/2)
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 3.5
        tabBar.itemPositioning = .centered
        
        tabBar.tintColor = UIColor(hex: "#2F126C")
        tabBar.barTintColor = UIColor(hex: "#2CA334")
        tabBar.unselectedItemTintColor = .white
        roundLayer.fillColor = UIColor(hex: "#2CA334").cgColor
    }
    
    private func setupTabBarController() {
        
        let homeView = UINavigationController(rootViewController: HomeViewController())
        homeView.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "music.note.house"), tag: 0)
        
        let advertisementView = UINavigationController(rootViewController: AdvertisementViewController())
                                           advertisementView.tabBarItem = UITabBarItem(title: "Реклама", image: UIImage(systemName: "doc.text.magnifyingglass"), tag: 1)
        
        let newsView = UINavigationController(rootViewController: NewsViewController())
        newsView.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(systemName:  "globe"), tag: 2)
        
        let contactsView = UINavigationController(rootViewController: ContactsViewController())
        contactsView.tabBarItem = UITabBarItem(title: "Контакты", image: UIImage(systemName:  "info.circle"), tag: 3)
        
        setViewControllers([homeView, advertisementView, newsView, contactsView], animated: true)
    }
}
