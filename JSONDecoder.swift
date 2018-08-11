//
//  JSONDecoder.swift
//  ToDoList
//
//  Created by Taylor Smith on 8/10/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import Foundation

extension JSONDecoder {
    func decodeResponse(from response: DataResponse) -> Result {
        guard response.error == nil else {
            // got an error in getting the data, need to handle it
            print(response.error!)
            return .failure(response.error!)
        }
        
        // make sure we got JSON and it's a dictionary
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(BackendError.parsing(reason:
                "Did not get data in response"))
        }
        
        // turn data into expected type
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}
