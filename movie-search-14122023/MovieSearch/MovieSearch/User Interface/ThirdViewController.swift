//
//  ThirdViewController.swift
//  MovieSearch
//
//  Created by user235795 on 12/13/23.
//

import UIKit

// MARK: - Third View Controller

class ThirdViewController: UIViewController {

    // Properties to receive data from DetailViewController
    var titleFromDetailVC: String?
    var yearFromDetailVC: String?
    var plotFromDetailVC: String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var plotLabel: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the received data to the labels
        titleLabel.text = titleFromDetailVC
        yearLabel.text = yearFromDetailVC
        plotLabel.text = plotFromDetailVC
    }

}

