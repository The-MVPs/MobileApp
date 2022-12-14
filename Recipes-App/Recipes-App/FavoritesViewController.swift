//
//  FavoritesViewController.swift
//  Recipes-App
//
//  Created by Omar Muniz on 12/14/22.
//

import UIKit
import Parse

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!

    //global object to store pfobject data
    var posts = [PFObject]()
    let myRefreshControl = UIRefreshControl()
    //var selectedCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        //set top bar title to the selected category. sent from previous page
        //self.title = selectedCategory
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Recipes")
        query.includeKey("author")
        query.whereKey("favorited", equalTo: true)
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell") as! FavoritesTableViewCell
        let post = posts[indexPath.row]
        //let user = post["author"] as! PFUser
        //cell.usernameLabel.text = user.username
        
        //set recipe title
        cell.titleLabel.text = post["title"] as? String
        //set photo:
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.feedPhotoView.af.setImage(withURL: url)
        //set description
        cell.descriptionLabel.text = post["description"] as? String
        //set prep time
        cell.prepTimeLabel.text = post["preparationTime"] as? String
        //set cooking time
        cell.cookTimeLabel.text = post["cookingTime"] as? String
        
        
        
        return cell

    }


}
