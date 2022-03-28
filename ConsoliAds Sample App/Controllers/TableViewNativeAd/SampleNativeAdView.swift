//
//  SampleNativeAdView.swift
//  Sample_Simulator_Project
//
//  Created by Fazal Elahi on 28/09/2021.
//

import Foundation
import UIKit
import ConsoliAdsSDK

class SampleNativeAdView: UIView {
    
    @IBOutlet weak var adIconView: UIImageView!
    @IBOutlet weak var adCoverMediaView: CANativeAdMediaView!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adBodyLabel: UILabel!
    @IBOutlet weak var adSocialContextLabel: UILabel!
    @IBOutlet weak var sponsoredLabel: UILabel!
    @IBOutlet weak var adCallToActionButton: UIButton!
    @IBOutlet weak var adOptionsView: CAAdChoicesView!
 
    func nativeTitleTextLabel() -> UILabel! {
        return self.adTitleLabel
    }
    
    func nativeBodyTextLabel() -> UILabel! {
        return self.adBodyLabel
    }
    
    func nativeAdvertiserTextLabel() -> UILabel! {
        return self.sponsoredLabel
    }
    
    func nativeIconImageView() -> UIImageView! {
        return self.adIconView
    }
    
    func nativeVideoView() -> UIView! {
        return self.adCoverMediaView
    }
    
    func nativeCallToActionButton() -> UIButton! {
        return self.adCallToActionButton
    }
    
    func nativePrivacyInformationIconImageView() -> UIView! {
        return self.adOptionsView
    }    
}
