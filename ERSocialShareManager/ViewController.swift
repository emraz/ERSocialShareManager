//
//  ViewController.swift
//  ERSocialShareManager
//
//  Created by Mahmudul Hasan on 6/3/21.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    var isVideo = false
    let videoPath = Bundle.main.path(forResource: "testVideo.mp4", ofType: nil)!
    let image = UIImage(named: "testImg.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didPressMediaTypeSwitch(_ sender: UISwitch) {
        isVideo = sender.isOn
    }
    
    @IBAction func didPresInstagramShareButton(_ sender: Any) {
        isVideo ? ERSocialShareManager.postVideoToInstagram(videoPath: videoPath) : ERSocialShareManager.postImageToInstagram(image: image)
    }
}

