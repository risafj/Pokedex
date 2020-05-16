import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var pokemonId: Int!
    var caughtPokemon: [Int]!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var pokemonImage: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // https://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults
        caughtPokemon = UserDefaults.standard.array(forKey: "CaughtPokemon") as? [Int] ?? []

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        loadPokemon()
    }


    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    // Making the id accessible throughout the file.
                    self.pokemonId = result.id

                    // Load image synchronously
                    // https://stackoverflow.com/a/27517280/11249670
                    let imageUrl = URL(string: result.sprites.front_default)
                    let data = try? Data(contentsOf: imageUrl!)
                    self.pokemonImage.image = UIImage(data: data!)

                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    self.setCatchButtonLabel()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }

    // Called when the catch button is clicked.
    @IBAction func toggleCatch() {
        if caughtPokemon.contains(pokemonId) {
            // Remove id from caughtPokemon.
            // https://stackoverflow.com/a/24051661/11249670
            caughtPokemon = caughtPokemon.filter { $0 != pokemonId }
        } else {
            // Add id to caughtPokemon.
            caughtPokemon.append(pokemonId)
            UserDefaults.standard.set(caughtPokemon, forKey: "CaughtPokemon")
        }
        setCatchButtonLabel()
    }

    func setCatchButtonLabel() {
        let buttonLabel = caughtPokemon.contains(pokemonId) ? "Release" : "Catch"
        self.catchButton.setTitle(buttonLabel, for: .normal)
    }
}
