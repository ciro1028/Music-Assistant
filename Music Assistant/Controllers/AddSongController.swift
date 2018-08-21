//
//  AddSongController.swift
//  Music Assistant
//
//  Created by Ciro on 8/17/18.
//  Copyright © 2018 Ciro Amaral. All rights reserved.
//

import UIKit
import CoreData

protocol SongAddedDelegate {
    func reloadTableView()
}

class AddSongController: UIViewController {

    @IBOutlet weak var songTitle: UITextField!
    @IBOutlet weak var artistName: UITextField!
    @IBOutlet weak var lyrics: UITextView!
    
    var artistArray = [Artist]()
    
    var delegate : SongAddedDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var currentArtist : Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - Add New Song
    @IBAction func saveSong(_ sender: UIBarButtonItem) {
    
        var newArtist = Artist(context: self.context)
        let newSong = Song(context: self.context)
        
        newArtist = self.saveArtist(newArtist: newArtist)
        
        newSong.title = songTitle.text!
        newSong.lyrics = lyrics.text!
        
        newSong.parentArtist = currentArtist == nil ? newArtist : currentArtist
        
        self.saveSong()
        self.delegate?.reloadTableView()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    func saveSong(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func saveArtist(newArtist : Artist) -> Artist {
        
        // selects artist from db
        let artistPredicate = NSPredicate(format: "name MATCHES %@", artistName.text!)
        let request : NSFetchRequest<Artist> = Artist.fetchRequest()
        request.predicate = artistPredicate

        //check to see if artist name already exists
        do {
            artistArray = try context.fetch(request)
            
            if artistArray.count == 0 {
                do {
                    newArtist.name = artistName.text!
                    try context.save()
                    
                } catch {
                    print("Error saving artist context \(error)")
                }
            } else {
                context.delete(newArtist)
                currentArtist = artistArray[0]
            }
            
        } catch {
            print("Error fetching artist \(error)")
        }
        
        return newArtist
    }
    
}
