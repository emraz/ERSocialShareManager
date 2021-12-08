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
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController {
    
    var isVideo = false
    let videoPath = Bundle.main.path(forResource: "testVideo.mp4", ofType: nil)!
    let videoURL = Bundle.main.url(forResource: "testVideo", withExtension: "mp4")!
    let image = UIImage(named: "testImg.jpg")!
    
    private let scopes = [kGTLRAuthScopeYouTube,
                          kGTLRAuthScopeYouTubeForceSsl,
                          kGTLRAuthScopeYouTubeUpload,
                          kGTLRAuthScopeYouTubeYoutubepartner]
    
    private var service = GTLRYouTubeService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TikTokOpenSDKApplicationDelegate.sharedInstance().logDelegate = self
    }
    
    @IBAction func didPressMediaTypeSwitch(_ sender: UISwitch) {
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
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            self.service.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
            self.presentYouTubeVC()
        }
        else{
            signInYoutube()
        }
    }
    
    func signInYoutube(){
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signIn()
    }
    
    func presentYouTubeVC() -> Void {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "YouTubeVC") as! YouTubeVC
        let navigationController = UINavigationController(rootViewController: vc)
        vc.service = self.service
         navigationController.modalPresentationStyle = .overCurrentContext
        vc.videoURL = self.videoURL
        self.present(navigationController, animated: true, completion: nil)
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

extension ViewController: GIDSignInUIDelegate, GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
          if let error = error {
              print(error.localizedDescription)
              service.authorizer = nil
          } else {
              print("Succes")
              self.service.authorizer = user.authentication.fetcherAuthorizer()
              self.presentYouTubeVC()
          }
      }
}
