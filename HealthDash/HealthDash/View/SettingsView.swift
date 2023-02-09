//
//  SettingsView.swift
//  HealthDash
//
//  Created by Caroline Frey on 2/8/23.
//

import UIKit

class SettingsView: UIView {

    // MARK: - UserDefaults
    
    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")

    // MARK: - UI Properties
    
    private let viewTitle: UILabel = {
        let viewTitle = UILabel()
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.font = UIFont(name: "Nunito-SemiBold", size: 36)
        viewTitle.textColor = UIColor(named: "Color4")
        viewTitle.text = "Settings"
        viewTitle.textAlignment = .left
        return viewTitle
    }()
    
    lazy var saveSettingsButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 28)
        let icon = UIImage(systemName: "square.and.arrow.down", withConfiguration: config)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(icon, for: .normal)
        button.tintColor = UIColor(named: "Color4")
        return button
    }()

    private let targetSleepTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Nunito-Regular", size: 18)
        title.textColor = UIColor(named: "Color4")
        title.textAlignment = .left
        title.text = "Target sleep:"
        return title
    }()
    
    let targetSleepTextView: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .white
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.font = UIFont(name: "Nunit-Regular", size: 18)
        field.textColor = UIColor(named: "Color4")
        //field.setLeftPadding(10)
        //field.setRightPadding(10)
        return field
    }()

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "Background")
        targetSleepTextView.text = userDefaults?.string(forKey: "name")
        
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup

    private func setUpViews() {
        addSubview(viewTitle)
        addSubview(saveSettingsButton)
        addSubview(targetSleepTitleLabel)
        addSubview(targetSleepTextView)
        
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            viewTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            viewTitle.heightAnchor.constraint(equalToConstant: 40),
            
            saveSettingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            saveSettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            targetSleepTitleLabel.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 20),
            targetSleepTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            targetSleepTextView.topAnchor.constraint(equalTo: targetSleepTitleLabel.bottomAnchor, constant: 5),
            targetSleepTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            targetSleepTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            targetSleepTextView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}
