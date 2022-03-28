//
//  BaseVC.swift
//  ConsoliAds Sample App
//
//  Created by OsamaNadeem on 12/13/21.
//

import UIKit

class BaseVC: UIViewController {

    var progressView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView = UIActivityIndicatorView(style: .large)
    }
    
    func showProgressBar(){
        self.progressView.center = view.center
        self.progressView.startAnimating()
        self.progressView.tintColor = UIColor.orange
        self.progressView.color = UIColor.orange
        view.addSubview(self.progressView)
        self.view.isUserInteractionEnabled = false
    }
    
    func hideProgressBar() {
        DispatchQueue.main.async {
            self.progressView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showAlert(heading: String, message: String) {
        DispatchQueue.main.async {
            self.hapticFeedback()
            let alert = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )            
        }
    }
    
    func hapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
            impactMed.impactOccurred()
    }
    
    func delegateDebugLog(message:String) {
        print("ConsoliAds-SDK \(message) called")
    }
}
