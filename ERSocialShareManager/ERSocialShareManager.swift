//
//  ERSocialShareManager.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 6/3/21.
//

import UIKit
import Photos

class ERSocialShareManager: NSObject {
    
    class func postImageToInstagram(image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    class func postVideoToInstagram(videoPath: String) {
        
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else {
            print("Video is not eligiable to save this path")
        }
    }
    
    @objc class func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
            if error != nil {
                print(error!)
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ERSocialShareManager.shareToInstagram(isVideo: false)
        }
    }
    
    @objc class func video(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                print(error!)
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ERSocialShareManager.shareToInstagram(isVideo: true)
        }
    }
    
    private class func shareToInstagram(isVideo: Bool) {
                
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: isVideo ? false : true)]
        // it's weired the ascending value is different for video and image, no idea why
        // Need to check this matter later

        let fetchResult = isVideo ? PHAsset.fetchAssets(with: .video, options: fetchOptions) : PHAsset.fetchAssets(with: .image, options: fetchOptions)

        if let lastAsset = fetchResult.lastObject {
            
            let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Instagram is not installed")
            }
        }
    }
}
