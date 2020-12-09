//
//  SignInViewController.swift
//  musicPlayerDemo
//
//  Created by 林祐辰 on 2020/12/4.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class SignInViewController: UIViewController, GIDSignInDelegate, LoginButtonDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
         signInByGoogle()
         let loginButton = FBLoginButton()
         loginButton.frame.origin = CGPoint(x: 90, y: 450)
         view.addSubview(loginButton)
         loginButton.delegate = self
         loginButton.permissions = ["public_profile ","email"]
         navigationController?.isNavigationBarHidden = false
    }
    //處理 Google  登入
   @IBOutlet weak var GoogleLoginBtn: GIDSignInButton!
    func signInByGoogle(){
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GoogleLoginBtn.frame = CGRect(x: 85, y: 520, width: 220, height: 10)
    }
    
      func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else{
           return print("Error: \(error.localizedDescription)")
        }
        guard let authentication = user.authentication else{
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (firebaseUser, error) in
            guard error == nil else{
                return print(error!.localizedDescription)
            }
            guard let musicVC = self.storyboard?.instantiateViewController(identifier: "MusicList") as? MusicListViewController else {
                return
            }
            self.GoogleLoginBtn.isEnabled = false
            musicVC.modalPresentationStyle = .fullScreen
            self.present(musicVC, animated: true)
        }
    }

    //處理 Facebook  登入
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
       guard let token = AccessToken.current, !token.isExpired else{
          return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        
         Auth.auth().signIn(with: credential) { (fbUser, error) in
            guard error == nil else{
                 return print(error!.localizedDescription)
               }
               guard let musicVC = self.storyboard?.instantiateViewController(identifier: "MusicList") as? MusicListViewController else {
                         return
                        }
                  musicVC.modalPresentationStyle = .fullScreen
                  self.present(musicVC, animated: true)
                  }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("log out")
    }

}
