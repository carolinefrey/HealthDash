//
//  DashboardCollectionView.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

class DashboardCollectionView: UIView {

    // MARK: - UI Properties
    
    lazy var dataCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 24, left: 30, bottom: 24, right: 30)
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 35)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(DashboardCollectionViewCell.self, forCellWithReuseIdentifier: DashboardCollectionViewCell.dashboardCollectionViewCellIdentifier)
        collection.layer.cornerRadius = 20
        collection.backgroundColor = .white
        return collection
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(dataCollectionView)
        
        NSLayoutConstraint.activate([
            dataCollectionView.topAnchor.constraint(equalTo: topAnchor),
            dataCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dataCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dataCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
