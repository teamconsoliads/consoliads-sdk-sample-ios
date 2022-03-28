//
//  SplashVC.swift
//  ConsoliAds Sample App
//
//  Created by OsamaNadeem on 3/24/22.
//

import UIKit

class SplashVC: BaseVC {

    @IBOutlet var splashLogo: UIImageView!
    @IBOutlet var imageHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var subtitleText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtitleText.isHidden = true
        splashLogo.isHidden = true

        UIView.animate(withDuration: 1.25) {
            self.splashLogo.transform = (self.splashLogo.transform.rotated(by: .pi))
            self.splashLogo.transform = (self.splashLogo.transform.rotated(by: .pi)) // pi/2 = 90˚
            self.imageHorizontalConstraint.constant = -(150)
            self.subtitleText.isHidden = false
            self.subtitleText.font = UIFont(name: "Bradley Hand", size: 20)!
            self.splashLogo.isHidden = false
            self.view.layoutIfNeeded()
        } completion: { flag in
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainvc") as? ViewController
            vc?.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc!, animated: true)
            self.dismiss(animated: false)
        }

        
       
    }

}
