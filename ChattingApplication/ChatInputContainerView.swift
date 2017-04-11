//
//  ChatInputContainerView.swift
//  ChattingApplication
//
//  Created by XINHAO LI on 4/11/17.
//  Copyright © 2017 XINHAO LI. All rights reserved.
//

import UIKit
import AVFoundation

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    ////定义音频的编码参数，这部分比较重要，决定录制音频文件的格式、音质、容量大小等，建议采用AAC的编码方式
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),//声音采样率
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),//编码格式
        AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32)]//音频质量
    
    var chatLogController: ChatLogController? {
        didSet {
//            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
            
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(ChatLogController.handleUploadTap)))
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let sendButton = UIButton(type: .system)
    
    let uploadImageView: UIImageView = {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(uploadImageView)
        
        // Constraint anchors: x, y, width, height
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let tapSendGesture = UITapGestureRecognizer(target: self, action: #selector(handleSend))
        let holdSendGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleRecord))
        tapSendGesture.numberOfTapsRequired = 1
        sendButton.addGestureRecognizer(tapSendGesture)
        sendButton.addGestureRecognizer(holdSendGesture)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sendButton)
        
        // Constraint anchors: x, y, width, height
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(self.inputTextField)
        
        // Constraint anchors: x, y, width, height
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(separatorLineView)
        
        // Constraint anchors: x, y, width, height
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            // Init instant
            try audioRecorder = AVAudioRecorder(url: self.directoryURL()!, settings: recordSettings)
            // Ready to record
            audioRecorder.prepareToRecord()
        } catch {
            
        }
    }
    
    func directoryURL() -> URL? {
        //定义并构建一个url来保存音频，音频文件名为ddMMyyyyHHmmss.caf
        //根据时间来设置存储文件名
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".caf"
        print(recordingName)
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)
        return soundURL
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        return true
    }

    func handleSend(sender: UIGestureRecognizer){
        chatLogController?.handleSend()
    }

    func handleRecord(sender: UIGestureRecognizer){
        if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
            sendButton.backgroundColor = .red
            startRecord()
        } else if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
            sendButton.backgroundColor = .clear
            stopRecord()
            playRecordedMessage()
        }
    }
    
    func startRecord() {
        // Start recording message
        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                print("record!")
            } catch {
                
            }
        }
    }
    
    func stopRecord() {
        // End recording message
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
            print("stop!!")
        } catch {
            
        }
    }
    
    func playRecordedMessage() {
        // Play recorded voice message
        if (!audioRecorder.isRecording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
                audioPlayer.play()
                print("play!!")
            } catch {
                
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
