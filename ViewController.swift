//
//  ViewController.swift
//  BattleGeneraterApp
//
//  Created by 犬 on 2020/06/26.
//  Copyright © 2020 吉井 駿一. All rights reserved.
//

import UIKit
import Foundation
import GoogleMobileAds

class ViewController: UIViewController, GADInterstitialDelegate, UITextFieldDelegate{
    
    let interstitialADTestUnitID = "ca-app-pub-1923099754481403/1578764929"
    var interstitial: GADInterstitial!
    
    //文字数
    let maxLength = 10
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var backTitleView: UIView!
    @IBOutlet weak var redView: UIView!
    @IBAction func tappedSaveButton(_ sender: Any) {
        
        // nameの文字数チェック
        if (rivalNameTextField.text?.count ?? 0) > maxLength{
            print("文字数オーバー")
            let alert: UIAlertController = UIAlertController(title: "文字数オーバー", message: "名前は10文字以内にしてください", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
            
        else{
            let controller = UIActivityViewController(activityItems: ["#バトルメーカー", self.getImage(backImageView)], applicationActivities: nil)
            controller.popoverPresentationController?.sourceView = self.view
            controller.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            self.present(controller, animated: true, completion: nil)
            controller.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
                
                guard completed else { return }
                
                switch activityType {
                case UIActivity.ActivityType.saveToCameraRoll:
                    print("Saved to Camera Roll")
                    if self.interstitial.isReady {
                        self.interstitial.present(fromRootViewController: self)
                    } else {
                        print("Ad wasn't ready")
                    }
                default:
                    print("Done")
                }
            }
        }
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1923099754481403/1578764929")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("広告が閉じられました")
        interstitial = createAndLoadInterstitial()
    }
    
    // リターンキー押されたら
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボード非表示
        textField.resignFirstResponder()
        return true
    }
    //これで、キーボードをキーボードの外タップして消せる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var rivalView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gageLabel: UILabel!
    
    @IBOutlet weak var rivalImageView: UIImageView!
    @IBOutlet weak var ownImageView: UIImageView!
    
    @IBOutlet weak var monsterButton: UIButton!
    @IBOutlet weak var personButton: UIButton!
    
    @IBAction func tappedMonsterButton(_ sender: Any) {
        status = 0
        ueLabel.text = "あっ！ やせいの"
        sitaLabel.text = " が とびだしてきた！"
        monsterButton.layer.borderColor = UIColor.link.cgColor
        monsterButton.setTitleColor(UIColor.link, for: .normal)
        personButton.layer.borderColor = UIColor.gray.cgColor
        personButton.setTitleColor(UIColor.gray, for: .normal)
        nameTitleLabel.text = rivalNameTextField.text ?? ""
    }
    @IBAction func tappedPersonButton(_ sender: Any) {
        status = 1
        ueLabel.text = (rivalNameTextField.text ?? "") + " が"
        sitaLabel.text = "しょうぶを しかけてきたっ！"
        nameTitleLabel.text = ""
        monsterButton.layer.borderColor = UIColor.gray.cgColor
        monsterButton.setTitleColor(UIColor.gray, for: .normal)
        personButton.layer.borderColor = UIColor.link.cgColor
        personButton.setTitleColor(UIColor.link, for: .normal)
    }
    
    @IBOutlet weak var rivalNameTextField: UITextField!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var meButton: UIButton!
    @IBOutlet weak var youButton: UIButton!
    
