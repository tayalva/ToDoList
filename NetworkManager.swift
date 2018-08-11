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
    
    var catId = ""

    
    ////// Not using this method. I have it here in case of wanting to return all Categories from API
    
    func getCategories(completion: @escaping ([CategoryCodable]?, Error?) -> Void) {
        
        let url = "https://api.fusionofideas.com/todo/getCategories.php"
        
        Alamofire.request(url).responseJSON { response in
            
                let decoder = JSONDecoder()
            if let result = try? decoder.decode(CategoryResults.self, from: response.data!) {
                   completion(result.content, nil)
            } else {
                print("not decoded")
            }
            
        }
    }
    
    
   /////// POST method
    
    func post(params: Parameters, endpoint: EndPoints, completion: @escaping (String?, Error?) -> Void) {
        let url = "https://api.fusionofideas.com/todo/\(endpoint).php"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { response in
    
           
            
            if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                
                self.catId = jsonString.filter {"01234567890".contains($0)}
                
                completion(self.catId, nil)
                    
                }
  
        }
        
    }
    ////// DELETE method
    func delete(params: Parameters, endpoint: EndPoints) {
        
        let url = "https://api.fusionofideas.com/todo/\(endpoint).php"
        
        Alamofire.request(url, method: .delete, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            
            print(response)
        }
        
    }
    
   ///// UPDATE method
    func update(params: Parameters, endpoint: EndPoints) {
        let url = "https://api.fusionofideas.com/todo/\(endpoint).php"
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            
            print(response)
            
            
        }
        
    }

}
