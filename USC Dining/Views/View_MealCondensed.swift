//
//  Meal.swift
//  USC Dining
//
//  Created by Hayden Shively on 10/27/18.
//  Copyright © 2018 Hayden Shively. All rights reserved.
//

import UIKit

class View_MealCondensed: UIView {
    
    static let DEFAULT_CORNER_RADIUS: CGFloat = 16.0
    static let DEFAULT_SHADOW_OPACITY: Float = 0.15
    static let DEFAULT_SHADOW_WIDTH: CGFloat = 8.0
    
    
    // CANVAS
    @IBOutlet var contentView: UIView!// constant size, no clipping, and clear
    // SCENE PAINTED ON CANVAS
    @IBOutlet weak var contentViewImage: UIImageView!// size = foundation size
    // note that contentViewImage should have clipToBounds = false and contentMode = .scaleAspectFill
    
    // WINDOW OPENING ONTO CANVAS
    @IBOutlet weak var windowToContentView: UIView!
    // DECALS ON THE WINDOW
    @IBOutlet weak var windowTitle: UILabel!
    @IBOutlet weak var windowSubtitle: UILabel!
    @IBOutlet weak var windowDescriptor: UILabel!
    
    // SHADOWS AROUND WINDOW
    @IBOutlet weak var shadowView: UIView!
    
    
    // CONSTRAINTS
    @IBOutlet weak var windowToContentLeft: NSLayoutConstraint!
    @IBOutlet weak var windowToContentRight: NSLayoutConstraint!
    @IBOutlet weak var windowToContentTop: NSLayoutConstraint!
    @IBOutlet weak var windowToContentBottom: NSLayoutConstraint!
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // initializing in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.homogeneousConfig()
    }
    
    // initializing in interface builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.homogeneousConfig()
    }
    
    // code to run regardless of initialization method
    private func homogeneousConfig() {
        Bundle.main.loadNibNamed("View_MealCondensed", owner: self, options: nil)
        addSubview(contentView)
        
        // TODO: - apparently the next 2 lines aren't the best way of doing things
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - convenience functions
    
    func roundCorners(toRadius radius: CGFloat = View_MealCondensed.DEFAULT_CORNER_RADIUS) {
        windowToContentView.layer.cornerRadius = radius
        shadowView.layer.cornerRadius = radius
    }
    
    func enableShadow(withOpacity opacity: Float = View_MealCondensed.DEFAULT_SHADOW_OPACITY, withWidth radius: CGFloat = View_MealCondensed.DEFAULT_SHADOW_WIDTH) {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowRadius = radius
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowView.isHidden = false
        
        // prepare shadows for scrolling, TODO: must this be called more frequently?
        let bounds = shadowView.layer.bounds
        let radius = shadowView.layer.cornerRadius
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
    }
    
    func disableShadow() {
        shadowView.isHidden = true
    }
    
    func attachContentTo(_ frame: CGRect) {
        contentView.frame = frame
    }

}
