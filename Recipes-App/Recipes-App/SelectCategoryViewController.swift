//
//  SelectCategoryViewController.swift
//  Recipes-App
//
//  Created by Omar Muniz on 12/14/22.
//

import UIKit

class SelectCategoryViewController: UIViewController {

    @IBOutlet weak var breakfastButton: UIButton!
    
    @IBOutlet weak var lunchButton: UIButton!
    
    @IBOutlet weak var dinnerButton: UIButton!
    
    @IBOutlet weak var dessertButton: UIButton!
    
    var selectedCategory : String!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


    
    @IBAction func onSelectCategory(_ sender: Any) {
        let buttonText = (sender as AnyObject).titleLabel.text
        self.selectedCategory = buttonText!
        print("selecting category")
        print(selectedCategory!)
        performSegue(withIdentifier: "selectCategory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectCategory" {
            let Recipes = segue.destination as? FeedViewController
            Recipes?.selectedCategory = selectedCategory
        }
    }
    
}
