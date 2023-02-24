//
//  DashboardContentView.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

protocol PresentSettingsViewDelegate: AnyObject {
    func presentSettingsView()
}

class MainContentView: UIView {

    // MARK: - UI Properties
    
    weak var delegate: PresentSettingsViewDelegate?
    
    let greetingView: GreetingView = {
        let view = GreetingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dashboardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 350, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(DashboardCollectionViewCell.self, forCellWithReuseIdentifier: DashboardCollectionViewCell.dashboardCollectionViewCellIdentifier)
        collection.backgroundColor = .white
        return collection
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "MainBackground")
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc func presentSettingsView() {
        delegate?.presentSettingsView()
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(greetingView)
        addSubview(dashboardCollectionView)
                        
        NSLayoutConstraint.activate([            
            greetingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            greetingView.heightAnchor.constraint(equalToConstant: 80),
            
            dashboardCollectionView.topAnchor.constraint(equalTo: greetingView.bottomAnchor),
            dashboardCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dashboardCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dashboardCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
