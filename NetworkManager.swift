//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Taylor Smith on 8/9/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    func getCategories() {
        
        let url = "https://api.fusionofideas.com/todo/getCategories.php"
        
        Alamofire.request(url).responseJSON { response in
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    func post(params: Parameters, endpoint: EndPoints) {
        let url = "https://api.fusionofideas.com/todo/addCategory.php"
        let objects = ["name": "taylor's list"]
        
        Alamofire.request(url, method: .post, parameters: objects, encoding: JSONEncoding.default).responseJSON { response in
            
            
            print(response)
            
            print(url)
            print("api updated!")
            print(params)
        }
        
    }
    
    
}
