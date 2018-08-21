//
//  SongsViewController.swift
//  Music Assistant
//
//  Created by Ciro on 8/17/18.
//  Copyright © 2018 Ciro Amaral. All rights reserved.
//

import UIKit
import CoreData

class SongsViewController: UITableViewController, SongAddedDelegate{

    var songArray = [Song]()
    var artistArray = [Artist]()
    var isSearch = false
    var searchTerms = ""
    var songsForSection = [Song]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadArtists()
    }

    // MARK: - Table view data source
    
    //Tableview Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return artistArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return artistArray[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        determineRows(section: section)
        
        return songsForSection.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height:CGFloat = 30
        return height
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height:CGFloat = 60
        return height
    }
    
    //Tableview Rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        
        let song = songsForSection[indexPath.row]
        
        cell.textLabel?.text = song.title
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 24)
        tableView.tableFooterView = UIView()
        cell.detailTextLabel?.text = artistArray[indexPath.section].name!
 
        return cell
    }
    
    
    //MARK: Load data to populate tableview
    
    func loadArtists(with request : NSFetchRequest<Artist> = Artist.fetchRequest(), search: String = ""){
        
        if search != "" {
            
            var foundSongsArray = [Song]()
            let request : NSFetchRequest<Song> = Song.fetchRequest()
            let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
            request.predicate = searchPredicate
            request.sortDescriptors = [NSSortDescriptor(key: "parentArtist.name", ascending: true)]
            
            do {
                foundSongsArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            
            artistArray.removeAll()
            
            for song in foundSongsArray {
                artistArray.append(song.parentArtist!)
            }
            
        } else {
            
            do {
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                artistArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            
        }
        
    }
    
    func determineRows(section: Int){
        let currentArtist = artistArray[section].name
        let request : NSFetchRequest<Song> = Song.fetchRequest()
        let predicate = NSPredicate(format: "parentArtist.name MATCHES %@", currentArtist!)
        
        request.predicate = predicate
        
        do {
            songsForSection = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func loadSongs(with request : NSFetchRequest<Song> = Song.fetchRequest(), artist : String = "", predicate: NSPredicate) -> [Song]{
        
        
        return songArray
    }
    
    func reloadTableView(){
        self.loadArtists()
        self.tableView.reloadData()
    }
    
    //MARK: Segue related section
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoAddSong" {
            let destinationVC = segue.destination as! AddSongController
            destinationVC.delegate = self
        }
    }
    

}

//MARK: Search Bar Methods
extension SongsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        loadArtists(search: searchBar.text!)
        self.tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadArtists(search: searchBar.text!)
        searchTerms = searchBar.text!
        isSearch = true
        self.tableView.reloadData()
    }
    
}
