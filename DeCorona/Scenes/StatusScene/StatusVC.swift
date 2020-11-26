//
//  StatusVC.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class StatusVC: UIViewController {
    @IBOutlet weak var containerBackground:UIView!
    
    var presenter: StatusPresenterInput!
    var index = 0
    
    convenience init(presenter: StatusPresenterInput) {
        self.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func changeBackground(_ sender: UIButton) {
        let green = UIColor.init(red: 6/255, green: 149/255, blue: 14/255, alpha: 1.0)
        let red = UIColor.init(red: 159/255, green: 9/255, blue: 10/255, alpha: 1.0)
        let yellow = UIColor.init(red: 193/255, green: 169/255, blue: 11/255, alpha: 1.0)
        
        let colors = [red, yellow, green]
        
        UIView.animate(withDuration: 2) {
            self.containerBackground.backgroundColor = colors[self.index]
            self.containerBackground.alpha = 0.9
        }

        index += 1
        if index >= colors.count { index = 0; }
    }

}

extension StatusVC : StatusPresenterOutput {
    
}
