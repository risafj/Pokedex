import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var isCaught: Bool?

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        setCatchButtonLabel()

        loadPokemon()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
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
                    // Note: Unwrapping optinal bools.
                    // https://stackoverflow.com/a/25523476/11249670
                    if self.isCaught ?? false {
                        self.setCatchButtonLabel()
                    } else {
                        self.isCaught = false
                        self.setCatchButtonLabel()
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }

    // Called when the catch button is clicked.
    @IBAction func toggleCatch() {
        if self.isCaught ?? false{
            self.isCaught = false
        } else {
            self.isCaught = true
        }
        setCatchButtonLabel()
    }

    func setCatchButtonLabel() {
        var buttonLabel: String
        if self.isCaught ?? false{
            buttonLabel = "Release"
        } else {
            buttonLabel = "Catch"
        }
        self.catchButton.setTitle(buttonLabel, for: .normal)
    }
}
