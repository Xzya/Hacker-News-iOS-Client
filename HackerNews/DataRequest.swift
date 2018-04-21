//
//  DataRequest.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 10/21/16.
//  Copyright © 2016 Null. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

extension DataRequest {

    func responseJSON() -> Promise<(DataResponse<Any>, [String: AnyObject])> {
        return Promise(resolvers: { (fulfill, reject) in
            self.responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: AnyObject] {
                        fulfill(response, json)
                        return;
                    }
                    reject(NSError.from(string: "Could not parse the data."))
                case .failure(let error):
                    reject(error)
                }
            }
        })
    }

    func responseString() -> Promise<(DataResponse<String>, String)> {
        return Promise(resolvers: { (fulfill, reject) in
            self.responseString { (response) in
                switch response.result {
                case .success(let value):
                    fulfill(response, value)
                case .failure(let error):
                    reject(error)
                }
            }
        })
    }

}
