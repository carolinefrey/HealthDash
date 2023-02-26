//
//  DashboardCollectionViewCell.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit
import SwiftUI

enum Data: CaseIterable {
    case sleep, weight, activeEnergy, steps
}

class DashboardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    static let dashboardCollectionViewCellIdentifier = "DashboardCollectionViewCell"
    
    private(set) var host: UIHostingController<SwiftUICell>?
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func embed(in parent: UIViewController, withContent content: CellContent) {
        if let host = self.host {
            host.rootView = SwiftUICell(content: content)
            host.view.layoutIfNeeded()
        } else {
            let host = UIHostingController(rootView: SwiftUICell(content: content))
            parent.addChild(host)
            host.didMove(toParent: parent)
            
            //alternative to using constraints
            host.view.frame = self.contentView.frame
            self.contentView.addSubview(host.view)
            
            self.host = host
        }
    }
    
    deinit {
        host?.willMove(toParent: nil)
        host?.view.removeFromSuperview()
        host?.removeFromParent()
        host = nil
    }
}
