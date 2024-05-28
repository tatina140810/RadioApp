//
//  TabBar.swift
//  RadioTatina
//
//  Created by Tatina Dzhakypbekova on 28/5/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
    }

    func setupTabBarController() {
        let homeView = HomeView()
        homeView.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "music.note.house.fill"), selectedImage: UIImage(systemName: "music.note.house.fill"))

        let announceView = AnnounceView()
        announceView.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "rectangle.and.text.magnifyingglass"), selectedImage: UIImage(systemName: "rectangle.and.text.magnifyingglass"))

        let playList = PlayList()
        playList.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "play.square.stack"), selectedImage: UIImage(systemName: "play.square.stack"))

        let infoView = InfoView()
        infoView.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "info.circle"), selectedImage: UIImage(systemName: "info.circle"))

      
        setViewControllers([homeView, announceView, playList, infoView], animated: true)
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(hex: "039139")
    }
}

