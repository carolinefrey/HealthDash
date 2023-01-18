//
//  DashboardContentView.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

class MainContentView: UIView {

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
    
    lazy var refreshButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        let icon = UIImage(systemName: "goforward.plus", withConfiguration: config)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: "Navy")
        button.setImage(icon, for: .normal)
        return button
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
    
    // MARK: - UI Setup
    
    private func configureViews() {
        addSubview(refreshButton)
        addSubview(greetingView)
        addSubview(dashboardCollectionView)
                        
        NSLayoutConstraint.activate([
            refreshButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            greetingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            greetingView.heightAnchor.constraint(equalToConstant: 80),
            
            dashboardCollectionView.topAnchor.constraint(equalTo: greetingView.bottomAnchor),
            dashboardCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            dashboardCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dashboardCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
