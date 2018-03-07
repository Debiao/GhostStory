//
//  SdDataModel.swift
//  NightStory
//
//  Created by sundebiao on 2017/12/27.
//  Copyright © 2017年 Guangzhou Dartsworld Co.,Ltd. All rights reserved.
//

import UIKit

class SdDataModel: NSObject {
    
    var id: String?
    var title: String?
    var img: String?
    var desc: String?
    var link: String?
    var storyId: String?
    

    init(dict: [String: AnyObject]) {
        super.init()
        id = dict["id"] as? String
        title = dict["title"] as? String
        img = dict["img"] as? String
        desc = dict["desc"] as? String
        link = dict["link"] as? String
        storyId = dict["storyId"] as? String
    }
 
}
