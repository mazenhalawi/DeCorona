//
//  IndicatorView.swift
//  DeCorona
//
//  Created by Mazen on 12/03/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit


class IndicatorView : UIView {
    
    @IBOutlet weak var container:UIView!
    
    var view:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup() {
        let bundle = Bundle(for: type(of: self))
        self.view = UINib(nibName: "IndicatorView", bundle: bundle).instantiate(withOwner: self, options: nil).first as? UIView
        self.view?.translatesAutoresizingMaskIntoConstraints = false
        convertContainerToGradientColor()
        
        self.addSubview(self.view!)
    }
    
    private func convertContainerToGradientColor() {
        let ca = CAGradientLayer()
        ca.frame = CGRect(origin: CGPoint.zero, size: self.container.bounds.size)
        ca.colors = [COLOR_DARK_RED.cgColor, COLOR_RED.cgColor, COLOR_YELLOW.cgColor, COLOR_GREEN.cgColor]
        ca.locations = [0, 0.33, 0.66, 1]
        ca.startPoint = CGPoint(x: 0.5, y: 0)
        ca.endPoint = CGPoint(x: 0.5, y: 1)
        
        self.container.layer.addSublayer(ca)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.view?.frame = CGRect(origin: CGPoint.zero, size: self.view!.bounds.size)
        
    }
}
