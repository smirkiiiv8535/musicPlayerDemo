//
//  MusicListViewController.swift
//  musicPlayerDemo
//
//  Created by 林祐辰 on 2020/12/5.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class MusicListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()
        setSongs()
        MusicListTable.delegate = self
        MusicListTable.dataSource = self
        
    }
    
   
    @IBOutlet weak var MusicListTable: UITableView!
    var songs = [Song]()
    func setSongs(){
        songs = [Song(mp3Name: "Monster", albumName: "Wonder", artistName: "Shawn Mendes", imageName: "shawn-wonder", trackName: "Monster"),
                 Song(mp3Name: "TheresNothingHoldingMeBack", albumName: "Illuminate", artistName: "Shawn Mendes", imageName: "shawn  illuminate", trackName: "There's nothing holding me back"),
                 Song(mp3Name: "Senorita", albumName: "Shawn Mendes", artistName: "Shawn Mendes", imageName: "shawn- shawn mendes", trackName: "Señorita"),
                 Song(mp3Name: "Starboy", albumName: "Starboy", artistName: "The Weekend", imageName: "weekend_starboy", trackName: "Starboy"),
                 Song(mp3Name: "BlindingLights", albumName: "After Hours", artistName: "The Weekend", imageName: "weekend_blindlights", trackName: "Blinding Lights"),
                 Song(mp3Name: "Photograph", albumName: "X", artistName: "Ed Sheerman", imageName: "ed _ X", trackName: "Photograph"),
                 Song(mp3Name: "TheATeam", albumName: "Plus", artistName: "Ed Sheerman", imageName: "ed _ plus", trackName: "The A Team"),
                 Song(mp3Name: "CastleOnTheHill", albumName: "Divide", artistName: "Ed Sheerman", imageName: "ed _divide", trackName: "Castle On The Hill"),
                 Song(mp3Name: "Walls", albumName: "Walls", artistName: "Kings of Leon" , imageName: "king_walls", trackName: "Walls"),
                 Song(mp3Name: "WaitForMe", albumName: "Mechanical Bull", artistName: "Kings of Leon", imageName: "king_mechanicalBull", trackName: "Wait For Me")]
        songs.shuffle()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = songs[indexPath.row]
        let cell = MusicListTable.dequeueReusableCell(withIdentifier: "cell") as? MusicListCell
        cell?.albumImage.image =  UIImage(named: "\(song.imageName)")
        cell?.artistName.text = song.artistName
        cell?.songName.text = song.trackName
        cell?.trackName.text = song.albumName
        cell?.overrideUserInterfaceStyle = .dark
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songPosition = indexPath.row
        
        guard let playerVC = self.storyboard?.instantiateViewController(identifier: "MusicPlayer") as? MusicPlayerViewController else {
            return
        }
        
        playerVC.position = songPosition
        playerVC.songs = songs
        present(playerVC, animated: true)
        
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    

}
