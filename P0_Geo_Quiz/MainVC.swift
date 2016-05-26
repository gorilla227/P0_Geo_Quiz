//
//  MainVC.swift
//  P0_Geo_Quiz
//
//  Created by Andy Xu on 16/5/25.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    
    var countrySet = [Country]()
    var answerTag = [Int]()
    var answerButtonSet = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCountries()
        prepareQuiz()
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
        
    }
    
//    func cleanQuiz() {
//        answerButton1.setTitle(nil, forState: .Normal)
//        answerButton1.setBackgroundImage(nil, forState: .Normal)
//        answerButton2.setTitle(nil, forState: .Normal)
//        answerButton2.setBackgroundImage(nil, forState: .Normal)
//        answerButton3.setTitle(nil, forState: .Normal)
//        answerButton3.setBackgroundImage(nil, forState: .Normal)
//        
//        listenButton.setTitle("Listen Audio", forState: .Normal)
//    }
    
    // MARK: - IBActions
    @IBAction func listenButtonOnClicked(sender: AnyObject) {
        // TODO: Play Sound
        
        
    }
    
    @IBAction func answerButtonOnClicked(sender: AnyObject) {
        let playerSelection = (sender as? UIButton)?.tag
        
        let alertView = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Play Again", style: .Cancel) { (action) in
            self.prepareQuiz()
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
