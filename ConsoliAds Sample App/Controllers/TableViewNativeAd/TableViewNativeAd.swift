//
//  TableViewNativeAd.swift
//  ConsoliAds Sample App
//
//  Created by OsamaNadeem on 12/9/21.
//

import UIKit
import ConsoliAdsSDK

class TableViewNativeAd: UITableViewController {

    func delegateDebugLog(message:String) {
        print("ConsoliAds-SDK \(message) called")
    }
    
    var tableViewItems: [AnyObject] = []
    var modulusInt: Int = 0
    var placeholderName:SdkPlaceholderName = Default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStrings()
        tableView.reloadData()
        
        if CASdk.sharedPlugIn().isInitSuccess() {
            tableView.register(UINib(nibName: "NativeAdCellView", bundle: nil), forCellReuseIdentifier: "NativeAdCellView")
            addNativeAd()
        }
        else {
            self.showAlert(heading: "SDK not initialized", message: "Initialize SDK before calling this function")
        }
    }
    
    func addNativeAd() {
        CASdk.sharedPlugIn().showNative(self.placeholderName, delegate: self)
    }
    
    func addStrings() {
        for _ in 0...10 {
            tableViewItems.insert(NSString("Dummy Text String"), at: 0)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let _ = tableViewItems[indexPath.row] as? NSString{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nativeCell", for: indexPath)

            cell.textLabel?.text = tableViewItems[indexPath.row] as? String

            return cell
        }
        else if let nativeAd = tableViewItems[indexPath.row] as? NativeAdBase {

            let reusableNativeItemCell = tableView.dequeueReusableCell(withIdentifier: "NativeAdCellView",
                                                                       for: indexPath)
            let nativeAdView = reusableNativeItemCell.contentView.subviews[0] as! SampleNativeAdView
                
            nativeAdView.adTitleLabel.text = nativeAd.nativeAdTitle
            nativeAdView.sponsoredLabel.text = nativeAd.nativeAdSubtitle
            nativeAdView.adBodyLabel.text = nativeAd.nativeAdDescription
            nativeAdView.adCallToActionButton.setTitle(nativeAd.callToActionButtonTitle, for: .normal)
            
            nativeAd.registerView(forInteraction: nativeAdView, mediaView: nativeAdView.adCoverMediaView, adChoicesView: nativeAdView.adOptionsView, adActionView: nativeAdView.adCallToActionButton, viewController: self)

            
            return reusableNativeItemCell;
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = tableViewItems[indexPath.row] as? NativeAdBase {
            return 450
        }
        else {
            return 50
        }
    }

}

extension TableViewNativeAd: CASDKNativeAdDelegate {
    
    func onAdLoaded(_ nativeAd: NativeAdBase!) {
        self.loadNewAdInTableViewAtIndex(selectedItemList: 0, nativeAd: nativeAd)
        self.delegateDebugLog(message: "onAdLoaded")
    }
    
    func onAdFailed(toLoad sceneId: String!, error: String!) {
        self.delegateDebugLog(message: "onAdFailed")
        print("onAdFailed " + error)
    }
    
    func onAdClicked(_ ProductId: String!) {
        self.delegateDebugLog(message: "onAdClicked")
    }
    
    func onLoggingImpression() {
        self.delegateDebugLog(message: "onLoggingImpression")
    }
    
    func onAdClosed() {
        self.delegateDebugLog(message: "onAdClosed")
    }
}

extension TableViewNativeAd {
    func loadNewAdInTableViewAtIndex(selectedItemList: Int, nativeAd: NativeAdBase){
        
        tableViewItems.insert(nativeAd, at: selectedItemList)
        var indexPaths: [IndexPath] = []
        indexPaths.append(IndexPath(row: selectedItemList, section: 0))
        
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func showAlert(heading: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: heading, message: message, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 1.25, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
        }
    }
}
