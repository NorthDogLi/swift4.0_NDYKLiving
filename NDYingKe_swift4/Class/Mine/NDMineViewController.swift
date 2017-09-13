//
//  NDMineViewController.swift
//  NDYingKe_swift4.0
//
//  Created by 李家奇_南湖国旅 on 2017/8/10.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit


class NDMineViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tabBarController?.tabBar.ND_Y = kSCREEN_HEIGHT - (self.tabBarController?.tabBar.ND_Height)!
        }) { (finished) in}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
    }

  

}
