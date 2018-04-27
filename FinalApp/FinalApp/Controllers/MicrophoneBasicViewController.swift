/**
 * Copyright IBM Corporation 2016, 2018
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import UIKit
import SpeechToTextV1
import NaturalLanguageUnderstandingV1

class MicrophoneBasicViewController: UIViewController {
    
    var speechToText: SpeechToText!
    var isStreaming = false
    var resultsOfSpeaking = ""
    
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechToText = SpeechToText(
            username: Credentials.SpeechToTextUsername,
            password: Credentials.SpeechToTextPassword
        )
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressMicrophoneButton(_ sender: UIButton) {
        if !isStreaming {
            isStreaming = true
            microphoneButton.setTitle("Stop Microphone", for: .normal)
            let failure = { (error: Error) in print(error) }
            var settings = RecognitionSettings(contentType: .opus)
            settings.interimResults = true
            speechToText.recognizeMicrophone(settings: settings, failure: failure) { results in
                print("Print your results of speaking",results.bestTranscript)
                self.textView.text = results.bestTranscript
                self.resultsOfSpeaking = results.bestTranscript
            }
        } else {
            
            speechToText.stopRecognizeMicrophone()
            
            print("Calling Allert")
            let alert = UIAlertController(title: "Task", message:"Enter your Task Number", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .default
                textField.placeholder = "Task Number"
                textField.clearButtonMode = .whileEditing
            }
            alert.addTextField { (textField: UITextField) in
                textField.keyboardAppearance = .dark
                textField.keyboardType = .decimalPad
                textField.autocorrectionType = .default
                textField.placeholder = "Progress"
                textField.clearButtonMode = .whileEditing
            }
            
            let submit = UIAlertAction(title: "save", style: .default, handler: { (action) -> Void in
                
                let textField = alert.textFields![0]
                print("Inside search ", textField.text!)
                let taskNo: Int? = Int(textField.text!)
                
                let progressField = alert.textFields![1]
                let progress: Float? = Float(progressField.text!)
                if (taskNo != nil && progress != nil) {
                    // Successfully converted String to Int
                    print(taskNo!)
                    self.fetchDataFromNLU(taskNo: taskNo!, progress: progress!)
                }
                 self.dismiss(animated: true, completion:nil)
            })
            
            
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: { (action) -> Void in})
            
            alert.addAction(submit)
            alert.addAction(cancel)
            
            alert.show()
            
            isStreaming = false
            microphoneButton.setTitle("Start Microphone", for: .normal)
        }
        }
    func fetchDataFromNLU(taskNo: Int, progress: Float) {
            let username = Credentials.NLUUsername
            let password = Credentials.NLUPassword
            let version = "2018-05-25" // use today's date for the most recent version
            let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: username, password: password, version: version)
            
            let features = Features(emotion: EmotionOptions(),sentiment: SentimentOptions())
            let parameters = Parameters(features: features, text: self.resultsOfSpeaking)
            let failure = { (error: Error) in
                
                print("Calling NLU error alert")
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in })
                alert.addAction(ok)
                self.present(alert, animated: true)
                print("Coming from here", error.localizedDescription)
                
                print(error) }
            var emotion = EmotionResult()
            var sentiment = SentimentResult()
//            var keywords:[KeywordsResult()] = KeywordsResult()
            naturalLanguageUnderstanding.analyze(parameters: parameters, failure: failure) {
                results in
              
                emotion = (results.emotion)!
                sentiment = (results.sentiment)!
        
                var topScore:Double = 0
                var emotionString = ""
                
                if(topScore < (emotion.document?.emotion?.anger)!){
                    topScore = (emotion.document?.emotion?.anger)!
                    emotionString = "Anger"
                }
                if(topScore < (emotion.document?.emotion?.fear)!){
                    topScore = (emotion.document?.emotion?.fear)!
                    emotionString = "Fear"
                }
                if(topScore < (emotion.document?.emotion?.joy)!){
                    topScore = (emotion.document?.emotion?.joy)!
                    emotionString = "Joy"
                }
                if(topScore < (emotion.document?.emotion?.sadness)!){
                    topScore = (emotion.document?.emotion?.sadness)!
                    emotionString = "Sadness"
                }
                if(topScore < (emotion.document?.emotion?.disgust)!){
                    topScore = (emotion.document?.emotion?.disgust)!
                    emotionString = "Disgust"
                }
                let sentimentLabel = sentiment.document?.label?.firstUppercased
                
                addUserNotes(taskNo: taskNo, description: self.resultsOfSpeaking, emotion: emotionString, sentiment: sentimentLabel!, progress: progress)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
            
        }
    
   
    }

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}



