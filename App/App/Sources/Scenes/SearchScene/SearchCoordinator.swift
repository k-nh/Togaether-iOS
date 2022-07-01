//
//  SearchCoordinator.swift
//  App
//
//  Created by 유한준 on 2022/06/04.
//

import UIKit
import CoreLocation

final class SearchCoordinator: SceneCoordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController = .init()) {
        self.navigationController = navigationController
    }
    
    func start() {
        let gatherRepository = GatherRepository(networkManager: NetworkManager.shared)
        let reactor = SearchReactor(gatherRepository: gatherRepository)
        let locationManger = CLLocationManager()
        let viewController = SearchViewController(reactor: reactor, locationManager: locationManger)
        
        navigationController.setViewControllers([viewController], animated: false)
    }
}
