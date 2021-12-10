//
//  ERYouTubeShareManager.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 12/10/21.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class ERYouTubeShareManager: NSObject {
    
    static let sharedInstance = ERYouTubeShareManager()
    
    private var service = GTLRYouTubeService()
    private var videoURL: URL?
    private let scopes = [kGTLRAuthScopeYouTube,
                          kGTLRAuthScopeYouTubeForceSsl,
                          kGTLRAuthScopeYouTubeUpload,
                          kGTLRAuthScopeYouTubeYoutubepartner]
    
    func shareVideoToYouTube(videoURL: URL) {
        self.videoURL = videoURL
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            self.service.authorizer = GIDSignIn.sharedInstance().currentUser.authentication.fetcherAuthorizer()
            presentYouTubeVC()
        }
        else{
            signInToYoutube()
        }
    }
    
    private func signInToYoutube(){
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signIn()
        //GIDSignIn.sharedInstance().signInSilently()
    }
    
    private func presentYouTubeVC() -> Void {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nav = storyboard.instantiateViewController(withIdentifier: "navYouTubeVC") as? UINavigationController {
            nav.modalPresentationStyle = .fullScreen
            guard let youTubeVC = nav.viewControllers.first as? ERYouTubeViewController else {return}
            youTubeVC.service = self.service
            youTubeVC.videoURL = self.videoURL
            guard let viewController = UIViewController.topMostViewController() else { return }
            viewController.present(nav, animated: true, completion: nil)
        }
    }
}

extension ERYouTubeShareManager: GIDSignInUIDelegate, GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            self.service.authorizer = nil
        } else {
            print("Succes")
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.presentYouTubeVC()
            }
        }
      }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("signIn called")
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dismiss called")
    }

}
