//
//  Requests.swift
//  Stock
//
//  Created by Aleksandr on 15/05/2017.
//  Copyright © 2017 Records. All rights reserved.
//

import UIKit

class Requests
{
    func tickerPair(_ pairName: String, completion: @escaping (Dictionary<String, Any>) -> Void)
    {
        if let url = NSURL(string: API.BaseURL + "/ticker/" + pairName + "?ignore_invalid=1")
        {
            URLSession.shared.dataTask(with: url as URL) { data, response, error in
                
                if error == nil && data != nil
                {
                    if let responseJSON = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]
                    {
                        if let dict = responseJSON[pairName] as? Dictionary<String, Any>
                        {
                            completion(dict)
                        }
                    }
                }
                
            }.resume()
        }
    }
}
