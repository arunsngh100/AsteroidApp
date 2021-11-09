//
//  APICallManager.swift
//  Asteroid Neo App
//
//  Created by Kashware Dev on 10/11/21.
//

import UIKit
import Alamofire

typealias SuccessResponse = (_ json : JSON) -> ()
typealias FailureResponse = (NSError) -> (Void)

public extension Notification.Name {
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
    static let NotConnectedToInternet = Notification.Name("Not Connected To Internet")
    static let networkReachable = Notification.Name("NetworkReachable")
}

extension NSError {
    
    convenience init(localizedDescription : String) {
        self.init(domain: "APIRequestManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        self.init(domain: "APIRequestManagerError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

let kAPIKey = "KlopFXTB6p1ooqqnLoXrp2dgnyjMpmVNvbONydIa"

let gAPICallManager = APICallManager.shared
class APICallManager: NSObject {

    static let shared = APICallManager()
}

extension APICallManager {
    
    func insertApiCallUsing(startDate: String, andEndDate endDate: String, completionHandler: @escaping (JSON) -> Void) {
        
        gActivityIndicator.startAnimating()
        guard let url = URL(string: "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDate)&end_date=\(endDate)&api_key=\(kAPIKey)") else { return }
        
        let dataRequest = AF.request(url, method: .get)
        dataRequest.responseJSON { response in
            gActivityIndicator.stopAnimating()
            switch(response.result) {
            case .success(let value):
                printAPICallManagerLogs("===================== RESPONSE =======================")
                let json = JSON(value)
                printAPICallManagerLogs(json)
                completionHandler(json)
                
             case .failure(let e):
                 printAPICallManagerLogs("===================== FAILURE =======================")
                let error = NSError(localizedDescription: e.localizedDescription)
                printAPICallManagerLogs(error)
                if (e as NSError).code == NSURLErrorNotConnectedToInternet {
                    NotificationCenter.default.post(name: .NotConnectedToInternet, object: nil)
                    AlertController.showToastWithMessage("please check internet connection")
                }
                else if (e as NSError).code == 4  {
                    AlertController.showToastWithMessage("something went wrong")
                }
                else {
                    
                }
            }
        }
    }
}

