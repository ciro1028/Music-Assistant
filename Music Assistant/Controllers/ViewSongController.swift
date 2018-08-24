//
//  ViewSongController.swift
//  Music Assistant
//
//  Created by Ciro on 8/24/18.
//  Copyright © 2018 Ciro Amaral. All rights reserved.
//

import UIKit

class ViewSongController: UIViewController {
    
    var selectedSong : Song = Song()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func loadSongIntoView(){
        
    }
}
