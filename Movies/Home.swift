//
//  ViewController.swift
//  Movies
//
//  Created by Yair Shlomo on 18/08/2021.
//

import UIKit
import DLRadioButton

class Home: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var allButton: DLRadioButton!
    @IBOutlet weak var favButton: DLRadioButton!
    var movies = [Movie]()
    var liveMovies = [Movie]()
    var filteredMovies = [Movie]()

    var apiKey : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let infoPlistPath = Bundle.main.url(forResource: "Secrets", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    apiKey = dict["API Key"] as? String
                }
            } catch {
                print(error)
            }
        }
        fetchMovies()
        tableView.delegate = self;
        tableView.dataSource = self;
        allButton.isSelected = true
    }
    
    // FETCH ALL MOVIES (trending)
    
    func fetchMovies() {
       let favUrl = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey ?? "")&Content-Type=application/json;charset%3Dutf-8"

        let headers : [String : String] = [:]
        let urlComps = URLComponents(string: favUrl)!

        
        HTTPManager.shared.get(urlComps: urlComps, headers: headers, completionBlock: { [weak self] data in
            guard let self = self else { return }
            switch data {
            case .failure(let error):
                print(error)

            case .success(let data):
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                        guard let moviesJson = json["results"] as? [Dictionary<String, Any>] else {
                            print("failed parse results")
                            return
                        }
                        
                        for movie in moviesJson {
                            guard let title = movie["title"] as? String else {
                                print("failed parse title")
                                return
                            }
                            guard let overview = movie["overview"] as? String else {
                                print("failed parse overview")
                                return
                            }
                            let movie = Movie(title: title, overview: overview)
                            self.filteredMovies.append(movie)
                            self.movies.append(movie)

                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        })
    }
    
    // TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        let movie = filteredMovies[indexPath.row]
        //configure
        cell.textLabel?.text = movie.title

        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // present the player
        let movie = filteredMovies[indexPath.row]
        //songs
        guard  let vc = storyboard?.instantiateViewController(identifier: "movie") as? MovieViewController else {
            return
        }
        vc.movie = movie
        vc.completionHandler = { bool in
            self.movies[indexPath.row].fav = bool

        }

        present(vc, animated: true)
        
    }
    
    // FILTERS

    @IBAction func allSelected(_ sender: DLRadioButton) {
        filteredMovies = movies
        print(movies[0].fav)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func favoriteSelected(_ sender: Any) {
        print(movies[0].fav)
        filteredMovies = movies.filter { $0.fav == true }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
}




