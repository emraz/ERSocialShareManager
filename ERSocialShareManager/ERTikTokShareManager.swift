//
//  ERTikTokShareManager.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 11/29/21.
//

import UIKit
import Photos
import TikTokOpenSDK

class ERTikTokShareManager: NSObject {
    
    class func shareImageToTikTok(image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc class func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
            if error != nil {
                print(error!)
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ERTikTokShareManager.shareToTikTok(isVideo: false)
        }
    }
    
    class func shareVideoToTikTok(videoPath: String) {
        
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else {
            print("Video is not eligiable to save this path")
        }
    }
    
    @objc class func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                print(error!)
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ERTikTokShareManager.shareToTikTok(isVideo: true)
        }
    }
    
    private class func shareToTikTok(isVideo: Bool) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: isVideo ? false : true)]
        // it's weired the ascending value is different for video and image, no idea why
        // Need to check this matter later
        
        let fetchResult = isVideo ? PHAsset.fetchAssets(with: .video, options: fetchOptions) : PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        //let app = TikTokOpenSDKApplicationDelegate.sharedInstance().isAppInstalled()
        let request = TikTokOpenSDKShareRequest()
        request.mediaType = isVideo ? TikTokOpenSDKShareMediaType.video : TikTokOpenSDKShareMediaType.image
        
        if let lastAsset = fetchResult.lastObject {
            
            var mediaLocalIdentifiers: [String] = []
            mediaLocalIdentifiers.append(lastAsset.localIdentifier)
            
            request.localIdentifiers = mediaLocalIdentifiers
            request.state = "d3d1d6a4d2c95921d10e635f04a0e5b4"
            request.hashtag = "ERSocialShareManager"
            request.landedPageType = .publish
            
            request.send(completionBlock: { resp -> Void in
                print(resp)
            })
        }
    }
}
