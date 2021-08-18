//
//  MovieViewController.swift
//  Movies
//
//  Created by Yair Shlomo on 18/08/2021.
//

import UIKit
import DLRadioButton

class MovieViewController: UIViewController {
    public var movie: Movie? ;
    var completionHandler: ((Bool) -> Void)?
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var favButton: DLRadioButton!
    
    @IBOutlet weak var descLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = movie?.title
        descLabel.text = movie?.overview
        favButton.isIconSquare = true
        favButton.isMultipleSelectionEnabled = true
        favButton.isSelected = (movie?.fav ?? false) as Bool

    }


    @IBAction func didChanged(_ sender: Any) {
        completionHandler?(favButton.isSelected)
    }
    
    
}
