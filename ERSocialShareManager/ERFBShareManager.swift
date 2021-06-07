//
//  ERFBShareManager.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 6/7/21.
//

import UIKit
import Photos
import FBSDKShareKit

class ERFBShareManager: NSObject {
    
    static var isMessenger = false
    
    class func shareVideoToFacebook(videoPath: String, isMessenger: Bool) {
        ERFBShareManager.isMessenger = isMessenger
        
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else {
            print("Video is not eligiable to save this path")
        }
    }
    
    class func shareImageToFacebook(image: UIImage, isMessenger: Bool) {
        let content = getPhotoContentforFB(image: image)
        isMessenger ? shareInMessenger(content: content) : shareInFacebook(content: content)
    }
    
    @objc class func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                print(error!)
            }
        ERFBShareManager.shareToFB()
    }
    
    private class func shareToFB() {
                
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // it's weired the ascending value is different for video and image, no idea why
        // Need to check this matter later

        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)

        if let lastAsset = fetchResult.lastObject {
            let content = getVideoContentforFB(videoAsset: lastAsset)
            
            ERFBShareManager.isMessenger ? shareInMessenger(content: content): shareInFacebook(content: content)
        }
    }
    
    class func getPhotoContentforFB(image: UIImage) -> SharingContent {
        
        // For sharing Photo
        let photo = SharePhoto(image: image, userGenerated: true)
        let photoContent = SharePhotoContent()
        photoContent.photos = [photo]
        
        // Hashtag
        //photoContent.hashtag = Hashtag("#MatrixSolution")
        
        // URL
        //photoContent.contentURL = URL.init(string: "https://matrixsolution.xyz/")!
        
        return photoContent
    }
    
    private class func getVideoContentforFB(videoAsset: PHAsset) -> SharingContent {
        
        // For sharing Video
        let video = ShareVideo.init(videoAsset: videoAsset)
        
        let videoContent = ShareVideoContent()
        videoContent.video = video
        
        // Hashtag
        //videoContent.hashtag = Hashtag("#MatrixSolution")
        
        // URL
        //videoContent.contentURL = URL.init(string: "https://matrixsolution.xyz/")!
        
        return videoContent
    }
    
    class func getLinkContentforFB(videoURL: URL) -> SharingContent {
        
        // For sharing link only
        let linkContent = ShareLinkContent()
        linkContent.contentURL = URL(string: "https://matrixsolution.xyz/")!
        
        // Optional
        linkContent.hashtag = Hashtag("#MatrixSolution")
        linkContent.quote = "MatrixSolution"
        
        return linkContent
    }
    
    class func getMediaContentforFB(image: UIImage, videoURL: URL) -> SharingContent {
        
        // For sharing Photo and Video both

        let photo = SharePhoto(image: image, userGenerated: true)

        let video = ShareVideo(videoURL: videoURL)

        let mediaContent = ShareMediaContent()
        mediaContent.media = [photo, video]
        
        return mediaContent
    }
    
    private class func shareInMessenger(content: SharingContent) {
        
        guard let viewController = UIViewController.topMostViewController() else { return }

        let dialog = MessageDialog(content: content, delegate: viewController as? SharingDelegate)
        
        // Recommended to validate before trying to display the dialog
        do {
            try dialog.validate()
        } catch {
            print(error)
        }
        
        dialog.show()
    }
    
    private  class func shareInFacebook(content: SharingContent) {
        guard let viewController = UIViewController.topMostViewController() else { return }
        
        let dialog = ShareDialog.init(fromViewController: viewController, content: content, delegate: viewController as? SharingDelegate)

        // Recommended to validate before trying to display the dialog
        do {
            try dialog.validate()
        } catch {
            print(error)
        }
        
        dialog.show()
    }
}


