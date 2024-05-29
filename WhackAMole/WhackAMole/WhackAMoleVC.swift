//
//  WhackAMoleVC.swift
//  WhackAMole
//
//  Created by Lakshmi on 5/29/24.
//

import UIKit
import Lottie
import AVFoundation

class WhackAMoleVC: UIViewController {

    var timeSetting: Timer?
    var initialScore = 0
    var totalTimeLeft = 60
    var moleImageClicked = [UIButton]()
    var MoleImagesTotal = 0
    var moleWhackedImages = 0
    var bombImages = 0
    var bombWhackedImages = 0
    var initialHighScore = 0
    
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var header:UILabel!
    @IBOutlet weak var StartBTN: UIButton!
    @IBOutlet weak var highScoreSv: UIView!
    @IBOutlet weak var timerSV: UIView!
    
    @IBOutlet weak var scoreSV: UIStackView!
    
    @IBOutlet weak var highScoreLBL: UILabel!
    
    @IBAction func onReset(_ sender: UIButton) {
        resetFunction()
    }
    
    @IBAction func onStart(_ sender: UIButton) {
        timeSetting = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(remainingTime), userInfo: nil, repeats: true)
    }
    @objc func remainingTime() {
        print("remaining")
        totalTimeLeft -= 1
        timelblModification()
        if totalTimeLeft <= 0 {
            gameOver()
            resetFunction()
        } else {
            updatingMoleholeImage()
        }
    }
    
    func updatingMoleholeImage() {
        for btnClicked in gameBtnCLCTN{
            btnClicked.setImage(UIImage(named: "hole"), for: .normal)
        }
        let index = Int.random(in: 0...8)
        print(index)
        let rdmImage = gameBtnCLCTN[index]
        let moleIsPresent = Bool.random()
        if moleIsPresent {
            rdmImage.setImage(UIImage(named: "mole"), for: .normal)
            moleImageClicked.append(rdmImage)
            MoleImagesTotal += 1
        } else {
            rdmImage.setImage(UIImage(named: "bomb"), for: .normal)
            bombImages += 1
        }
    }
    @IBAction func onClickGameBTN(_ sender: UIButton) {
        if moleImageClicked.contains(sender) {
            initialScore += 10
            moleWhackedImages += 1
            sender.setImage(UIImage(named: "moleHit"), for: .normal)
            moleImageClicked.remove(at: moleImageClicked.firstIndex(of: sender)!)
            scoreLBL.text = String(initialScore)
            AudioServicesPlaySystemSound(SystemSoundID(1001))
        } else if sender.currentImage == UIImage(named: "bomb") {
            initialScore -= 5
            bombWhackedImages += 1
            sender.setImage(UIImage(named: "blast"), for: .normal)
            scoreLBL.text = String(initialScore)
            AudioServicesPlaySystemSound(SystemSoundID(1322))
        }
    }
    
    
    @IBOutlet var gameBtnCLCTN: [UIButton]!
    
    @IBOutlet weak var timerLBL: UILabel!
    
    @IBOutlet weak var launchLAV: LottieAnimationView!{
        didSet {
            launchLAV.animation = .named("launch")
            launchLAV.alpha = 1    //alpha value modified
            launchLAV.play { [weak self] _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1,
                    delay: 0.0,
                    options: [.curveEaseInOut]
                ){
                    self?.launchLAV.alpha = 0.0
                }}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialHighScore = UserDefaults.standard.integer(forKey: "HighScore")
        highScoreLBL.text =  String(initialHighScore)
        self.view.backgroundColor = UIColor(red: 163/255, green: 210/255, blue: 86/255, alpha: 1.0)
        header.backgroundColor = UIColor(red: 0/255, green: 103/255, blue: 71/255, alpha: 1.0)
        borderImplementation(to: timerSV)
        borderImplementation(to: highScoreSv)
        borderImplementation(to: scoreSV)
        attributeCreatingButton(to: gameBtnCLCTN)
        // Do any additional setup after loading the view.
    }
    
    func borderImplementation(to view: UIView){
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.black.cgColor
    }
    
    func attributeCreatingButton(to button: [UIButton]){
        for btnClicked in button {
            btnClicked.layer.cornerRadius = 5.0
            btnClicked.layer.borderWidth = 2.0
            btnClicked.layer.borderColor = UIColor.black.cgColor
            btnClicked.contentVerticalAlignment = .fill
            btnClicked.contentHorizontalAlignment = .fill
            btnClicked.imageView?.contentMode = .scaleToFill
        }
    }
    
    func timelblModification() {
        let minutes = totalTimeLeft / 60
        let seconds = totalTimeLeft % 60
        timerLBL.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    func gameOver() {
        StartBTN.isEnabled = true
        let alert = UIAlertController(title: "Time’s Up! ⏱⏱", message: "Your Score is \(initialScore)\nYou have tapped on the mole \(moleWhackedImages) times out of \(MoleImagesTotal)\n You have tapped on the bomb  \(bombWhackedImages) times out of \(bombImages).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        if initialScore > initialHighScore {
            initialHighScore = initialScore
            UserDefaults.standard.set(initialHighScore, forKey: "HighScore")
        }
        highScoreLBL.text = String(initialHighScore)
        scoreLBL.text = String(initialScore)
    }
    
    func highScoreValueUpdate(){
        if initialScore > initialHighScore{
            initialHighScore = initialScore
            highScoreLBL.text = String(initialHighScore)
        }
    }
    
    func resetFunction() {
        totalTimeLeft = 60
        initialScore = 0
        moleWhackedImages = 0
        bombWhackedImages = 0
        MoleImagesTotal = 0
        bombImages = 0
        moleImageClicked.removeAll()
        for holeImage in gameBtnCLCTN {
            holeImage.setImage(UIImage(named: "hole"), for: .normal)
        }
        timerLBL.text = "01:00"
        scoreLBL.text = "0"
        StartBTN.isEnabled = true
        highScoreValueUpdate()
        AudioServicesPlaySystemSound(SystemSoundID(1152))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
