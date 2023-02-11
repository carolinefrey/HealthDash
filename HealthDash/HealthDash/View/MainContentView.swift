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
    
    let dashboardTableView: DashboardTableView = {
        let table = DashboardTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
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
        addSubview(dashboardTableView)
                        
        NSLayoutConstraint.activate([            
            greetingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            greetingView.heightAnchor.constraint(equalToConstant: 80),
            
            dashboardTableView.topAnchor.constraint(equalTo: greetingView.bottomAnchor),
            dashboardTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            dashboardTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            dashboardTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
