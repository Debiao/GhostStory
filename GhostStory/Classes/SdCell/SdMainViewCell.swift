//
//  SdMainViewCell.swift
//  NightStory
//
//  Created by sundebiao on 2017/12/21.
//  Copyright © 2017年 Guangzhou Dartsworld Co.,Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class SdMainViewCell: UITableViewCell {
   
    var titleImage  =  UIImageView()
    var titleText    = UILabel()
    var contentText  = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setUpUI(){
        contentText.numberOfLines = 3
        contentText.font = UIFont.systemFont(ofSize: 12)
        titleImage = UIImageView()
     
      //  titleImage?.image = UIImage(named: "203A92364-0")
        
        self.addSubview(titleImage)
        self.addSubview(titleText)
        self.addSubview(contentText)
        
        self.titleImage.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.left.equalTo(self.snp.left).offset(10)
            make.width.equalTo(100);
            make.bottom.equalTo(self.snp.bottom).offset(-15)
            
        }
        
        self.titleText.snp.makeConstraints{ (make) in
            make.top.equalTo(self.snp.top).offset(15)
            make.left.equalTo(self.titleImage.snp.right).offset(15)
            make.height.equalTo(20)
        }
        
        self.contentText.snp.makeConstraints{ (make) in
            make.top.equalTo(self.titleText.snp.bottom).offset(10)
            make.left.equalTo(self.titleImage.snp.right).offset(15)
            make.bottom.equalTo(self.snp.bottom).offset(-15)
            make.right.equalTo(self.snp.right).offset(-15)
            make.width.equalTo(self.frame.size.width/2)
        }

    }
    
//    func setValueForCell(dic: NSDictionary) {
//        titleText.text = "45道菜谱"
//        contentText.text = "世界各地大排档的招牌美食"
//        //showImage!.image = UIImage(imageLiteral: "img.jpg")
//    }
    func setCellWithDataModelArr(dataModel:SdDataModel){
        titleText.text = dataModel.title
        contentText.text = dataModel.desc
        titleImage.kf.setImage(with: URL.init(string: dataModel.img!)!, placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
             })
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
