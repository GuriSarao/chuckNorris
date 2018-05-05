//
//  AFWrapper.swift
//  DigiPro
//
//  Created by Kodion Softwares on 06/03/18.
//  Copyright © 2018 Kodion Softwares. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class AFWrapper: NSObject {
    
    class func requestGETURL(_ apiURl: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        if Connectivity.isConnectedToInternet() {
            
            Alamofire.request(apiURl).responseJSON { (responseObject) -> Void in
                
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        }else{
            
            let window = UIApplication.shared.keyWindow
            let alert = UIAlertController(title: "Oops!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
    }
    
    class func requestPOSTURL(_ apiURl : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        if Connectivity.isConnectedToInternet() {

//            var strURL:String = Constant.constant.baseUrl   // it gives http://www.stack.com/index.php and apiURl is apiSignUP
//
//            if((apiURl as NSString).length > 0)
//            {
//                strURL = strURL + "/" + apiURl    // this gives again http://www.stack.com/index.php/signup
//            }
            
            self.startAnimating()
            Alamofire.request(apiURl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
                
                self.stopAnimating()
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                    print(error.localizedDescription)
                }
            }
            
        }else{
            
            let window = UIApplication.shared.keyWindow
            let alert = UIAlertController(title: "Oops!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
    }
    
    class func uploadMultipartFormData(_ apiURl : String, params : [String : AnyObject]?, imageDataArray: [Data],imageNamesArray: [String], headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (NSError) -> Void) {
        
        if Connectivity.isConnectedToInternet() {
            
            self.startAnimating()
            
//            var strURL:String = Constant.constant.baseUrl   // it gives http://www.stack.com/index.php and apiURl is apiSignUP
//
//            if((apiURl as NSString).length > 0)
//            {
//                strURL = strURL + "/" + apiURl    // this gives again http://www.stack.com/index.php/signup
//            }
    
            Alamofire.upload(multipartFormData: { (MultipartFormData) in
                var secondCounter = 0
                for data in imageDataArray {
                    print(imageDataArray[secondCounter])
                    MultipartFormData.append(data, withName: imageNamesArray[secondCounter], fileName: imageNamesArray[secondCounter] + "myImage.jpg", mimeType: "image/jpg")
                    
                    //MultipartFormData.append(data, withName: imageNamesArray[secondCounter], fileName: imageNamesArray[secondCounter] + "myImage.png", mimeType: "image/png")
                    secondCounter = secondCounter + 1
                }
                

                let contentDict = params as? [String: String]
                for (key, value) in contentDict! {
                    MultipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }, to: apiURl, method: .post, headers: nil, encodingCompletion: { (result) in
                
                
                
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (dataResponse) in
                        self.stopAnimating()
                        print(dataResponse)
                        if dataResponse.result.error != nil {
                            failure(dataResponse.result.error! as NSError)
                        }
                        else {
                            print(dataResponse.result.value ?? "")
                            let resJson = JSON(dataResponse.result.value!)
                            success(resJson)
                        }
                    })
                case .failure(let encodingError):
                    self.stopAnimating()
                    failure(encodingError as NSError)
                }
            })
            
        }else{
            
            let window = UIApplication.shared.keyWindow
            let alert = UIAlertController(title: "Oops!", message: "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    class func startAnimating() {
        
        let window = UIApplication.shared.keyWindow
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: (window?.bounds.width)!, height: (window?.bounds.height)!)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        backgroundView.tag = 475647
        
        let LoadingView = UIView()
        LoadingView.frame = CGRect.init(x: backgroundView.frame.size.width/2  - 50, y: backgroundView.frame.size.height/2  - 50, width: 100, height: 100)
        LoadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        LoadingView.layer.cornerRadius = 10
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame =  CGRect.init(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = (LoadingView.center)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        //activityIndicator.color = UIColor.red
        activityIndicator.startAnimating()
        //backgroundView.isUserInteractionEnabled = false
        
        backgroundView.addSubview(LoadingView)
        backgroundView.addSubview(activityIndicator)
        
        
        window?.addSubview(backgroundView)
    }
    
    class func stopAnimating() {
        
        let window = UIApplication.shared.keyWindow
        if let background = window?.viewWithTag(475647){
            background.removeFromSuperview()
        }
        //backgroundView?.isUserInteractionEnabled = true
    }
    
}
