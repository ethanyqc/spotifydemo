//
//  ViewController.swift
//  SPPlayer
//
//  Created by Eduardo Irias on 11/2/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate let trackIdentifier = "spotify:track:6XZLlfwcvmM2LSobNGfvzM"
    
    var appRemote: SPTAppRemote {
        get {
            return (UIApplication.shared.delegate as? AppDelegate)!.appRemote
        }
    }
    
    fileprivate var playerState: SPTAppRemotePlayerState?

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        playButton.setTitle("Loading", for: UIControl.State.normal)
        playButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(appRemoteConnected), name: NSNotification.Name.appRemoteDidEstablishConnection, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appRemoteNotConnected), name: NSNotification.Name.didFailConnectionAttemptWithError, object: nil)
    }
   
    func setLayout(track: SPTAppRemoteTrack) {
        songTitleLabel.text = track.name
        appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 512, height: 512), callback: { (image, error) -> Void in
            guard error == nil else { return }
            
            self.coverImageView.image = image as? UIImage
        })
    }
    
    func refreshState() {
        appRemote.playerAPI?.getPlayerState { (result, error) -> Void in
            guard error == nil else { return }
            
            let playerState = result as! SPTAppRemotePlayerState
            self.playerState = playerState
            self.playButton.setTitle(self.playerState?.isPaused == true ? "Play" : "Pause", for: UIControl.State.normal)
            self.setLayout(track: playerState.track)
        }
    }
    
    @objc func appRemoteNotConnected() {
         self.playButton.setTitle("Connect", for: UIControl.State.normal)
        playButton.isEnabled = true
    }
    
    @objc func appRemoteConnected() {
        appRemote.playerAPI!.delegate = self
        appRemote.userAPI!.delegate = self
        refreshState()
        playButton.isEnabled = true
    }

    @IBAction func playStop(_ sender: Any) {
        if !(appRemote.isConnected) {
            if (!appRemote.authorizeAndPlayURI(trackIdentifier)) {
                // The Spotify app is not installed, present the user with an App Store page
                //showAppStoreInstall()
            }
        } else if playerState == nil || playerState!.isPaused {
            //appRemote.playerAPI?.play(trackIdentifier, callback: defaultCallback)
            //appRemote.playerAPI?.resume(defaultCallback)
            appRemote.playerAPI?.resume({ (status, error) in
                self.refreshState()
            })
        } else {
            appRemote.playerAPI?.pause({ (status, error) in
                self.refreshState()
            })
        }
    }

}

extension ViewController: SPTAppRemotePlayerStateDelegate, SPTAppRemoteUserAPIDelegate {
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        self.playerState = playerState
        self.setLayout(track: playerState.track)
    }
    
    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
        
    }
}
