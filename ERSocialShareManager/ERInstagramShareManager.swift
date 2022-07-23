//
//  ERSocialShareManager.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 6/3/21.
//

import UIKit
import Photos
import FBSDKShareKit

class ERInstagramShareManager: NSObject {
    
    class func postImageToInstagram(image: UIImage) {
        if AppManager.shared.lastSavedObjectPhassetIndentifier.isEmpty{
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else{
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [AppManager.shared.lastSavedObjectPhassetIndentifier], options: nil)
            if let asset = assets.firstObject{
                ERInstagramShareManager.shareToInstagramWithPhasset(phasset: asset)
            }
            else{
                AppManager.shared.lastSavedObjectPhassetIndentifier = ""
                ERInstagramShareManager.postImageToInstagram(image: image)
            }
        }
    }
    
    class func postVideoToInstagram(videoPath: String) {
        if AppManager.shared.lastSavedObjectPhassetIndentifier.isEmpty {
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath) {
                UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            else {
                print("Video is not eligiable to save this path")
            }
        }
        else{
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: [AppManager.shared.lastSavedObjectPhassetIndentifier], options: nil)
            if let asset = assets.firstObject{
                ERInstagramShareManager.shareToInstagramWithPhasset(phasset: asset)
            }
            else{
                AppManager.shared.lastSavedObjectPhassetIndentifier = ""
                ERInstagramShareManager.postVideoToInstagram(videoPath: videoPath)
            }
        }
    }
    
    @objc class func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if error != nil {
            print(error!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ERInstagramShareManager.shareToInstagram(isVideo: false)
        }
    }
    
    @objc class func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error!)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ERInstagramShareManager.shareToInstagram(isVideo: true)
        }
    }
    
    private class func shareToInstagram(isVideo: Bool) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: isVideo ? false : true)]
        // it's weired the ascending value is different for video and image, no idea why
        // Need to check this matter later
        
        let fetchResult = isVideo ? PHAsset.fetchAssets(with: .video, options: fetchOptions) : PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if let lastAsset = fetchResult.lastObject {
            AppManager.shared.lastSavedObjectPhassetIndentifier = lastAsset.localIdentifier
            ERInstagramShareManager.shareToInstagramWithPhasset(phasset: lastAsset)
        }
    }
    
    private class func shareToInstagramWithPhasset(phasset: PHAsset){
        let url = URL(string: "instagram://library?LocalIdentifier=\(phasset.localIdentifier)")!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Instagram is not installed")
        }
    }
}
