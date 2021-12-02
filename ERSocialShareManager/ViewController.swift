//
//  ViewController.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 6/3/21.
//

import UIKit
import Photos
import FBSDKShareKit
import TikTokOpenSDK

class ViewController: UIViewController {
    
    var isVideo = false
    let videoPath = Bundle.main.path(forResource: "testVideo.mp4", ofType: nil)!
    let image = UIImage(named: "testImg.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TikTokOpenSDKApplicationDelegate.sharedInstance().logDelegate = self
    }
    
    @IBAction func didPressMediaTypeSwitch(_ sender: UISwitch) {
        isVideo = sender.isOn
    }
    
    @IBAction func didPresInstagramShareButton(_ sender: Any) {
        isVideo ? ERSocialShareManager.postVideoToInstagram(videoPath: videoPath) : ERSocialShareManager.postImageToInstagram(image: image)
    }
    
    @IBAction func didPressMessengerShareButton(_ sender: Any) {
        
        isVideo ? ERFBShareManager.shareVideoToFacebook(videoPath: videoPath, isMessenger: true) : ERFBShareManager.shareImageToFacebook(image: image, isMessenger: true)
    }
    
    @IBAction func didPressFBShareButton(_ sender: Any) {
        
        isVideo ? ERFBShareManager.shareVideoToFacebook(videoPath: videoPath, isMessenger: false) : ERFBShareManager.shareImageToFacebook(image: image, isMessenger: false)
    }
    
    @IBAction func didPressTikTokShareButton(_ sender: Any) {
        isVideo ? ERTikTokShareManager.shareVideoToTikTok(videoPath: videoPath) : ERTikTokShareManager.shareImageToTikTok(image: image)
    }
    
}

extension ViewController: SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
    }
}

extension ViewController: TikTokOpenSDKLogDelegate {
    func onLog(_ logInfo: String) {
        print(logInfo)
    }
}

