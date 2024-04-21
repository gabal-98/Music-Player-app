//
//  PlayerViewController.swift
//  project 8 ( Music player )
//
//  Created by robusta on 21/04/2024.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    public var position: Int = 0
    public var songs: [Song] = []
    var player: AVAudioPlayer?
    
    var playPauseButton: UIButton?
    var sliderValue = Float(0.5)
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private var songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    @IBOutlet var holderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        if holderView.subviews.count == 0 {
            Configure()
        }
    }
    
    func Configure(){
        // setup player
        let song = songs[position]
        let url = Bundle.main.url(forResource: song.trackName, withExtension: "mp3")
        
        do{
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true , options: .notifyOthersOnDeactivation)
            
            guard let url = url else {
                print("url is nil")
                return
            }
            
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else {
                return
            }
            
            player.volume = sliderValue
            
            player.play()
        }catch{
            print("error")
        }
        
        imageView.frame = CGRect(x: 10, y: 10, width: holderView.frame.size.width - 20, height: holderView.frame.size.width - 20)
        imageView.image = UIImage(named: song.imageName)
        
        holderView.addSubview(imageView)
        
        songNameLabel.frame = CGRect(x: 10, y: imageView.frame.size.height + 10, width: holderView.frame.size.width - 20, height: 70)
        artistNameLabel.frame = CGRect(x: 10, y: imageView.frame.size.height + 10 + 70, width: holderView.frame.size.width - 20, height: 70)
        albumNameLabel.frame = CGRect(x: 10, y: imageView.frame.size.height + 10 + 140, width: holderView.frame.size.width - 20, height: 70)
        
        songNameLabel.text = song.name
        artistNameLabel.text = song.artistName
        albumNameLabel.text = song.albumName
        
        holderView.addSubview(songNameLabel)
        holderView.addSubview(artistNameLabel)
        holderView.addSubview(albumNameLabel)
        
        playPauseButton = UIButton()
        let nextButton = UIButton()
        let previousButton = UIButton()
        
        playPauseButton!.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        previousButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        playPauseButton!.tintColor = .black
        nextButton.tintColor = .black
        previousButton.tintColor = .black
        
        let yPosition = albumNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70
        
        playPauseButton!.frame = CGRect(x: (holderView.frame.size.width - size) / 2.0, y: yPosition, width: size, height: size)
        
        nextButton.frame = CGRect(x: holderView.frame.size.width - size - 20, y: yPosition, width: size, height: size)
        
        previousButton.frame = CGRect(x: 20, y: yPosition, width: size, height: size)
        
        previousButton.addTarget(self, action: #selector(switchToPreviousSong), for: .touchUpInside)
        playPauseButton!.addTarget(self, action: #selector(togglePlayingSong), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(switchToNextSong), for: .touchUpInside)
        
        holderView.addSubview(previousButton)
        holderView.addSubview(playPauseButton!)
        holderView.addSubview(nextButton)
        
        let soundSlider = UISlider()
        soundSlider.frame = CGRect(x: 20, y: holderView.frame.size.height - 60, width: holderView.frame.size.width - 40, height: 50)
        soundSlider.value = sliderValue
        soundSlider.addTarget(self, action: #selector(sliderTapped(_:)), for: .valueChanged)
        holderView.addSubview(soundSlider)
    }
    
    @objc func switchToPreviousSong(){
        if position > 0 {
            position -= 1
        }else {
            position = songs.count - 1
        }
        for view in holderView.subviews {
            view.removeFromSuperview()
        }
        Configure()
    }
        
        @objc func switchToNextSong(){
            if position < songs.count - 1 {
                position += 1
            }else {
                position = 0
            }
            for view in holderView.subviews {
                view.removeFromSuperview()
            }
            Configure()
        }
        
        @objc func togglePlayingSong(){
            if player?.isPlaying == true {
                player?.stop()
                playPauseButton!.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            }else {
                player?.play()
                playPauseButton!.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
                
            }
        }
        
        @objc func sliderTapped(_ slider: UISlider) {
            sliderValue = slider.value
            player?.volume = sliderValue
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            if let player = player {
                player.stop()
            }
        }
}
