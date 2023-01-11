//
//  DashboardContentView.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

class DashboardContentView: UIView {

    // MARK: - UI Properties
    
    let greetingView: GreetingView = {
        let view = GreetingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let dashboardCollectionView: DashboardCollectionView = {
        let collection = DashboardCollectionView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "Background")
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(greetingView)
        addSubview(dashboardCollectionView)
                        
        NSLayoutConstraint.activate([
            greetingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            greetingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            greetingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            greetingView.heightAnchor.constraint(equalToConstant: 80),
            
            dashboardCollectionView.topAnchor.constraint(equalTo: greetingView.bottomAnchor, constant: 20),
            dashboardCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            dashboardCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dashboardCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
