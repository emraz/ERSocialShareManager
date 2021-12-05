//
//  ERSnapChatShareManager.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 12/5/21.
//

import UIKit
import SCSDKCreativeKit

class ERSnapchatShareManager: NSObject {
    
    static let sharedInstance = ERSnapchatShareManager()
    fileprivate lazy var snapAPI = {
        return SCSDKSnapAPI()
    }()
        
    func shareImageToSnapchat(image: UIImage) {
        
        //If you want to add sticker
        //guard let stickerImage = UIImage.init(named: "sticker") else {return}
        //let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
        
        let photo = SCSDKSnapPhoto(image: image)
        let photoContent = SCSDKPhotoSnapContent(snapPhoto: photo)
        
        //photoContent.sticker = sticker
        photoContent.caption = "Slideshow Maker"
        //You can add an URL
        //photoContent.attachmentUrl = "https://matrixsolution.xyz/"

        guard let viewController = UIViewController.topMostViewController() else { return }

        //disable user interaction until the share is over.
        viewController.view.isUserInteractionEnabled = false
        snapAPI.startSending(photoContent) { [weak viewController] (error: Error?) in
            viewController?.view.isUserInteractionEnabled = true
          // Handle response
        }
    }
    
    func shareVideoToSnapchat(videoURL: URL) {
        //If you want to add sticker
        //guard let stickerImage = UIImage.init(named: "sticker") else {return}
        //let sticker = SCSDKSnapSticker(stickerImage: stickerImage)
        
        let video = SCSDKSnapVideo(videoUrl: videoURL)
        let videoContent = SCSDKVideoSnapContent(snapVideo: video)
        
        //videoContent.sticker = sticker
        videoContent.caption = "Slideshow Maker"
        //You can add an URL
        //videoContent.attachmentUrl = "https://matrixsolution.xyz/"

        guard let viewController = UIViewController.topMostViewController() else { return }
        //disable user interaction until the share is over.
        viewController.view.isUserInteractionEnabled = false
        snapAPI.startSending(videoContent) { [weak viewController] (error: Error?) in
            viewController?.view.isUserInteractionEnabled = true
            // Handle response
        }
    }
    
    func shareStickerToSnapchat(image: UIImage) {
        
        let sticker = SCSDKSnapSticker(stickerImage: image)
        /* Alternatively, use a URL instead */
        // let sticker = SCSDKSnapSticker(stickerUrl: stickerImageUrl, isAnimated: false)

        /* Modeling a content using SCSDKNoSnapContent */
        let content = SCSDKNoSnapContent()
        content.sticker = sticker /* Optional */
        content.caption = "Slideshow Maker" /* Optional */
        content.attachmentUrl = "https://matrixsolution.xyz/" /* Optional */
        
        guard let viewController = UIViewController.topMostViewController() else { return }

        //disable user interaction until the share is over.
        viewController.view.isUserInteractionEnabled = false
        snapAPI.startSending(content) { [weak viewController] (error: Error?) in
            viewController?.view.isUserInteractionEnabled = true
          // Handle response
        }
    }
}
