import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (ProfileDataModel.sharedInstance.getOnboarding(1) == true) {
            performSegue(withIdentifier: "onboarding", sender: nil)
        }
    }
    
    @IBAction func unwindToMain(_ segue : UIStoryboardSegue){
        ProfileDataModel.sharedInstance.setOnboarding(1)
    }
    



}
