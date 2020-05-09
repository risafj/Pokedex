import UIKit

class PokemonListViewController: UITableViewController, UISearchBarDelegate {
    // This contains all Pokemon data from the API call.
    var pokemon: [PokemonListResult] = []
    // This contains just the ones to be displayed.
    var displayPokemon: [PokemonListResult] = []
    
    @IBOutlet var searchBar: UISearchBar!

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting searchBar's delegate property to this controller.
        searchBar.delegate = self

        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let entries = try JSONDecoder().decode(PokemonListResults.self, from: data)
                self.pokemon = entries.results
                // Display all pokemon initially.
                self.displayPokemon = self.pokemon

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayPokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: displayPokemon[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPokemonSegue",
                let destination = segue.destination as? PokemonViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.url = pokemon[index].url
        }
    }

    // Called whenever the user changes the text in the search bar (including when cleared).
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            displayPokemon = pokemon
            return
        }

        displayPokemon = []
        for p in pokemon {
            if p.name.contains(searchText.lowercased()) {
                displayPokemon.append(p)
            }
        }
        tableView.reloadData()
    }
}
