//
//  DetailViewController.swift
//  FinalApp
//
//  Created by vishal diyora on 4/25/18.
//  Copyright © 2018 vishal diyora. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {


   
    @IBOutlet weak var taskProgress: UIProgressView!
   
    @IBOutlet weak var taskProgressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var taskNumber: UILabel!
    @IBOutlet weak var emotion: UILabel!
    @IBOutlet weak var sentiment: UILabel!
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let description = descriptionLabel,let tNo = taskNumber,let emo = emotion, let senti = sentiment, let pro = taskProgress, let proLabel = taskProgressLabel {
                description.text = detail.description
                tNo.text = "\(detail.taskNo)"
                emo.text = detail.emotion
                senti.text = detail.sentiment
                proLabel.text = "\(detail.progress)"
                pro.setProgress(detail.progress/100, animated: false)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: UserNotes? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

