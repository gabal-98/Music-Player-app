//
//  ViewController.swift
//  project 8 ( Music player )
//
//  Created by robusta on 21/04/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        songs.append(Song(name: "Background Music", albumName: "123 Other", artistName: "ColdPlay", imageName: "image1", trackName: "song1"))
        songs.append(Song(name: "Havana", albumName: "Havana Album", artistName: "ColdPlay", imageName: "image2", trackName: "song2"))
        songs.append(Song(name: "Viva La Vida", albumName: "something 123", artistName: "ColdPlay", imageName: "image3", trackName: "song3"))
        
        songs.append(Song(name: "Background Music", albumName: "123 Other", artistName: "ColdPlay", imageName: "image4", trackName: "song4"))
        songs.append(Song(name: "Havana", albumName: "Havana Album", artistName: "ColdPlay", imageName: "image5", trackName: "song4"))
        songs.append(Song(name: "Viva La Vida", albumName: "something 123", artistName: "ColdPlay", imageName: "image6", trackName: "song5"))

    }


}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let song =  songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.imageView?.image = UIImage(named: "\(song.imageName)")
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else {
            return
        }
        vc.songs = songs
        vc.position = position
        present(vc, animated: true)
    }
}


struct Song{
    
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}
