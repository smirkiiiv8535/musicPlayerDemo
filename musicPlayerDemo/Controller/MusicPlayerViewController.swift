//
//  MusicPlayerViewController.swift
//  musicPlayerDemo
//
//  Created by 林祐辰 on 2020/12/5.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController {
    
    // 依照所點的目錄號碼來載入歌曲資料
    var position:Int = 0
    var songs:[Song] = []
    
    // // 音樂播放器
    var player:AVAudioPlayer?
    
    var periodSlider :UISlider?
    
    @IBOutlet weak var musicViewHolder: UIView!
    
    // 程式碼產生元件
    let songImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

     let songName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(25)
        label.numberOfLines = 0
        return label
    }()
    
    let volumeLabel: UILabel = {
       let label = UILabel()
       label.numberOfLines = 0
       return label
   }()
    
    let playPauseButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 畫面用SubView來佈局 所以在viewDidLayoutSubviews後呼叫設置
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if musicViewHolder.subviews.count > 0 {
            configure()
        }
    }
    
    func configure(){
        let song = songs[position]
        songImage.image = UIImage(named: song.imageName)
        songName.text = song.trackName
        
        // 取得Mp3 檔案位置
        let songUrl = Bundle.main.path(forResource: song.mp3Name, ofType: "mp3")
        
        do {
            // 利用AVAudioSession 來確保其他軟體有聲音通知時也能收的到
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options:.notifyOthersOnDeactivation)

            guard let songUrl = songUrl else {
                return print("urlstring is nil")
            }

            // 依照Mp3 檔案位置撥放音樂
            player = try AVAudioPlayer(contentsOf: URL(string: songUrl)!)

            guard let player = player else{
                return
            }
            player.volume = 0.5
            player.play()
        }
        catch {
            print("error occurred")
        }
        
        songImage.frame = CGRect(x: 0,y: 30,width: 414, height: 360)
        songImage.image = UIImage(named: song.imageName)
        musicViewHolder.addSubview(songImage)


        songName.frame = CGRect(x: 10,
                                     y: songImage.frame.size.height + 80,
                                     width: musicViewHolder.frame.size.width-20,
                                     height: 50)
        volumeLabel.frame = CGRect(x: 40, y: 500, width:200, height: 50)
        songName.text = song.trackName
        volumeLabel.text = "Volume"
        musicViewHolder.addSubview(songName)
        musicViewHolder.addSubview(volumeLabel)

        //  播放按鈕
        let nextButton = UIButton()
        let backButton = UIButton()

        playPauseButton.frame = CGRect(x: (musicViewHolder.frame.size.width - 50) / 2.0,
                                       y: 600,
                                       width: 50,
                                       height: 50)

        nextButton.frame = CGRect(x: musicViewHolder.frame.size.width-70,
                                  y: 600,
                                  width: 50,
                                  height: 50)

        backButton.frame = CGRect(x: 20,y: 600,width: 50, height: 50)

        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

    
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)

        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black

        musicViewHolder.addSubview(playPauseButton)
        musicViewHolder.addSubview(nextButton)
        musicViewHolder.addSubview(backButton)

        let volumeSlider = UISlider(frame: CGRect(x: 140, y: 500, width:200, height: 50))
        volumeSlider.value = 0.5
        volumeSlider.addTarget(self, action: #selector(didVolumeSlider(slider:)), for: .valueChanged)
        
       periodSlider = UISlider(frame: CGRect(x: 50, y: 670, width:300, height: 70))
        periodSlider?.value = 0
        periodSlider?.maximumValue = Float(Double(player!.duration))
        periodSlider?.addTarget(self, action: #selector(didPeriodSlider(slider:)), for: .valueChanged)
        
        musicViewHolder.addSubview(volumeSlider)
        musicViewHolder.addSubview(periodSlider!)
    }
    
   //  音量調整
    @objc func didVolumeSlider(slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }

    //  歌曲進度調整
    @objc func didPeriodSlider(slider: UISlider) {
        let value = slider.value
        player?.currentTime = TimeInterval(value)
        player?.prepareToPlay()
        player?.play()
    }
    
    //  按上一首歌的動作
    @objc func didTapBackButton() {
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in musicViewHolder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }

   //  按下一首歌的動作
    @objc func didTapNextButton() {
        if position < (songs.count - 1) {
            position = position + 1
            player?.stop()
            for subview in musicViewHolder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }

    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else {
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
     
    // 滑下Subview 時, 停止播放音樂
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let player = player {
            player.stop()
        }
    }
}
