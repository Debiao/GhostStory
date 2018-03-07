//
//  SdDetailsViewController.swift
//  GhostStory
//
//  Created by sundebiao on 2018/1/6.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import SVProgressHUD

private var highly: CGFloat = 0
private var nav_alpha: CGFloat = 0

class SdDetailsViewController: SdBaseViewController,UIWebViewDelegate,UIScrollViewDelegate{
    
    var bgImageView: UIImageView!
    var stretchableView: SdStretchableHeaderView!
    var headerHeight: CGFloat = 0
    
    var webView = UIWebView.init()
    var navView: UIView!
    
    var str: String?
    var strTitle: String?
    var strStoryId: String?
    var strStoryImg: String?
    var page: String?
    var navTitleLabel: UILabel!
    var htmlStr: String?
    var allPages: Int?
    var resultHtmlStr: String?
    
    var loadHtmlStr = String()
    
    let textViewFont = UIFont.systemFont(ofSize: 18)
    
     var textview  = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        page = "1"
        getData()
        
        bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH * 0.5))
//        bgImageView.kf.setImage(with: URL.init(string: strStoryImg!), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
//        })
        bgImageView.image = UIImage(named:"01")
        bgImageView.isUserInteractionEnabled = true
        view.addSubview(bgImageView)
        
        let headerView = UIView(frame: bgImageView.bounds)
        //headerView.height -= 80 //对背景图片进行一部分的遮盖（可选，，可以不遮盖。。。）
        headerHeight = headerView.height
        view.addSubview(headerView)
        
        makeNavView()
        stretchableView = SdStretchableHeaderView(stretchableView: bgImageView)
        creatWebView()
    }
  

    func creatWebView(){
        webView = UIWebView()
        webView.backgroundColor = UIColor.lightGray
        webView.delegate = self
        webView.scrollView.delegate = self;
        view.addSubview(webView)
        
        webView.snp.makeConstraints{ (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT-60)
            make.top.equalTo(bgImageView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
   
    func getData(){
        
        let httpHeader = "https://www.sdbsearch.com/955-2"    // "https://route.showapi.com/955-2"
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

            self.resultHtmlStr = c!
         
            self.jointStr()
            
        }
    }
    
    func jointStr(){
        loadHtmlStr = loadHtmlStr+resultHtmlStr!
        self.webView.loadHTMLString(loadHtmlStr, baseURL: nil)
       

//        let webHeightStr = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
//        let webHeight = CGFloat((webHeightStr! as NSString).floatValue)
//
//        self.webView.scrollView.contentOffset = (frame: CGPoint(x:0,y:webHeight)) as! CGPoint
//
//
//       
//       self.webView.scrollView.contentSize =
//       self.webView.frame = CGRectMake(0, 350, SCREEN_WIDTH, webHeight)
//        webView.snp.remakeConstraints{ (make) in
//            make.width.equalTo(SCREEN_WIDTH)
//            make.top.equalTo(bgImageView.snp.bottom)
//            make.bottom.equalTo(view.snp.bottom)
//        }
    }
    
    // 导航栏
    func makeNavView() {
        navView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        view.addSubview(navView)
        
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
        navTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
        navTitleLabel.shadowColor =  UIColor.black //灰色阴影
        navTitleLabel.shadowOffset = CGSize(width:0, height:0)  //阴影的偏移量
        navTitleLabel.textColor = UIColor.RGB_COLOR(0, g: 121, b: 107, alpha: 1)
        navView.addSubview(navTitleLabel)
        
        navTitleLabel.snp.makeConstraints{ (make) in
            make.centerY.equalTo(navView).offset(8)
            make.centerX.equalTo(navView)
            
        }
        
    }

    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height - scrollView.contentOffset.y == SCREEN_HEIGHT - 64 {
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
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        // 导航栏设置
        let yOffset = scrollView.contentOffset.y
       
        if yOffset < (headerHeight - navView.height)  {
            let alpha = yOffset / (headerHeight - navView.height)
            navView.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 108, alpha: alpha)
          
            navTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
            navTitleLabel.shadowColor = UIColor.black  //灰色阴影
            navTitleLabel.shadowOffset = CGSize(width:0, height:0)  //阴影的偏移量
            //navTitleLabel.textColor = UIColor.RGB_COLOR(47, g: 57, b: 225, alpha: 1)
            navTitleLabel.textColor = UIColor.white
           
            webView.snp.remakeConstraints{ (make) in
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(SCREEN_HEIGHT-60)
                make.top.equalTo(bgImageView.snp.bottom)
                make.bottom.equalTo(view.snp.bottom)
            }
            
            
        } else {
            navView.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 107, alpha: 1)
            
            navTitleLabel.shadowColor = UIColor.black  //灰色阴影
            navTitleLabel.shadowOffset = CGSize(width:1.5, height:1.5)  //阴影的偏移量
            navTitleLabel.textColor = UIColor.white
            navTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
            
            webView.snp.remakeConstraints{ (make) in
                make.width.equalTo(SCREEN_WIDTH)
                make.height.equalTo(SCREEN_HEIGHT-60)
                make.top.equalTo(navView.snp.bottom)
                make.bottom.equalTo(view.snp.bottom)
            }
          
        }
        
        stretchableView.scrollViewDidScroll(scrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
