//
//  DashboardTableView.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

class DashboardTableView: UIView {
    
    // MARK: - UI Properties
    
    lazy var dataTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        tableView.register(DashboardTableViewCell.self, forCellReuseIdentifier: DashboardTableViewCell.dashboardTableViewCellIdentifier)
        return tableView
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
        addSubview(dataTableView)
        
        NSLayoutConstraint.activate([
            dataTableView.topAnchor.constraint(equalTo: topAnchor),
            dataTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dataTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dataTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
