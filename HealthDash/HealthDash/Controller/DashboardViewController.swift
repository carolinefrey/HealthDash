//
//  DashboardViewController.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private var contentView: MainContentView!

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        
        contentView = MainContentView()
        view = contentView
        
        configureCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        contentView.dashboardCollectionView.dataCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCollectionViewCell.dashboardCollectionViewCellIdentifier, for: indexPath) as! DashboardCollectionViewCell
        return cell
    }
}

