//
//  ViewController.swift
//  ConsoliAds Sample App
//
//  Created by OsamaNadeem on 12/7/21.
//

import UIKit
import ConsoliAdsSDK

class ViewController: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var bannerView: UIView!
    var iconAdView:CAIconAdView!
    var isDevSwitch:UISwitch!
    var placeholderBtn:UIButton!
    var bannerAdController:CASDKBannerAdController!
    
    var isDev = true
    var selectedPlaceholder: SdkPlaceholderName = Default
    //Insert your user-signature here
    let userSignature:String = ""
   
    let tableViewItems:[String] = ["Initialize ConsoliAds","Load InterstitialAd","Show InterstitialAd","Load RewardedAd", "Show RewardedAd", "Show BannerAd", "Destroy BannerAd", "Show Icon Ad", "Destroy IconAd", "Show Multiple NativeAd"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.initDelegates()
        self.makeRightNavBtn()
        if #available(iOS 15.0, *) {
            self.makeLeftNavBtn()
        } else {
            // Fallback on earlier versions
            self.placeholderBtn = UIButton()
            self.placeholderBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            self.placeholderBtn.setTitle("Default", for: .normal)
            self.placeholderBtn.setTitleColor(.orange, for: .normal)
            self.placeholderBtn.setTitleColor(.label, for: .highlighted)
            self.placeholderBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            self.placeholderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            self.placeholderBtn.addTarget(self, action: #selector(leftMenuBtnPressed(button:)), for: .touchUpInside)
            let leftBarButton = UIBarButtonItem()
            leftBarButton.customView = self.placeholderBtn
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        
    }
    
    func initDelegates() {
        CASdk.sharedPlugIn().setSdkInterstitialAdDelegate(self)
        CASdk.sharedPlugIn().setSdkRewardedAdDelegate(self)
        CASdk.sharedPlugIn().setSdkInAppDelegate(self)
    }
    
    func performSelectedFunction(index: Int, contextMenuInt: Int = 0) {
        
        switch index {
        case 0:
            self.initConsoliAds()
            break
            
        case 1:
            self.loadInterstitial()
            break
            
        case 2:
            self.showInterstitial()
            break
            
        case 3:
            self.loadRewarded()
            break
            
        case 4:
            self.showRewarded()
            break
            
        case 5:
            self.showCABanner()
            break
            
        case 6:
            self.destroyBanner()
            break
            
        case 7:
            self.showIcon()
            break
            
        case 8:
            self.destroyIcon()
            break
            
        case 9:
            self.tableViewNativeView()
            break
            
        case 10:
            break
        default:
            break
        }
    }
}

extension ViewController: ConsoliadsSdkInitializationDelegate {
    func onInitializationSuccess() {
        self.showAlert(heading: "Success", message: "SDK init successfully")
        self.hideProgressBar()
    }
    
    func onInitializationError(_ error: String!) {
        self.showAlert(heading: "ERROR", message: "SDK init error \(error ?? "Error nishta")")
        self.hideProgressBar()
    }
}

extension ViewController: ConsoliadsSdkInAppPurchaseDelegate {
    func on(inAppPurchaseRestored caInAppDetails: CAInAppDetails!) {
        print("Sample: inAppPurchaseRestored")
    }
    
    func on(inAppPurchaseSuccessed caInAppDetails: CAInAppDetails!) {
        print("Sample: inAppPurchaseSuccessed")
    }
    
    func on(inAppPurchaseFailed caInAppError: CAInAppError!) {
        print("Sample: inAppPurchaseFailed")
    }
    
}
extension ViewController: ConsoliadsSdkInterstitialAdDelegate {
    func onInterstitialAdLoaded(_ placeholderName: SdkPlaceholderName) {
        self.hideProgressBar()
        self.showAlert(heading: "Interstitial", message: "Loaded Successfully")
        self.delegateDebugLog(message: "onInterstitialAdLoaded")
    }
    
    func onInterstitialAdFailed(toLoad placeholderName: SdkPlaceholderName, reason: String!) {
        self.hideProgressBar()
        self.showAlert(heading: "Interstitial", message: "Loading Failed \(reason ?? "reason nishta")")
        self.delegateDebugLog(message: "onInterstitialAdFailedToLoad")
    }
    
    func onInterstitialAdClosed(_ placeholderName: SdkPlaceholderName) {
        self.showAlert(heading: "Interstitial", message: "Closed")
        self.delegateDebugLog(message: "onInterstitialAdClosed")
    }
    
    func onInterstitialAdClicked(_ placeholderName: SdkPlaceholderName, productId: String!) {
        self.showAlert(heading: "Interstitial", message: "Clicked")
        self.delegateDebugLog(message: "onInterstitialAdClicked")
    }
    
    func onInterstitialAdShown(_ placeholderName: SdkPlaceholderName) {
        self.delegateDebugLog(message: "onInterstitialAdShown")
    }
    
    func onInterstitialAdFailed(toShow placeholderName: SdkPlaceholderName) {
        self.delegateDebugLog(message: "onInterstitialAdFailedToShow")
    }
}

