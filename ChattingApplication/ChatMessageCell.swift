//
//  ChatMessageCell.swift
//  ChattingApplication
//
//  Created by XINHAO LI on 4/7/17.
//  Copyright © 2017 XINHAO LI. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message?
    
    var chatLogController: ChatLogController?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func handlePlay() {
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) {
            preparePlayer(url: url)
            print("Attempting to play video")
        } else if let voiceUrlStirng = message?.voiceUrl, let url = URL(string: voiceUrlStirng) {
            // Play recorded voice message
            preparePlayer(url: url)
            print("Attempting to play voice")
        }
        
    }
    
    private func preparePlayer(url: URL) {
        if player == nil {
            player = AVPlayer(url: url)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bubbleView.bounds
        bubbleView.layer.addSublayer(playerLayer!)
        
        player?.play()
        activityIndicatorView.startAnimating()
        playButton.isHidden = true
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        NotificationCenter.default.removeObserver(self)
        activityIndicatorView.stopAnimating()
        playerLayer?.removeFromSuperlayer()
        player?.seek(to: kCMTimeZero)
        playButton.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NotificationCenter.default.removeObserver(self)
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = .systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.setupShadowView()
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setupShadowView()
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        imageView.setupShadowView()
        return imageView

    }()
    
    func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        if let imageView = tapGesture.view as? UIImageView {
            // PRO Tip: don't perfom a lot of custom logic inside of view class
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
        
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    var playButtonLeftAnchor: NSLayoutConstraint?
    var playButtonCenterXAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        
        // Constraint anchors: x, y, width, height
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        // Constraint anchors: x, y, width, height
        playButtonCenterXAnchor = playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor)
        playButtonCenterXAnchor?.isActive = true
        playButtonLeftAnchor = playButton.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 4)
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bubbleView.addSubview(activityIndicatorView)
        // Constraint anchors: x, y, width, height
        activityIndicatorView.centerXAnchor.constraint(equalTo: playButton.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: playButton.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Constraint anchors: x, y, width, height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // Constraint anchors: x, y, width, height
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Constraint anchors: x, y, width, height
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
