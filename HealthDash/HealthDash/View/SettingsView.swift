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
        viewTitle.font = UIFont(name: "Oxygen-Bold", size: 36)
        viewTitle.textColor = UIColor(named: "Navy")
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
        button.tintColor = UIColor(named: "Navy")
        return button
    }()

    private let targetSleepTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Oxygen-Regular", size: 18)
        title.textColor = UIColor(named: "Navy")
        title.textAlignment = .left
        title.text = "Target sleep:"
        return title
    }()
    
    private let targetSleepExampleLabel: UILabel = {
        let detail = UILabel()
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.font = UIFont(name: "Oxygen-Regular", size: 14)
        detail.textColor = UIColor(named: "Navy")
        detail.textAlignment = .left
        detail.text = "(as a decimal, ex: 8.5 = 8.5 hours)"
        return detail
    }()
    
    let targetSleepTextView: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor(named: "DarkerBackground")
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.font = UIFont(name: "Oxygen-Regular", size: 18)
        field.textColor = UIColor(named: "Navy")
        field.setLeftPadding(10)
        field.setRightPadding(10)
        field.keyboardType = .decimalPad
        return field
    }()

    private let targetWeightTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Oxygen-Regular", size: 18)
        title.textColor = UIColor(named: "Navy")
        title.textAlignment = .left
        title.text = "Target weight:"
        return title
    }()
    
    let targetWeightTextView: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor(named: "DarkerBackground")
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.font = UIFont(name: "Oxygen-Regular", size: 18)
        field.textColor = UIColor(named: "Navy")
        field.setLeftPadding(10)
        field.setRightPadding(10)
        field.keyboardType = .decimalPad
        return field
    }()
    
    private let targetCaloriesTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Oxygen-Regular", size: 18)
        title.textColor = UIColor(named: "Navy")
        title.textAlignment = .left
        title.text = "Target calories:"
        return title
    }()
    
    let targetCaloriesTextView: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor(named: "DarkerBackground")
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.font = UIFont(name: "Oxygen-Regular", size: 18)
        field.textColor = UIColor(named: "Navy")
        field.setLeftPadding(10)
        field.setRightPadding(10)
        field.keyboardType = .decimalPad
        return field
    }()
    
    private let targetStepsTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Oxygen-Regular", size: 18)
        title.textColor = UIColor(named: "Navy")
        title.textAlignment = .left
        title.text = "Target steps:"
        return title
    }()
    
    let targetStepsTextView: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor(named: "DarkerBackground")
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.font = UIFont(name: "Oxygen-Regular", size: 18)
        field.textColor = UIColor(named: "Navy")
        field.setLeftPadding(10)
        field.setRightPadding(10)
        field.keyboardType = .decimalPad
        return field
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(named: "MainBackground")
        targetSleepTextView.text = String(userDefaults?.double(forKey: UserDefaultsKey.targetSleep.rawValue) ?? 0.0)
        targetWeightTextView.text = String(userDefaults?.double(forKey:UserDefaultsKey.targetWeight.rawValue) ?? 0.0)
        targetCaloriesTextView.text = String(userDefaults?.double(forKey: UserDefaultsKey.targetCalories.rawValue) ?? 0.0)
        targetStepsTextView.text = String(userDefaults?.double(forKey: UserDefaultsKey.targetSteps.rawValue) ?? 0.0)
        
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
        addSubview(targetSleepExampleLabel)
        addSubview(targetSleepTextView)
        addSubview(targetWeightTitleLabel)
        addSubview(targetWeightTextView)
        addSubview(targetCaloriesTitleLabel)
        addSubview(targetCaloriesTextView)
        addSubview(targetStepsTitleLabel)
        addSubview(targetStepsTextView)
        
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            viewTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            viewTitle.heightAnchor.constraint(equalToConstant: 45),
            
            saveSettingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            saveSettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            targetSleepTitleLabel.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 20),
            targetSleepTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            targetSleepExampleLabel.topAnchor.constraint(equalTo: targetSleepTitleLabel.bottomAnchor),
            targetSleepExampleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            targetSleepTextView.topAnchor.constraint(equalTo: targetSleepExampleLabel.bottomAnchor, constant: 10),
            targetSleepTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            targetSleepTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            targetSleepTextView.heightAnchor.constraint(equalToConstant: 45),
            
            targetWeightTitleLabel.topAnchor.constraint(equalTo: targetSleepTextView.bottomAnchor, constant: 20),
            targetWeightTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            targetWeightTextView.topAnchor.constraint(equalTo: targetWeightTitleLabel.bottomAnchor, constant: 10),
            targetWeightTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            targetWeightTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            targetWeightTextView.heightAnchor.constraint(equalToConstant: 45),
            
            targetCaloriesTitleLabel.topAnchor.constraint(equalTo: targetWeightTextView.bottomAnchor, constant: 20),
            targetCaloriesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            targetCaloriesTextView.topAnchor.constraint(equalTo: targetCaloriesTitleLabel.bottomAnchor, constant: 10),
            targetCaloriesTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            targetCaloriesTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            targetCaloriesTextView.heightAnchor.constraint(equalToConstant: 45),
            
            targetStepsTitleLabel.topAnchor.constraint(equalTo: targetCaloriesTextView.bottomAnchor, constant: 20),
            targetStepsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            targetStepsTextView.topAnchor.constraint(equalTo: targetStepsTitleLabel.bottomAnchor, constant: 10),
            targetStepsTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            targetStepsTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            targetStepsTextView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
