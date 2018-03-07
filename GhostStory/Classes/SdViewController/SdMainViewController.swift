//
//  SdMainViewController.swift
//  GhostStory
//
//  Created by sundebiao on 2017/12/29.
//  Copyright © 2017年 sundebiao. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD


private var PageSize = 1   //定义初次页数

class SdMainViewController: SdBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    override func loadView() {
        super.loadView()
    }
    
    var bgImageView: UIImageView!
    var navView: UIView!
    var navTitleLabel: UILabel!
    var stretchableView: SdStretchableHeaderView!
    var mainTable:UITableView?
    var headerHeight: CGFloat = 0
    var adHeaders:[String]?
    var storyType:[String]?
    var randomNumberSet = Set<Int>()
    
    var recommendArray:NSMutableArray?  //推荐
    var dpArray:NSMutableArray?    //短篇
    var cpArray:NSMutableArray?    //长篇
    var xyArray:NSMutableArray?    //校园
    var yyArray:NSMutableArray?    //医院
    var jlArray:NSMutableArray?    //家里
    var mjArray:NSMutableArray?    //民间
    var lyArray:NSMutableArray?    //灵异
    var ycArray:NSMutableArray?    //原创
    var neihanguigushiArray:NSMutableArray?  //内涵
    
    
    var rePage: String?
    var reType: String?
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show(withStatus: "正在加载...")
        
        recommendArray = NSMutableArray.init(); //推荐
        dpArray  = NSMutableArray.init();  //短篇
        cpArray  = NSMutableArray.init();  //长篇
        xyArray  = NSMutableArray.init();  //校园
        yyArray  = NSMutableArray.init();  //医院
        jlArray  = NSMutableArray.init();  //家里
        mjArray  = NSMutableArray.init();  //民间
        lyArray  = NSMutableArray.init();  //灵异
        ycArray  = NSMutableArray.init();  //原创
        neihanguigushiArray = NSMutableArray.init(); //内涵
        
        adHeaders = [
            "精品推荐",
            "短篇故事",
            "长篇故事",
            "校园故事",
            "医院故事",
            "家里故事",
            "民间故事",
            "灵异故事",
            "原创故事",
            "内涵故事"
        ]
        
        storyType = [
            "dp",    //短篇
            "cp",    //长篇
            "xy",    //校园
            "yy",    //医院
            "jl",    //家里
            "mj",    //民间
            "ly",    //灵异
            "yc",    //原创
            "neihanguigushi"   //内涵
            
        ]
        
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .textColor = UIColor.black
        //设置分区头尾的文字样式：15号斜体
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self])
            .font = UIFont.italicSystemFont(ofSize: 15)
        
        //创建视图
        creatTableView()
        //页眉效果
        creatTableHeaderView()
        //数据源
        getRecommendData()
        
    }
    
    func creatTableView() {
        
        self.mainTable = UITableView()
        self.mainTable!.delegate = self
        self.mainTable!.dataSource = self
        //self.mainTable!.separatorStyle = .none
        self.view.backgroundColor = .white
        
        self.mainTable!.separatorStyle = UITableViewCellSeparatorStyle.singleLine //设置分割线颜色
        self.mainTable!.separatorColor = UIColor.lightGray //设置分割线内边距
        self.mainTable!.separatorInset = UIEdgeInsetsMake(0, 120, 0, 10)
        self.mainTable!.rowHeight = UITableViewAutomaticDimension
        self.mainTable!.estimatedRowHeight = 300
        self.view.addSubview(self.mainTable!)
        self.mainTable!.register(UITableViewCell.self, forCellReuseIdentifier: "mainTableCell")
        self.mainTable!.snp.makeConstraints{ (make) in
            make.top.left.bottom.right.equalTo(self.view)
        }
        
    }
    
    //创建页面
    func creatTableHeaderView(){
        
        bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH * 0.4))
        bgImageView.image = UIImage(named: "12")
        view.addSubview(bgImageView)
        
        let headerView = UIView(frame: bgImageView.bounds)
        //headerView.height -= 80 //对背景图片进行一部分的遮盖（可选，，可以不遮盖。。。）
        headerHeight = headerView.height
        mainTable?.tableHeaderView = headerView
        
        makeNavView()
        stretchableView = SdStretchableHeaderView(stretchableView: bgImageView)
        
    }
    
    
    func randomResults(){
        var end : Int = 0
        for _ in 0...end{
            let randomNumber = Int(arc4random() % 10 )
            randomNumberSet.insert(randomNumber)
            if randomNumberSet.count <= 2 {
                end += 1
                self.randomResults()
            }
        }
    }
    
    
    func getRecommendData(){
        
        let randomNumber = Int(arc4random_uniform(9))+0
        let randomPage = Int(arc4random_uniform(100))+1
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmss"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        let httpHeader = "https://www.sdbsearch.com/955-1?page="    //   "https://route.showapi.com/955-1?page="
        let pageStr = "\(randomPage)"
        let showapIdStr = "&showapi_appid=33642&showapi_timestamp="
        let timeStr = strNowTime
        let typeStr = "&type="
        let typeValueStr = storyType![randomNumber]
        let secretStr = "&showapi_sign=b8f27f88131240c8b8c39b2b8c6e6691"
        let URL = httpHeader+pageStr+showapIdStr+timeStr+typeStr+typeValueStr+secretStr
        
        print(URL)
        SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
            self.dataList.removeAllObjects()
            self.dataList.addObjects(from: dataModel)
            
            if self.dataList.count == 0{
                self.getRecommendData()
            }else{
                
                self.randomResults()
                
                if self.randomNumberSet.count > 2{
                    for index in self.randomNumberSet{
                        self.recommendArray?.add(self.dataList[index])
                    }
                    self.rePage = pageStr
                    self.reType = typeValueStr
                    
                    self.getData()
                }else{
                    self.randomResults()
                    self.getRecommendData()
                }
                self.mainTable?.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    //获取数据
    func getData() {
        
        for index in 0...8 {
            let date = NSDate()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyyMMddHHmmss"
            let strNowTime = timeFormatter.string(from: date as Date) as String
            let httpHeader = "https://route.showapi.com/955-1?page="
            let pageStr = "1"
            let showapIdStr = "&showapi_appid=33642&showapi_timestamp="
            let timeStr = strNowTime
            let typeStr = "&type="
            let typeValueStr = storyType![index]
            let secretStr = "&showapi_sign=b8f27f88131240c8b8c39b2b8c6e6691"
            let URL = httpHeader+pageStr+showapIdStr+timeStr+typeStr+typeValueStr+secretStr
            print(URL)
            switch index {
            case 0:
                do {
                    
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        for index in 0...2 {
                            self.dpArray?.add(self.dataList[index])
                        }
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                        
                    }
                }
            case 1:
                do {
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        for index in  0...2 {
                            self.cpArray?.add(self.dataList[index])
                        }
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            case 2:
                do {
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        
                        for index in  0...2 {
                            self.xyArray?.add(self.dataList[index])
                        }
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            case 3:
                do {
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        
                        for index in  0...2 {
                            self.yyArray?.add(self.dataList[index])
                        }
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            case 4:
                do {
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        for index in  0...2 {
                            self.jlArray?.add(self.dataList[index])
                        }
                        
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            case 5:
                do {
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        for index in  0...2 {
                            self.mjArray?.add(self.dataList[index])
                        }
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            case 6:
                do {
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        for index in 0...2{
                            self.lyArray?.add(self.dataList[index])
                        }
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            case 7:
                do {
                    
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        for index in  0...2{
                            self.ycArray?.add(self.dataList[index])
                        }
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
                
            default:
                do {
                    SdHttpRequest.shareHttpRequest.getStoryData(page:PageSize, url: URL) { (dataModel) in
                        self.dataList.removeAllObjects()
                        self.dataList.addObjects(from: dataModel)
                        
                        for index in  0...2 {
                            self.neihanguigushiArray?.add(self.dataList[index])
                        }
                        
                        self.mainTable?.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            }
            
            
            
        }
    }
    
    
    //返回分区头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let titleLabel = UILabel()
        titleLabel.text = self.adHeaders?[section]
        titleLabel.textColor = UIColor.RGB_COLOR(0, g: 121, b: 107, alpha: 1)
        titleLabel.sizeToFit()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
        titleLabel.center = CGPoint(x:44, y: 20)
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints{ (make) in
            make.centerY.equalTo(headerView)
            make.left.equalTo(headerView.snp.left).offset(10)
            make.height.equalTo(20)
        }
        
        
        let btnLab = UILabel()
        btnLab.text = "查看全部"
        btnLab.textColor = UIColor.RGB_COLOR(252, g: 149, b: 68, alpha: 1)
        btnLab.sizeToFit()
        btnLab.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(btnLab)
        btnLab.isUserInteractionEnabled = true
        
        btnLab.snp.makeConstraints{ (make) in
            make.bottom.equalTo(headerView.snp.bottom).offset(-7)
            make.right.equalTo(headerView.snp.right).offset(-10)
            make.height.equalTo(20)
        }
        
        switch self.adHeaders?[section] {
        case "精品推荐"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReBtnLabClick)))
            }
        case "短篇故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dpBtnLabClick)))
            }
        case "长篇故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cpBtnLabClick)))
            }
        case "校园故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(xyBtnLabClick)))
            }
        case "医院故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yyBtnLabClick)))
            }
        case "家里故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(jlBtnLabClick)))
            }
        case "民间故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mjBtnLabClick)))
            }
        case "灵异故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lyBtnLabClick)))
            }
        case "原创故事"?:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ycBtnLabClick)))
            }
        //内涵故事
        default:
            do {
                btnLab.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(neihanguigushiBtnLabClick)))
            }
        }
        
        let headerViewBotton = UIView(frame: CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: 0.33))
        headerViewBotton.backgroundColor = UIColor.lightGray
        headerView.addSubview(headerViewBotton)
        
        return headerView
    }
    
    
    @objc func ReBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.titleStr = "精品推荐"
        SdTypeVc.page = rePage
        SdTypeVc.type = reType
        navigationController?.pushViewController(SdTypeVc, animated: true)
        
    }
    @objc func dpBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "dp"
        SdTypeVc.titleStr = "短片故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("dp")
    }
    @objc func cpBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "cp"
        SdTypeVc.titleStr = "长篇故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("cp")
    }
    @objc func xyBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "xy"
        SdTypeVc.titleStr = "校园故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("xy")
    }
    @objc func yyBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "yy"
        SdTypeVc.titleStr = "医院故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("yy")
    }
    @objc func jlBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "jl"
        SdTypeVc.titleStr = "家里故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("jl")
    }
    @objc func mjBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "mj"
        SdTypeVc.titleStr = "民间故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("mj")
    }
    @objc func lyBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "ly"
        SdTypeVc.titleStr = "灵异故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("ly")
    }
    @objc func ycBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "yc"
        SdTypeVc.titleStr = "原创故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("yc")
    }
    @objc func neihanguigushiBtnLabClick(){
        let SdTypeVc = SdTypesViewController()
        SdTypeVc.page = "1"
        SdTypeVc.type = "neihanguigushi"
        SdTypeVc.titleStr = "内涵故事"
        navigationController?.pushViewController(SdTypeVc, animated: true)
        print("nei")
    }
    
    
    //返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的头部
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return self.adHeaders?[section]
    }
    
    
    // 导航栏
    func makeNavView() {
        navView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        view.addSubview(navView)
        
        navTitleLabel = UILabel(frame: CGRect(x: 5, y: 7, width: SCREEN_WIDTH, height: 64))
        navTitleLabel.text = "夜半故事"
        navTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
        //titleLabel.shadowColor =  UIColor.gray //灰色阴影
        //titleLabel.shadowOffset = CGSize(width:1.5, height:1.5)  //阴影的偏移量
        navTitleLabel.textColor = UIColor.black
        navView.addSubview(navTitleLabel)
        
        let searchBtn:UIButton = UIButton(type:.contactAdd)
        //设置按钮位置和大小
        //searchBtn.frame = CGRect(x:120, y:28, width:260, height:23)
        searchBtn.backgroundColor = UIColor.RGB_COLOR(255, g: 255, b: 255, alpha: 0.8)
        searchBtn.layer.cornerRadius = 4;
        let iconSearchImage = UIImage(named:"搜索")?.withRenderingMode(.alwaysOriginal)
        searchBtn.setImage(iconSearchImage, for:.normal)
        searchBtn.adjustsImageWhenHighlighted=false //使触摸模式下按钮也不会变暗（半透明）
        searchBtn.adjustsImageWhenDisabled=false //使禁用模式下按钮也不会变暗（半透明
        navView.addSubview(searchBtn)
        
        searchBtn.snp.makeConstraints{ (make) in
            make.centerX.equalTo(navView).offset(30)
            make.centerY.equalTo(navTitleLabel)
            make.height.equalTo(23)
            make.right.equalTo(navView.snp.right).offset(-40)
        }
        
        let settingBtn:UIButton = UIButton(type:.contactAdd)
        //设置按钮位置和大小
        //settingBtn.frame = CGRect(x:350, y:7, width:100, height:64)
        let iconImage = UIImage(named:"设置")?.withRenderingMode(.alwaysOriginal)
        settingBtn.setImage(iconImage, for:.normal)
        settingBtn.adjustsImageWhenHighlighted=false //使触摸模式下按钮也不会变暗（半透明）
        settingBtn.adjustsImageWhenDisabled=false //使禁用模式下按钮也不会变暗（半透明
        settingBtn.addTarget(self, action:#selector(SETTINGCLICK), for:.touchUpInside)
        
        navView.addSubview(settingBtn)
        
        settingBtn.snp.makeConstraints{ (make) in
            make.right.equalTo(navView.snp.right).offset(-10)
            make.centerY.equalTo(navTitleLabel)
        }
        
    }
    
    
    @objc func SETTINGCLICK(){
        let settingVc = SdSettingViewController()
        self.navigationController?.pushViewController(settingVc, animated: false)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 导航栏设置
        let yOffset = scrollView.contentOffset.y
        if yOffset < (headerHeight - navView.height) {
            let alpha = yOffset / (headerHeight - navView.height)
            navView.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 108, alpha: alpha)
            
            navTitleLabel.shadowColor = UIColor.gray  //灰色阴影
            navTitleLabel.shadowOffset = CGSize(width:0, height:0)  //阴影的偏移量
            navTitleLabel.textColor = UIColor.black
            
        } else {
            navView.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 107, alpha: 1)
            
            navTitleLabel.shadowColor = UIColor.gray  //灰色阴影
            navTitleLabel.shadowOffset = CGSize(width:1.5, height:1.5)  //阴影的偏移量
            navTitleLabel.textColor = UIColor.white
        }
        
        stretchableView.scrollViewDidScroll(scrollView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:do{return dpArray!.count}
        case 2:do{return cpArray!.count}
        case 3:do{return xyArray!.count}
        case 4:do{return yyArray!.count}
        case 5:do{return jlArray!.count}
        case 6:do{return mjArray!.count}
        case 7:do{return lyArray!.count}
        case 8:do{return ycArray!.count}
        case 9:do{return neihanguigushiArray!.count}
        default:
            do{return recommendArray!.count}
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "mainCell"
        let cell = SdMainViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let secno = indexPath.section
        
        switch secno {
        case 1:do{ cell.setCellWithDataModelArr(dataModel: dpArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 2:do{cell.setCellWithDataModelArr(dataModel: cpArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 3:do{cell.setCellWithDataModelArr(dataModel: xyArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 4:do{cell.setCellWithDataModelArr(dataModel: yyArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 5:do{cell.setCellWithDataModelArr(dataModel: jlArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 6:do{cell.setCellWithDataModelArr(dataModel: mjArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 7:do{cell.setCellWithDataModelArr(dataModel: lyArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 8:do{cell.setCellWithDataModelArr(dataModel: ycArray?[indexPath.row] as! SdDataModel)
            return cell}
        case 9:do{cell.setCellWithDataModelArr(dataModel: neihanguigushiArray?[indexPath.row] as! SdDataModel)
            return cell}
        default:
            do{cell.setCellWithDataModelArr(dataModel: recommendArray?[indexPath.row] as! SdDataModel)
                return cell}
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let particularsVc = SdParticularsViewController()
        
        let secno = indexPath.section
        
        switch secno {
        case 1:
            do{
                let model : SdDataModel = dpArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strStoryImg = model.img
                particularsVc.strTitle = model.title
                particularsVc.strStoryDesc = model.desc
            }
        case 2:
            do{
                let model : SdDataModel = cpArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        case 3:
            do{
                let model : SdDataModel = xyArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        case 4:
            do{
                let model : SdDataModel = yyArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        case 5:
            do{
                let model : SdDataModel = jlArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        case 6:
            do{
                let model : SdDataModel = mjArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        case 7:
            do{
                let model : SdDataModel = lyArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        case 8:
            do{
                let model : SdDataModel = ycArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        case 9:
            do{
                let model : SdDataModel = neihanguigushiArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        default:
            do{let model : SdDataModel = recommendArray![indexPath.item] as! SdDataModel
                particularsVc.str = model.link
                particularsVc.strStoryId = model.id
                particularsVc.strTitle = model.title
                particularsVc.strStoryImg = model.img
                particularsVc.strStoryDesc = model.desc
            }
        }
        
        self.navigationController?.pushViewController(particularsVc, animated: true)
        
    }
    
    //MARK: - 懒加载
    lazy var dataList:NSMutableArray = { return NSMutableArray() }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


