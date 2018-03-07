//
//  SdHttpRequest.swift
//  NightStory
//
//  Created by sundebiao on 2017/12/25.
//  Copyright © 2017年 Guangzhou Dartsworld Co.,Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SdHttpRequest: NSObject {
    
    static let shareHttpRequest = SdHttpRequest()
    
    func getStoryData(page : Int, url:String, finished:@escaping (_ dataModel:[SdDataModel]) -> ()){

        Alamofire.request(url).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result)   // result of response serialization
            
            if let JSONStr = response.result.value {

                let error = JSON(JSONStr)["showapi_res_body"]["ret_code"]
              
                var dataMdels = [SdDataModel]()
                
                if error == -1{
                   finished(dataMdels)
                } else{
        
                if let newsLists = JSON(JSONStr)["showapi_res_body"]["pagebean"]["contentlist"].arrayObject {
                    for newsList in  newsLists {
                        let yp_newsList = SdDataModel(dict: newsList as! [String: AnyObject])
                        dataMdels.append(yp_newsList)
                    }
                    finished(dataMdels)
                }
                
                }
            
            }

        }
       
    }

}
   
                        

    
    
    
    
    