extension ViewController: ConsoliadsSdkRewardedAdDelegate {
    func onRewardedVideoAdLoaded(_ placeholderName: SdkPlaceholderName) {
        self.hideProgressBar()
        self.showAlert(heading: "Rewarded", message: "Loaded Successfully")
        self.delegateDebugLog(message: "onRewardedVideoAdLoaded")
    }
    
    func onRewardedVideoAdFailed(toLoad placeholderName: SdkPlaceholderName, reason: String!) {
        self.hideProgressBar()
        self.showAlert(heading: "Rewarded", message: "Loading Failed \(reason ?? "reason nishta")")
        self.delegateDebugLog(message: "onRewardedVideoAdFailedToLoad")
    }
    
    func onRewardedVideoAdShown(_ placeholderName: SdkPlaceholderName) {
        self.delegateDebugLog(message: "onRewardedVideoAdShown")
    }
    
    func onRewardedVideoAdFailed(toShow placeholderName: SdkPlaceholderName, reason: String!) {
        self.showAlert(heading: "Rewarded", message: "Show Failed \(reason ?? "reason nishta")")
        self.delegateDebugLog(message: "onRewardedVideoAdFailedToShow")
    }
    
    func onRewardedVideoAdCompleted(_ placeholderName: SdkPlaceholderName, reward: Int32) {
        self.delegateDebugLog(message: "onRewardedVideoAdCompleted")
    }
    
    func onRewardedVideoAdClosed(_ placeholderName: SdkPlaceholderName) {
        self.showAlert(heading: "Rewarded", message: "Closed")
        self.delegateDebugLog(message: "onRewardedVideoAdClosed")
    }
    
    func onRewardedVideoAdClicked(_ placeholderName: SdkPlaceholderName, productId: String!) {
        self.delegateDebugLog(message: "onRewardedVideoAdClicked")
    }
}

extension ViewController: CASDKIconAdDelegate {
    func didLoadedIconAd(_ scene: SdkPlaceholderName) {
        self.showAlert(heading: "IconAd", message: "Loaded Successfully")
        self.delegateDebugLog(message: "didLoadedIconAd")
    }
    
    func didFailed(toLoadIconAd scene: SdkPlaceholderName, error: String!) {
        self.showAlert(heading: "IconAd", message: "Loading Failed \(error ?? "error nishta")")
        self.delegateDebugLog(message: "didFailedToLoadIconAd")
    }
    
    func didCloseIconAd(_ scene: SdkPlaceholderName) {
        self.showAlert(heading: "IconAd", message: "Destroyed")
        self.delegateDebugLog(message: "didCloseIconAd")
    }
    
    func didClickIconAd(_ scene: SdkPlaceholderName, productId redirectionProductId: String!) {
        self.showAlert(heading: "IconAd", message: "Clicked")
        self.delegateDebugLog(message: "didClickIconAd")
    }
    
    func didRefreshIconAd(_ scene: SdkPlaceholderName) {
        self.showAlert(heading: "IconAd", message: "Refreshed")
        self.delegateDebugLog(message: "didRefreshIconAd")
    }
    
    func didDisplayIconAd(_ scene: SdkPlaceholderName) {
        self.showAlert(heading: "IconAd", message: "Displayed Successfully")
        self.delegateDebugLog(message: "didDisplayIconAd")
    }
    
    func didFailed(toDisplayIconAd scene: SdkPlaceholderName, error: String!) {
        self.showAlert(heading: "IconAd", message: "Failed to display \(error ?? "error nishta")")
        self.delegateDebugLog(message: "didFailedToDisplayIconAd")
    }
}

extension ViewController: CASDKBannerAdDelegate {
    func onBannerAdLoaded(_ scene: SdkPlaceholderName) {
        self.showAlert(heading: "Banner", message: "Loaded Successfully")
        self.delegateDebugLog(message: "onBannerAdLoaded")
        
        if let bController = self.bannerAdController , let banner = bController.bannerView {
            self.bannerView.isHidden = false
            self.bannerView.addSubview(banner)
            self.bannerView.bringSubviewToFront(banner)
            var center = self.bannerView.center
            center.y = (self.bannerView.frame.height / 2) - (banner.frame.height/2)
            banner.center = center
        }
    }
    
    func onBannerAdRefreshed(_ scene: SdkPlaceholderName) {
        self.showAlert(heading: "Banner", message: "Refreshed")
        self.delegateDebugLog(message: "onBannerAdRefreshed")
    }
    
    func onBannerAdFailed(toLoad scene: SdkPlaceholderName, error: String!) {
        self.showAlert(heading: "Banner", message: "Failed to load \(error ?? "error nishta")")
        self.delegateDebugLog(message: "onBannerAdFailed \(error ?? "error nishta")")
    }
    
    func onBannerAdClicked(_ scene: SdkPlaceholderName, productId redirectionProductId: String!) {
        self.showAlert(heading: "Banner", message: "Clicked")
        self.delegateDebugLog(message: "onBannerAdClicked")
    }
    
    func onBannerAdClosed(_ scene: SdkPlaceholderName) {
        self.showAlert(heading: "Banner", message: "Closed")
        self.delegateDebugLog(message: "onBannerAdClosed")
    }
}
