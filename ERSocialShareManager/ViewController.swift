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
import SCSDKCreativeKit

class ViewController: UIViewController {
    
    var isVideo = false
    let videoPath = Bundle.main.path(forResource: "testVideo.mp4", ofType: nil)!
    let videoURL = Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
    let image = UIImage(named: "testImg.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TikTokOpenSDKApplicationDelegate.sharedInstance().logDelegate = self
    }
    
    @IBAction func didPressMediaTypeSwitch(_ sender: UISwitch) {
        AppManager.shared.lastSavedObjectPhassetIndentifier = ""
        isVideo = sender.isOn
    }
    
    @IBAction func didPresInstagramShareButton(_ sender: Any) {
        isVideo ? ERInstagramShareManager.postVideoToInstagram(videoPath: videoPath) : ERInstagramShareManager.postImageToInstagram(image: image)
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
    
    @IBAction func didPressSnapchatShareButton(_ sender: Any) {
        isVideo ? ERSnapchatShareManager.sharedInstance.shareVideoToSnapchat(videoURL: videoURL) : ERSnapchatShareManager.sharedInstance.shareImageToSnapchat(image: image)
    }
    
    @IBAction func didPressedYouTubeButton(_ sender: UIButton) {
        if isVideo == true {
            ERYouTubeShareManager.sharedInstance.shareVideoToYouTube(videoURL: videoURL)
        }
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

