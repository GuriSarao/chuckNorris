//
//  LoginViewController.swift
//  Chuck Norris
//
//  Created by Kodion Softwares on 05/05/18.
//  Copyright © 2018 Zhixuan Lai. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var view_grouped: UIView!
    @IBOutlet weak var text_FirstName: UITextField!
    @IBOutlet weak var text_lastName: UITextField!
    @IBOutlet weak var btn_switch: UISwitch!
    @IBOutlet weak var btn_login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        view_grouped.layer.cornerRadius = 4
        view_grouped.clipsToBounds = true
        view_grouped.layer.borderColor = UIColor(red: 88/255, green: 100/255, blue: 125/255, alpha: 1.0).cgColor
        view_grouped.layer.borderWidth = 1
        
        btn_login.layer.cornerRadius = 4
    }

    @IBAction func btn_rememberClicked(_ sender: Any) {
    }
    
    @IBAction func btn_loginClicked(_ sender: Any) {
        
        if(self.text_FirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            
            let alert = UIAlertController(title: "Oops!", message: "Please enter your firstname.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if(self.text_lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "Oops!", message: "Please enter your lastname.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
            if(btn_switch.isOn){
                UserDefaults.standard.setValue("1", forKey: "Login")
                UserDefaults.standard.synchronize()
            }
            
            UserDefaults.standard.setValue(text_FirstName.text, forKey: "firstName")
             UserDefaults.standard.setValue(text_lastName.text, forKey: "lastName")
            UserDefaults.standard.synchronize()
            
            let viewController = ZLSwipeableViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