    // どのボタンが押されたか
    var whichButton = 0
    //背景ボタン
    @IBAction func tappedBackButton(_ sender: Any) {
        
        whichButton = 0
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func tappedMeButton(_ sender: Any) {
        
        whichButton = 1
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func tappedYouButton(_ sender: Any) {
        
        whichButton = 2
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var ueLabel: UILabel!
    @IBOutlet weak var sitaLabel: UILabel!
    
    // これで人かモンスターか判断
    var status = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // admob
        self.interstitial = GADInterstitial(adUnitID: interstitialADTestUnitID)
        let request = GADRequest()
        interstitial.load(request)
        interstitial = createAndLoadInterstitial()
        self.interstitial.delegate = self
        
        self.rivalNameTextField.delegate = self
        
        rivalNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        
        monsterButton.layer.cornerRadius = 10
        personButton.layer.cornerRadius = 10
        monsterButton.layer.borderColor = UIColor.link.cgColor
        monsterButton.setTitleColor(UIColor.link, for: .normal)
        personButton.layer.borderColor = UIColor.gray.cgColor
        personButton.setTitleColor(UIColor.gray, for: .normal)
        monsterButton.layer.borderWidth = 2
        personButton.layer.borderWidth = 2
        
        backImageView.layer.borderColor = UIColor.black.cgColor
        backImageView.layer.borderWidth = 0.5
        
        titleView.layer.borderColor = UIColor.black.cgColor
        titleView.layer.borderWidth = 0.5
        titleView.layer.cornerRadius = 10
        titleView.layer.backgroundColor = UIColor.rgb(red: 90, green: 200, blue: 50).cgColor
        titleView.backgroundColor = .rgb(red: 109, green: 168, blue: 166)
        
        redView.layer.cornerRadius = 10
        
        rivalView.layer.cornerRadius = 5
        rivalView.layer.borderWidth = 1
        rivalView.layer.borderColor = UIColor.black.cgColor
        
        gageLabel.layer.cornerRadius = 2
        gageLabel.layer.borderWidth = 1
        gageLabel.layer.borderColor = UIColor.black.cgColor
        
        backButton.layer.cornerRadius = 10
        meButton.layer.cornerRadius = 10
        youButton.layer.cornerRadius = 10
        
        backButton.layer.borderWidth = 1
        meButton.layer.borderWidth = 1
        youButton.layer.borderWidth = 1
        
        backButton.layer.borderColor = UIColor.gray.cgColor
        meButton.layer.borderColor = UIColor.gray.cgColor
        youButton.layer.borderColor = UIColor.gray.cgColor
        
        let drawView = DrawView(frame: backImageView.bounds)
        
        backImageView.addSubview(drawView)
        backImageView.addSubview(backTitleView)
        backImageView.addSubview(rivalView)
        backImageView.addSubview(rivalImageView)
        backImageView.addSubview(ownImageView)
        
    }
    
    // UIViewからUIImageに変換する
    func getImage(_ view : UIView) -> UIImage {
        
        // キャプチャする範囲を取得する
        let rect = view.bounds
        
        // ビットマップ画像のcontextを作成する
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        // view内の描画をcontextに複写する
        view.layer.render(in: context)
        
        // contextのビットマップをUIImageとして取得する
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // contextを閉じる
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // textFieldの変化を取得する関数
    @objc func textFieldDidChange(){
        
        if status == 0{
            nameLabel.text = rivalNameTextField.text ?? ""
            nameTitleLabel.text = rivalNameTextField.text ?? ""
        }
        else if status == 1{
            nameLabel.text = (rivalNameTextField.text ?? "")
            ueLabel.text = (rivalNameTextField.text ?? "") + " が"
            
        }
    }
}

class DrawView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("DrawViewエラー")
    }
    
    override func draw(_ rect: CGRect) {
        
        // 自分のステージ
        let oval1 = UIBezierPath(ovalIn: CGRect(x: 10, y: (self.superview?.bounds.maxY)! - 110, width: 200, height: 100))
        // 内側の色
        UIColor.rgb(red: 125, green: 215, blue: 140).setFill()
        // 内側を塗りつぶす
        oval1.fill()
        // 線の色
        UIColor.rgb(red: 175, green: 250, blue: 115).setStroke()
        // 線の太さ
        oval1.lineWidth = 5
        // 線を塗りつぶす
        oval1.stroke()
        
        // 相手のステージ
        print("superView: ", self.superview as Any)
        let oval2 = UIBezierPath(ovalIn: CGRect(x: (self.superview?.bounds.maxX)! - 200 , y: (self.superview?.bounds.midY)! - 70, width: 180, height: 70))
        // 内側の色
        UIColor.rgb(red: 125, green: 215, blue: 140).setFill()
        // 内側を塗りつぶす
        oval2.fill()
        // 線の色
        UIColor.rgb(red: 175, green: 250, blue: 115).setStroke()
        // 線の太さ
        oval2.lineWidth = 5
        // 線を塗りつぶす
        oval2.stroke()
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage{
            if whichButton == 0{
                backImageView.image = editedImage
            }
            else if whichButton == 1{
                ownImageView.image = editedImage
            }
            else if whichButton == 2{
                rivalImageView.image = editedImage
            }
            
        }
        else if let originalImage = info[.originalImage] as? UIImage{
            if whichButton == 0{
                backImageView.image = originalImage
            }
            else if whichButton == 1{
                ownImageView.image = originalImage
            }
            else if whichButton == 2{
                rivalImageView.image = originalImage
            }
        }
        
        backImageView.contentMode = .scaleAspectFill
        ownImageView.contentMode = .scaleAspectFit
        rivalImageView.contentMode = .scaleAspectFit
        
        dismiss(animated: true, completion: nil)
    }
}
