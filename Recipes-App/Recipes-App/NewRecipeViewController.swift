//
//  NewRecipeViewController.swift
//  Recipes-App
//
//  Created by Omar Muniz on 11/27/22.
//

import UIKit
import AlamofireImage
import Parse
import DropDown

class NewRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var ingredientField: UITextView!
    @IBOutlet weak var directionsField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    //capturing input from the time pickers
    @IBOutlet weak var prepTimePicker: UIDatePicker!
    @IBOutlet weak var cookingTimePicker: UIDatePicker!
    //global variables for Date/Time pickers
    var prepTime = ""
    var cookingTime = ""
    var selectedCategory = ""
    let dropDown = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropdown()
        
    }
    @IBAction func onCameraRollButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        picker.sourceType = .photoLibrary
        present(picker, animated:true, completion: nil)
        print("camera roll")
        
    }
    //Opens Camera
    @IBAction func onCameraButton(_ sender: Any) {
        print("camera button")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else{
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    //Opens Photo Library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
        
    }
    //Clear image by tapping it
    @IBAction func onImageTap(_ sender: Any) {
        //set image to a system image
        imageView.image = UIImage(systemName:"camera.circle")
    }
    
    
    func secondsToHoursMinutes(_ seconds: Int) -> (Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    @IBAction func onPrepTimePicker(_ sender: Any) {
        var prepTimeVal = 0.0
        prepTimeVal = prepTimePicker.countDownDuration
        print(prepTimeVal)
        //time conversion from https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds
        let(h,m) = secondsToHoursMinutes(Int(prepTimeVal))
        //save as string to global var
        prepTime = "hours: " + String(h) + " minutes: " + String(m)
        print(prepTime)
    }
    @IBAction func onCookingTimePicker(_ sender: Any) {
        var cookingTimeVal = 0.0
        cookingTimeVal = cookingTimePicker.countDownDuration
        print(cookingTimeVal)
        //time conversion from https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds
        let(h,m) = secondsToHoursMinutes(Int(cookingTimeVal))
        cookingTime = "hours: " + String(h) + " minutes: " + String(m)
        print(cookingTime)
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        
        let post = PFObject(className: "Recipes")
        //get text field values and author
        post["title"] = titleField.text!
        post["description"] = descriptionField.text!
        post["author"] = PFUser.current()!
        post["ingredients"] = ingredientField.text!
        post["directions"] = directionsField.text!
        
        post["preparationTime"] = prepTime
        post["cookingTime"] = cookingTime
        //get image
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        post["image"] = file
        
        //send post request
        post.saveInBackground { success, error in
            if success {
                print("saved post!")
                //After successful post:
                //clear all data from screen
                self.titleField.text = nil
                self.descriptionField.text = nil
                self.ingredientField.text = nil
                self.directionsField.text = nil
                //clear image (set to default image)
                self.imageView.image = UIImage(systemName:"camera.circle")
                //clear time pickers
                self.prepTimePicker.countDownDuration = 0.0
                self.cookingTimePicker.countDownDuration = 0.0

                print("cleared creation screen")
            } else {
                print("error posting recipe!")
            }
        }
        
    }
    
    func setupDropdown(){
        dropDown.anchorView = selectCategoryButton
        dropDown.dataSource = ["Breakfast", "Lunch", "Dinner", "Dessert"]
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.selectCategoryButton.setTitle(item, for: .normal)
            self!.selectedCategory = String(item)
            print(self!.selectedCategory)
        }
    }
    @IBAction func onCategorySelect(_ sender: Any) {
        dropDown.show()
    }
    

    @IBAction func onPostAnotherButton(_ sender: Any) {
        print("pressed Post another Recipe")
        dismiss(animated: true, completion: nil)
        
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
