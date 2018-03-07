//
//  SdParticularsViewController.swift
//  GhostStory
//
//  Created by FDart on 2018/1/18.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import SVProgressHUD
import SwiftyJSON


private var highly: CGFloat = 0
private var nav_alpha: CGFloat = 0

extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


class SdParticularsViewController: SdBaseViewController{
    
    var navView: UIView!
    var collectionBg: UIView!
    var BgView: UIView!
    var str: String?
    var strTitle: String?
    var strStoryId: String?
    var strStoryImg: String?
    var strStoryDesc: String?
    
    var numberTag : Int?
    var intTag : Int?
    
    var page: String?
    var navTitleLabel: UILabel!
    var htmlStr: String?
    var allPages: Int?
    var resultHtmlStr: String?
  
    var collectionBtn = UIButton()
   
    
    var loadHtmlStr = String()
    
    let textViewFont = UIFont.systemFont(ofSize: 18)
    
    var textview  = UITextView.init()
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        setStatusBarBackgroundColor(color: UIColor.clear)
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //setStatusBarBackgroundColor(color: UIColor.rgbColorFromHex(rgb: 0x7F8C8C))
        page = "1"
        SVProgressHUD.show(withStatus: "正在加载...")
        getData()
        creatWebView()
        
        SQLiteManager.sharInstance.HQBCreateTable(tableName: "storys", arFields: ["desc","storyId","img","link","title"], arFieldsType: [String(),String(),String(),
                                                                                                                                         String(),String()])
    
        
    }
    
    
    //插入文字
    func insertString(_ text:String) {
        
        //获取textView的所有文本，转成可变的文本
        let mutableStr = NSMutableAttributedString(attributedString: textview.attributedText)
        //获得目前光标的位置
        let selectedRange = textview.selectedRange
        //插入文字
        let attStr = NSAttributedString(string:text)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 27
        
        mutableStr.insert(attStr, at: selectedRange.location)
        
        //置可变文本的字体属性
        mutableStr.addAttribute(NSAttributedStringKey.font, value: textViewFont,
                                range: NSMakeRange(0,mutableStr.length))
        //设置字距
        mutableStr.addAttributes([NSAttributedStringKey.kern: 2], range: NSMakeRange(0,mutableStr.length))
        
        //mutableStr.addAttribute(NSAttributedStringKey.shadow, value: UIColor.red, range: NSMakeRange(0,mutableStr.length))
        mutableStr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.RGB_COLOR(104, g: 104, b: 104, alpha: 1), range: NSMakeRange(0,mutableStr.length))
        //再次记住新的光标的位置
        let newSelectedRange = NSMakeRange(selectedRange.location + attStr.length, 0)
        
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 5
        //样式属性集合
        mutableStr.addAttribute(NSAttributedStringKey.paragraphStyle,value: paraph,
                                range: NSMakeRange(0,mutableStr.length))
        
        //重新给文本赋值
        textview.attributedText = mutableStr
        //恢复光标的位置（上面一句代码执行之后，光标会移到最后面）
        textview.selectedRange = newSelectedRange
        
    }
    
    
    func creatWebView(){
        textview = UITextView(frame:CGRect(x:5, y:20, width:SCREEN_WIDTH-5, height:SCREEN_HEIGHT-20))
        //textview.layer.borderWidth = 1  //边框粗细
        textview.isEditable = false
        //textview.isSelectable = false
        //textview.layer.borderColor = UIColor.gray.cgColor //边框颜色
        self.view.addSubview(textview)
        textview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NavClick)))
    }
    
    @objc func NavClick(){
        makeNavView()
    }
    
 
    func getData(){
        let httpHeader = "https://www.sdbsearch.com/955-2" //"https://route.showapi.com/955-2"
        let showapIdStr = "?showapi_appid=33642"
        let storyStrId = "&id="
        let storyStrIdValue = strStoryId
        let pageStr = "&page="
        let pageStrValue = page
        let secretStr = "&showapi_sign=b8f27f88131240c8b8c39b2b8c6e6691"
        let URL = httpHeader+showapIdStr+storyStrId+storyStrIdValue!+pageStr+pageStrValue!+secretStr
        
        Alamofire.request(URL).responseJSON { response in
            if let JSONStr = response.result.value {
                self.htmlStr = JSON(JSONStr)["showapi_res_body"]["text"].string!
                self.allPages = JSON(JSONStr)["showapi_res_body"]["allPages"].int!
            }
            let a = self.htmlStr?.replacingOccurrences(of: "\r\n", with: "<br>")
            let b = a?.replacingOccurrences(of: "&nbsp;&nbsp;&nbsp", with: "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp")
            let c = b?.replacingOccurrences(of: "neirong336();", with:"故事开始于那个傍晚")
            self.insertString(c!.html2String)
           
            let pageValue = Int((self.page!))!
            if pageValue < self.allPages!{
                self.page = "\(pageValue+1)"
                self.getData()
            }else{
                SVProgressHUD.dismiss() 
            }
           
        }
        
     
    }
    
    
    // 导航栏
    func makeNavView() {
        
        BgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64))
        view.addSubview(BgView)
        BgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BgClick)))
        
        navView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        navView.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 108, alpha: 1)
        BgView.addSubview(navView)
        
        let BackBtn:UIButton = UIButton(type:.contactAdd)
        let iconSearchImage = UIImage(named:"详情界面返回按钮")?.withRenderingMode(.alwaysOriginal)
        BackBtn.addTarget(self, action:#selector(pop), for:.touchUpInside)
        
        BackBtn.setImage(iconSearchImage, for:.normal)
        BackBtn.adjustsImageWhenHighlighted=false //使触摸模式下按钮也不会变暗（半透明）
        BackBtn.adjustsImageWhenDisabled=false //使禁用模式下按钮也不会变暗（半透明
        navView.addSubview(BackBtn)
        
        BackBtn.snp.makeConstraints{ (make) in
            make.centerY.equalTo(navView).offset(8)
            make.left.equalTo(10)
            make.width.equalTo(30)
            make.height.equalTo(23)
        }
        
        navTitleLabel = UILabel(frame: CGRect(x: 5, y: 7, width: SCREEN_WIDTH, height: 64))
        navTitleLabel.text = strTitle
        navTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
        navTitleLabel.shadowColor =  UIColor.black //灰色阴影
        navTitleLabel.shadowOffset = CGSize(width:0, height:0)  //阴影的偏移量
        navTitleLabel.textColor = UIColor.white
        navView.addSubview(navTitleLabel)
        
        navTitleLabel.snp.makeConstraints{ (make) in
            make.centerY.equalTo(navView).offset(8)
            make.centerX.equalTo(navView)
            
        }
        
        
        collectionBg = UIView()
        collectionBg.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 108, alpha: 1)
        view.addSubview(collectionBg)
        
          collectionBg.snp.makeConstraints{ (make) in
          make.height.equalTo(44)
          make.width.equalTo(self.view)
          make.bottom.equalTo(self.view.snp.bottom)
        }
        
        
        collectionBtn = UIButton(type:.custom)
       // _ = UIImage(named:"搜索")?.withRenderingMode(.alwaysOriginal)
       // collectionBtn.setImage(iconSearchImage, for:.normal)
 
        collectionBtn.titleLabel?.textColor = UIColor.white
        collectionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        collectionBtn.isSelected = false
        collectionBtn.addTarget(self, action:#selector(collectionBtnClick), for:.touchUpInside)
        collectionBg.addSubview(collectionBtn)
        
        collectionBtn.snp.makeConstraints{ (make) in
            make.height.equalTo(44)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        
        let strStoryIds = JSON(SQLiteManager.sharInstance.HQBSelectFromTable(tableName: "storys", arFieldsKey:["storyId"]))
        if let storyArr = strStoryIds.arrayObject {
            var storyIdDict: NSDictionary = NSDictionary()
            for storyIdDic in  storyArr {
                storyIdDict = storyIdDic as! [String: AnyObject] as NSDictionary
                
                let storyID :String = storyIdDict["storyId"]! as! String
                
                if storyID == strStoryId! {intTag = 2}
               
            }
            if intTag == 2 {
                 collectionBtn.setTitle("取消收藏", for:.normal)
                 collectionBtn.isSelected = true
            }else{
                 collectionBtn.setTitle("添加收藏", for:.normal)
            }
        }

        
    }
    
    @objc func collectionBtnClick(){
        
        if collectionBtn.isSelected == true{
            
            SVProgressHUD.showInfo(withStatus: "取消成功");
            
            collectionBtn.isSelected = false
            
        
            SQLiteManager.sharInstance.HQBDeleteFromTable(tableName: "storys", FieldKey: "title", FieldValue: strTitle!)
            
            collectionBtn.setTitle("添加收藏", for:.normal)
            
            DispatchQueue(label: "延迟一秒").asyncAfter(deadline: .now() + 1.5)
            {
                SVProgressHUD.dismiss()
            }
          
            NotificationCenter.default.post(name: NSNotification.Name("refresh"), object: self, userInfo:nil)
            
            self.navigationController?.popViewController(animated: true)
            
        }else{
    
        SVProgressHUD.showInfo(withStatus: "已添加到收藏");

        DispatchQueue(label: "延迟一秒").asyncAfter(deadline: .now() + 1.5)
        {
            SVProgressHUD.dismiss()
        }
            
            
            let strStoryIds = JSON(SQLiteManager.sharInstance.HQBSelectFromTable(tableName: "storys", arFieldsKey:["storyId"]))
            
            if let storyArr = strStoryIds.arrayObject {
                var storyIdDict: NSDictionary = NSDictionary()
                
                if storyArr.count == 0 {
                    SQLiteManager.sharInstance.HQBInsertDataToTable(tableName:"storys", dicFields: ["desc":strStoryDesc!,"storyId":strStoryId!,"img":strStoryImg!,"link":"url","title":strTitle!])
                }else{
                    for storyIdDic in  storyArr {
                        storyIdDict = storyIdDic as! [String: AnyObject] as NSDictionary
                        
                        let storyID :String = storyIdDict["storyId"]! as! String
                        
                        if storyID == strStoryId! {
                            numberTag = 0
                        }
                    }
                    
                    if numberTag == 0{
                        collectionBtn.setTitle("取消收藏", for:.normal)
                    }else{
                        SQLiteManager.sharInstance.HQBInsertDataToTable(tableName:"storys", dicFields: ["desc":strStoryDesc!,"storyId":strStoryId!,"img":strStoryImg!,"link":"url","title":strTitle!])
                    }
                }
            }
            
            
        }
        self.BgClick()
   
        
        
    }
    
    @objc func BgClick(){
        collectionBg.isHidden = true
        BgView.isHidden = true

    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height - scrollView.contentOffset.y > 0 {
            let pageValue = Int((self.page!))!
            if pageValue < self.allPages!{
                self.page = "\(pageValue+1)"
                getData()
                
            }else{
                SVProgressHUD.showInfo(withStatus: "没有更多数据了");
                DispatchQueue(label: "延迟一秒").asyncAfter(deadline: .now() + 1)
                {
                    SVProgressHUD.dismiss()
                }
                
            }
        }
        
    }
    
    //设置状态栏背景颜色
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        /*
         if statusBar.responds(to:Selector("setBackgroundColor:")) {
         statusBar.backgroundColor = color
         }*/
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
