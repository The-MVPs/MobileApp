//
//  NewRecipeViewController.swift
//  Recipes-App
//
//  Created by Omar Muniz on 11/27/22.
//

import UIKit
import AlamofireImage
import Parse

class NewRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //formatter.dateFormat = "HH:mm" or hh:mm for 12 h
        
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
            } else {
                print("error posting recipe!")
            }
        }
        
        //navigate to Succes Page (will have either a back button,
        //or a button that says "post another" or something.
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
