//
//  YouTubeVC.swift
//  ERSocialShareManager
//
//  Created by Nazmul on 08/12/2021.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

class YouTubeVC: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    private let youtubeObject = GTLRYouTube_Video()
    var service = GTLRYouTubeService()
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleTextView.text = ""
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        
        let firstString = "Created By ERSocialShareManager"
        let secondString = "https://matrixsolution.xyz/"
        descriptionTextView.text = firstString + "\n" + secondString
        //GIDSignIn.sharedInstance().cu
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextView.becomeFirstResponder()
    }
    
    @IBAction func tappedOnCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOnShareButton(_ sender: UIButton) {
        self.uploadVideoOnYoutube()
    }
    
    func uploadVideoOnYoutube() {
        guard let videoUrl = self.videoURL else {return}
        
        //Status
        let status = GTLRYouTube_VideoStatus()
        status.privacyStatus = kGTLRYouTube_ChannelStatus_PrivacyStatus_Public
        //Snippet
        let snippet = GTLRYouTube_VideoSnippet()
        snippet.title = self.titleTextView.text
        snippet.descriptionProperty = self.descriptionTextView.text
        //snippet.de
        
        //Upload parameters
        let params = GTLRUploadParameters.init(fileURL: videoUrl, mimeType: "video/mp4")
        
        //YouTube Video object
        youtubeObject.status = status
        youtubeObject.snippet = snippet
        
        let query = GTLRYouTubeQuery_VideosInsert.query(withObject: youtubeObject, part: ["snippet","status"], uploadParameters: params)
       
        self.service.uploadProgressBlock = { (ticket, written, total) in
            let progressCalc: Float = (Float(written)/Float(total))
            print("\(progressCalc*100)%")
        }
        
        self.service.executeQuery(query, completionHandler: { (ticket, anyobject, error) in
            if error == nil {
                if let videoObject = anyobject as? GTLRYouTube_Video {
                    //print(videoObject.identifier ?? "upload")
                    print("SuccessFullYUpload")
                }
            } else {
                print(error?.localizedDescription)
            }
        })
    }
    
}
