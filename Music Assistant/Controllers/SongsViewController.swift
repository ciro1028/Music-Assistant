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
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        
        var songs = [Song]()
        
        for song in songArray{
            if song.parentArtist == artistArray[section]{
                songs.append(song)
            }
        }
        
        return songs.count
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

        var songs = [Song]()
        
        for song in songArray{
            if song.parentArtist == artistArray[indexPath.section]{
                songs.append(song)
            }
        }
        
        let song = songs[indexPath.row]

        cell.textLabel?.text = song.title
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 24)
        tableView.tableFooterView = UIView()
        cell.detailTextLabel?.text = artistArray[indexPath.section].name!
 
        return cell
    }
    
    // Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToSong", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let destinationVc = segue.destination as! ViewSongController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            var songs = [Song]()
            
            for song in songArray {
                if song.parentArtist!.name! == artistArray[indexPath.section].name{
                    songs.append(song)
                }
            }
            destinationVc.selectedSong = songs[indexPath.row]
        }
    }
    
    //MARK: Load data to populate tableview
    //loads artists and songs from database
    func loadData(search: String = ""){
        
        //checks if method was triggered by search or viewDidLoad()
        let requestSongs : NSFetchRequest<Song> = Song.fetchRequest()
        requestSongs.sortDescriptors = [NSSortDescriptor(key: "parentArtist.name", ascending: true)]
        let requestArtists : NSFetchRequest<Artist> = Artist.fetchRequest()
        requestArtists.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if search != ""{
            let songPredicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
            requestSongs.predicate = songPredicate
            
            do{
                songArray = try context.fetch(requestSongs)
            } catch {
                print("Error fetching data from context \(error)")
            }
            
            artistArray.removeAll()
            
            for song in songArray{
                artistArray.append(song.parentArtist!)
            }
            
            artistArray = Array(Set(artistArray))
            
            artistArray = artistArray.sorted { $0.name! < $1.name!}
            
        } else {
            do{
                songArray = try context.fetch(requestSongs)
            } catch {
                print("Error fetching data from context \(error)")
            }
            
            do{
                artistArray = try context.fetch(requestArtists)
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
        
        
        tableView.reloadData()
    }
    
    func reloadTableView() {
        loadData()
        tableView.reloadData()
    }
    

}

//MARK: Search Bar Methods
extension SongsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        loadData(search: searchBar.text!)

    }
    
}
