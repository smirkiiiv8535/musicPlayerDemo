//
//  ViewController.swift
//  musicPlayerDemo
//
//  Created by 林祐辰 on 2020/11/25.


import UIKit
import FirebaseAuth


class ViewController: UIViewController {

    
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var anonymousSignIN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        createAccountBtn.layer.cornerRadius = 16
        anonymousSignIN.layer.cornerRadius = 16
        handleSignIn()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
  
    @IBAction func signAsGuest(_ sender: Any) {
        Auth.auth().signInAnonymously { (randomUser, error) in
            guard error == nil else{
              return print("Error:\(error!.localizedDescription)")
             }
            guard let musicVc = self.storyboard?.instantiateViewController(identifier:"MusicList") as? MusicListViewController else{
                 return
            }
            musicVc.modalPresentationStyle = .fullScreen
            self.present(musicVc, animated: true)
            print("\(randomUser!.user.uid)")
          }
        }
    
    func handleSignIn(){
        guard let musicVc = self.storyboard?.instantiateViewController(identifier:"MusicList") as? MusicListViewController , let user = Auth.auth().currentUser else{
            return print("Confirmed SignIN")
        }
        musicVc.modalPresentationStyle = .fullScreen
        self.present(musicVc, animated: true)
    }
    
    @IBAction func unwindToViewVC(_ unwindSegue: UIStoryboardSegue) {

            
        }
    
    

    }
    
    




        

