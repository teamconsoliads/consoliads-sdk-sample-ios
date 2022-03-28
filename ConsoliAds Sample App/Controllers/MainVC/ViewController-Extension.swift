//
//  ViewController-Extension.swift
//  ConsoliAds Sample App
//
//  Created by OsamaNadeem on 12/13/21.
//

import Foundation
import ConsoliAdsSDK

//---------------------- performSelectedFunction function definations ----------------------//
extension ViewController {
    func initConsoliAds() {
        self.showProgressBar()
        CASdk.sharedPlugIn().initWithAppKey(userSignature, andDelegate: self, userConsent: true, devMode: self.isDev, viewController: self)
        self.isDevSwitch.isHidden = true
    }
    
    func loadInterstitial() {
        if CASdk.sharedPlugIn().isInitSuccess() {
            self.showProgressBar()
            CASdk.sharedPlugIn().loadInterstitial(forScene: self.selectedPlaceholder)
        }
        else {
            self.showAlert(heading: "SDK not initialized", message: "Initialize SDK before calling this function")
        }
        
    }
    
    func showInterstitial() {
        if CASdk.sharedPlugIn().isInterstitialAvailable(self.selectedPlaceholder) {
            CASdk.sharedPlugIn().showInterstitial(self.selectedPlaceholder, withRootViewController: self)
        }
        else {
            self.showAlert(heading: "Ad not Loaded", message: "Call Load Method.")
        }
    }
    
    func loadRewarded() {
        
        if CASdk.sharedPlugIn().isInitSuccess() {
            self.showProgressBar()
            CASdk.sharedPlugIn().loadRewardedVideoAd(forScene: self.selectedPlaceholder)
        }
        else {
            self.showAlert(heading: "SDK not initialized", message: "Initialize SDK before calling this function")
        }
    }
    
    func showRewarded() {
        if CASdk.sharedPlugIn().isRewardedVideoAvailable(self.selectedPlaceholder) {
            CASdk.sharedPlugIn().showRewardedVideoAd(forScene: self.selectedPlaceholder, withRootViewController: self)
        }
        else {
            self.showAlert(heading: "Ad not Loaded", message: "Call Load Method.")
        }
    }
    
    func showCABanner() {
        
        if CASdk.sharedPlugIn().isInitSuccess() {
            if (bannerAdController == nil) {
                bannerAdController = CASDKBannerAdController()
            }
            if (bannerAdController != nil) {
                bannerAdController.destroyBanner()
            }
            CASdk.sharedPlugIn().showBanner(self.selectedPlaceholder, adSize: .KCAAdSizeBanner, controller: bannerAdController, delegate: self, viewController: self);
            bannerView.isHidden = false
        }
        else {
            self.showAlert(heading: "SDK not initialized", message: "Initialize SDK before calling this function")
        }
        
        
    }
    
    func destroyBanner() {
        if (bannerAdController != nil) {
            bannerAdController.destroyBanner()
            bannerAdController = nil
            self.bannerView.isHidden = true
        }
    }
    
    func showIcon() {
        
        if CASdk.sharedPlugIn().isInitSuccess() {
            self.destroyIcon()
            iconAdView = CAIconAdView();
            iconAdView.center = CGPoint(x: (Int(self.view.bounds.width)/2), y: Int(self.view.frame.height)/2)
            self.view.addSubview(iconAdView)
            iconAdView.rootViewController = self
            iconAdView.setAnimationType(CAIconAnimationTypes.KCAAdRotationIconAnimation, animationDuration: true)
            CASdk.sharedPlugIn().showIconAd(self.selectedPlaceholder, iconAdView: self.iconAdView, with: CAIconAdSize.KCAAdSizeSmallIcon, delegate: self)
        }
        else {
            self.showAlert(heading: "SDK not initialized", message: "Initialize SDK before calling this function")
        }
    }
    
    func destroyIcon() {
        if iconAdView != nil {
            iconAdView.destroy()
        }
    }
    
