import UIKit

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var pushNotification: UISwitch!
    
    @IBOutlet weak var editProfileImage: UIImageView!
    
    @IBOutlet weak var newNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        editProfileImage.image = ProfileDataModel.sharedInstance.getProfileImage(1)
        pushNotification.isOn = ProfileDataModel.sharedInstance.getNotificationSettings(1) ?? false
        newNameTextField.text = ProfileDataModel.sharedInstance.getProfileData(1)?.name
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editProfileImage.layer.cornerRadius = editProfileImage.frame.size.width / 2.1
        editProfileImage.clipsToBounds = true
        
    }
    
    @IBAction func tapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "choose Image source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in print("user has chosen camera")
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in print("user has chosen photo library")
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        editProfileImage.image = selectedImage
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        ProfileDataModel.sharedInstance.updateProfileData(1, newNameTextField.text ?? "", editProfileImage.image!, pushNotification.isOn)
        
        
    }
    
    
    
    @IBAction func deleteAccountButtonTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete this Account? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        // Add the "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Add the "Delete" action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            TestDataModel.sharedInstance.deleteData()
            AchievementDataModel.sharedInstance.deleteData()
            BadgesDataModel.sharedInstance.deleteData()
            ProfileDataModel.sharedInstance.deleteData()
            JourneyDataModel.shared.deleteData()
            BookMarkedWords.sharedInstance.deleteData()
            BadgesDataModel.sharedInstance.resetToDefault()
            AchievementDataModel.sharedInstance.resetToDefault()
            ProfileDataModel.sharedInstance.resetToDefault()
                                exit(0)
            
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? UIWindowSceneDelegate,
               let window = delegate.window {
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // Adjust storyboard name as needed
                let initialViewController = storyboard.instantiateInitialViewController()
                window?.rootViewController = initialViewController
                window?.makeKeyAndVisible()
            }
        }
        alertController.addAction(deleteAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func navigateToMainPage() {
        // Logic to delete the item goes here
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateInitialViewController()
        
        sceneDelegate.window?.rootViewController = mainViewController
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    
    
}

