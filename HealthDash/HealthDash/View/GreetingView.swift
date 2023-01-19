//
//  GreetingView.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

class GreetingView: UIView {
    
    // MARK: - UI Properties
    
    private let greetingLabel: UILabel = {
        let greeting = UILabel()
        greeting.translatesAutoresizingMaskIntoConstraints = false
        greeting.textAlignment = .left
        greeting.font = UIFont(name: "Oxygen-Bold", size: 36)
        greeting.textColor = UIColor(named: "Navy")
        return greeting
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
        addSubview(greetingLabel)
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    public func configureGreeting() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour < 12 {
            greetingLabel.text = "Good morning!"
        } else if hour > 12 && hour < 16 {
            greetingLabel.text = "Good afternoon!"
        } else {
            greetingLabel.text = "Good evening!"
        }
    }
}