    func tableViewNativeView() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TableViewNativeAd") as? TableViewNativeAd
        vc?.placeholderName = self.selectedPlaceholder
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//---------------------- NavBar View Builder Function ----------------------//
extension ViewController {
    func makeRightNavBtn() {
        self.isDevSwitch = UISwitch()
        self.isDevSwitch.thumbTintColor = .orange
        self.isDevSwitch.isOn = true
        self.isDevSwitch.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        self.isDevSwitch.addTarget(self, action: #selector(rightBarBtnPressed), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = self.isDevSwitch
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @available(iOS 15.0, *)
    func makeLeftNavBtn() {
        self.placeholderBtn = UIButton()
        self.placeholderBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.placeholderBtn.setTitle("Default", for: .normal)
        self.placeholderBtn.setTitleColor(.orange, for: .normal)
        self.placeholderBtn.setTitleColor(.label, for: .highlighted)
        self.placeholderBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.placeholderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.placeholderBtn.addTarget(self, action: #selector(leftMenuBtnPressed(button:)), for: .touchUpInside)
        
        //
        var configuration = UIButton.Configuration.gray() // 1
        configuration.cornerStyle = .capsule // 2
        configuration.baseForegroundColor = UIColor.systemPink
        configuration.buttonSize = .mini
        self.placeholderBtn.configuration = configuration
        //
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = self.placeholderBtn
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func rightBarBtnPressed(mySwitch: UISwitch) {
        if mySwitch.isOn {
            isDev = true
        }
        else {
            isDev = false
        }
    }
    
    @objc func leftMenuBtnPressed(button: UIButton){
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Default", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = Default
                    self.placeholderBtn.setTitle("Default", for: .normal)
                }),
                UIAction(title: "MainMenu", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = MainMenu
                    self.placeholderBtn.setTitle("MainMenu", for: .normal)
                }),
                UIAction(title: "SelectionScene", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = SelectionScene
                    self.placeholderBtn.setTitle("SelectionScene", for: .normal)
                }),
                UIAction(title: "FinalScene", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = FinalScene
                    self.placeholderBtn.setTitle("FinalScene", for: .normal)
                }),
                UIAction(title: "OnSuccess", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = OnSuccess
                    self.placeholderBtn.setTitle("OnSuccess", for: .normal)
                }),
                UIAction(title: "OnFailure", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = OnFailure
                    self.placeholderBtn.setTitle("OnFailure", for: .normal)
                }),
                UIAction(title: "OnPause", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = OnPause
                    self.placeholderBtn.setTitle("OnPause", for: .normal)
                }),
                UIAction(title: "StoreScene", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = StoreScene
                    self.placeholderBtn.setTitle("StoreScene", for: .normal)
                }),
                UIAction(title: "Gameplay", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = Gameplay
                    self.placeholderBtn.setTitle("Gameplay", for: .normal)
                }),
                UIAction(title: "MidScene1", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = MidScene1
                    self.placeholderBtn.setTitle("MidScene1", for: .normal)
                }),
                UIAction(title: "MidScene2", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = MidScene2
                    self.placeholderBtn.setTitle("MidScene2", for: .normal)
                }),
                UIAction(title: "MidScene3", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = MidScene3
                    self.placeholderBtn.setTitle("MidScene3", for: .normal)
                }),
                UIAction(title: "AppExit", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = AppExit
                    self.placeholderBtn.setTitle("AppExit", for: .normal)
                }),
                UIAction(title: "LoadingScene1", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = LoadingScene1
                    self.placeholderBtn.setTitle("LoadingScene1", for: .normal)
                }),
                UIAction(title: "LoadingScene2", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = LoadingScene2
                    self.placeholderBtn.setTitle("LoadingScene2", for: .normal)
                }),
                UIAction(title: "onReward", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = onReward
                    self.placeholderBtn.setTitle("onReward", for: .normal)
                }),
                UIAction(title: "SmartoScene", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = SmartoScene
                    self.placeholderBtn.setTitle("SmartoScene", for: .normal)
                }),
                UIAction(title: "Activity1", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = Activity1
                    self.placeholderBtn.setTitle("Activity1", for: .normal)
                }),
                UIAction(title: "Activity2", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = Activity2
                    self.placeholderBtn.setTitle("Activity2", for: .normal)
                }),
                UIAction(title: "Activity3", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = Activity3
                    self.placeholderBtn.setTitle("Activity3", for: .normal)
                }),
                UIAction(title: "Activity4", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = Activity4
                    self.placeholderBtn.setTitle("Activity4", for: .normal)
                }),
                UIAction(title: "Activity5", image: UIImage(systemName: "theatermasks.circle.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), handler: { (_) in
                    self.selectedPlaceholder = Activity5
                    self.placeholderBtn.setTitle("Activity5", for: .normal)
                })
            ]
        }

        var demoMenu: UIMenu {
            return UIMenu(title: "Placeholders", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        placeholderBtn.menu = demoMenu
        placeholderBtn.showsMenuAsPrimaryAction = true
    }
    
}
