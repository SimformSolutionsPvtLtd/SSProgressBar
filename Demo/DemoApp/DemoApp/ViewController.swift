//
//  ViewController.swift
//  ULProgressBar
//
//  Created by Umang Loriya on 7/23/18.
//  Copyright © 2018 Umang Loriya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var viewProgres: ULProgressBar!
    
    @IBOutlet var prgView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewProgres.progress = 50
        viewProgres.withProgressGradientBackground(from: UIColor.red, to: UIColor.purple, direction: .topToBottom)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewProgres.progress = 120
            self.viewProgres.gradientDirection = .leftToRight
            self.viewProgres.colors = [UIColor.blue.cgColor,UIColor.cyan.cgColor,UIColor.black.cgColor]
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewProgres.withProgressGradientBackground(from: UIColor.green, to: UIColor.green.withAlphaComponent(0.5), direction: .bottomToTop)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

