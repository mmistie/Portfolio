//
//  CoordinatingNavigationController.swift
//  MovieSearch
//
///  Created by user235795 on 08/12/2023.
//

import UIKit

// MARK: - Coordinating Navigation Controller

class CoordinatingNavigationController: UINavigationController {

    private lazy var searchCoordinator: SearchCoordinator = {
        SearchCoordinator(navigationController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCoordinator.isNavigationControllerReady = true
    }
}
