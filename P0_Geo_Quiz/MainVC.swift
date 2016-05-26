//
//  MainVC.swift
//  P0_Geo_Quiz
//
//  Created by Andy Xu on 16/5/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController {
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    @IBOutlet weak var answerButtonView: UIView!
    
    var countrySet = [Country]()
    var answerTag = [Int]()
    var answerButtonSet = [UIButton]()
    var state: States = .Hold
    let speechSynth = AVSpeechSynthesizer()
    
    enum States {
        case Hold, Ready, Playing, PlayAgain
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCountries()
    }

    
    func setupCountries() {
        var country: Country
        // Czech Language
        country = Country(name: "Czech", code: "cs-CZ", speechText: "Učení je celoživotní výkon.", flagImageFile: "czechFlag")
        countrySet.append(country)
        
        // Danish Language
        country = Country(name: "Danish", code: "da-DK", speechText: "Læring er en livslang stræben.", flagImageFile: "denmarkFlag")
        countrySet.append(country)
        
        // German Language
        country = Country(name: "German", code: "de-DE", speechText: "Lernen ist ein lebenslanger Verfolgung.", flagImageFile: "germanyFlag")
        countrySet.append(country)
        
        // Spanish Language
        country = Country(name: "Spanish", code: "es-ES", speechText: "El aprendizaje es una búsqueda que dura toda la vida.", flagImageFile: "spainFlag")
        countrySet.append(country)
        
        // country Language
        country = Country(name: "French", code: "fr-FR", speechText: "L'apprentissage est une longue quête de la vie.", flagImageFile: "franceFlag")
        countrySet.append(country)
        
        // Polish Language
        country = Country(name: "Polish", code: "pl-PL", speechText: "Uczenie się przez całe życie pościg.", flagImageFile: "polandFlag")
        countrySet.append(country)
        
        // English Language
        country = Country(name: "English", code: "en-US", speechText: "Learning is a life long pursuit.", flagImageFile: "unitedStatesFlag")
        countrySet.append(country)
        
        // Portuguese Language
        country = Country(name: "Portuguese", code: "pt-BR", speechText: "A aprendizagem é um longa busca que dura toda a vida.", flagImageFile: "brazilFlag")
        countrySet.append(country)
    }
    
    func prepareQuiz() {
        answerTag = [Int]()
        answerButtonView.alpha = 1.0
        listenButton.setTitle("Listen Audio", forState: .Normal)
        
        // MARK: 1. Select Random Answer
        answerTag = [Int(arc4random_uniform(UInt32(countrySet.count)))]
        let answerCountry = countrySet[answerTag[0]]
        
        // MARK: 2. Set answerButton for correct Answer
        let randomTag = Int(arc4random_uniform(3))
        var answerButton: UIButton?
        switch randomTag {
        case 0:
            answerButton1.tag = answerTag[0]
            answerButton = answerButton1
            answerButtonSet = [answerButton2, answerButton3]
        case 1:
            answerButton2.tag = answerTag[0]
            answerButton = answerButton2
            answerButtonSet = [answerButton1, answerButton3]
        case 2:
            answerButton3.tag = answerTag[0]
            answerButton = answerButton3
            answerButtonSet = [answerButton1, answerButton2]
        default:
            break
        }
        print("Correct Button: \(randomTag)")
        
        answerButton1.enabled = true
        answerButton2.enabled = true
        answerButton3.enabled = true
        
        guard answerButton != nil else {
            return
        }
        answerButton!.setTitle(answerCountry.name, forState: .Normal)
        answerButton!.setBackgroundImage(UIImage(named: answerCountry.flagImageFile), forState: .Normal)
        
        // MARK: 3. Set other answerButtons
        for button in answerButtonSet {
            var tag: Int
            repeat {
                tag = Int(arc4random_uniform(UInt32(countrySet.count)))
            } while answerTag.contains(tag)
            answerTag.append(tag)
            
            let country = countrySet[tag]
            button.setTitle(country.name, forState: .Normal)
            button.setBackgroundImage(UIImage(named: country.flagImageFile), forState: .Normal)
        }
        
        // MARK: 4. Set State
        state = .Ready
    }
    
    func clearQuiz() {
        answerButtonSet = [answerButton1, answerButton2, answerButton3]
        for answerButton in answerButtonSet {
            answerButton.setBackgroundImage(nil, forState: .Normal)
            answerButton.setTitle(nil, forState: .Normal)
            answerButton.enabled = false
        }
        listenButton.setTitle("Start Quiz", forState: .Normal)
        answerButtonView.alpha = 0.0
        
        state = .Hold
    }
    
    // MARK: - IBActions
    @IBAction func listenButtonOnClicked(sender: AnyObject) {
        switch state {
        case .Hold:
            prepareQuiz()
        case .Ready:
            // TODO: Play Sound
            playSound()
        case .Playing:
            // TODO: Stop Playing Sound
            stopPlayingSound()
        case .PlayAgain:
            playSound()
        }
    }
    
    @IBAction func answerButtonOnClicked(sender: AnyObject) {
        let playerSelection = (sender as? UIButton)?.tag
        
        let alertView = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Play Again", style: .Cancel) { (action) in
            self.clearQuiz()
        }
        alertView.addAction(alertAction)
        if playerSelection == answerTag.first {
            // Correct Answer
            alertView.title = "Congratulations"
            alertView.message = "You choosed the CORRECT answer!"
        } else {
            // Wrong Answer
            alertView.title = "Ooops"
            alertView.message = "You choosed the WRONG answer!"
        }
        presentViewController(alertView, animated: true, completion: nil)
    }
}

extension MainVC: AVSpeechSynthesizerDelegate {
    // MARK: - Play Sound Functions
    
    func playSound() {
        let country = countrySet[answerTag.first!]
        
        speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: country.speechText)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: country.code)
        speechSynth.delegate = self
        speechSynth.speakUtterance(speechUtterance)
        
        listenButton.setTitle("Stop", forState: .Normal)
        state = .Playing
    }
    
    func stopPlayingSound() {
        speechSynth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        
        listenButton.setTitle("Play Again", forState: .Normal)
        state = .PlayAgain
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        stopPlayingSound()
    }
}