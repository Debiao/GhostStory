//
//  SdTypesViewController.swift
//  GhostStory
//
//  Created by sundebiao on 2018/1/6.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit
import SVProgressHUD
import PullToRefresh

class SdTypesViewController: SdBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var titleStr: String?
    var type: String?
    var page: String?
    
    var navView: UIView!
    var navTitleLabel: UILabel!
    var typeTableView :UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "正在加载...")
        view.backgroundColor = UIColor.red
        makeNavView()
        //创建视图
        creatTableView()
        getData()
        //刷新
        setupPullToRefresh()
        setdownPullToRefresh()
    }
    
    
    func getData(){
        
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmss"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        let httpHeader = "https://www.sdbsearch.com/955-1?page=" //"https://route.showapi.com/955-1?page="
        let pageStr = page
        let showapIdStr = "&showapi_appid=33642&showapi_timestamp="
        let timeStr = strNowTime
        let typeStr = "&type="
        let typeValueStr = type
        let secretStr = "&showapi_sign=b8f27f88131240c8b8c39b2b8c6e6691"
        let URL = httpHeader+pageStr!+showapIdStr+timeStr+typeStr+typeValueStr!+secretStr
        
        SdHttpRequest.shareHttpRequest.getStoryData(page:1, url: URL) { (dataModel) in
            self.dataList.addObjects(from: dataModel)
            self.typeTableView?.reloadData()
            SVProgressHUD.dismiss()
            
        }
    }
    
    
    // 导航栏
    func makeNavView() {
        navView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        navView.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 107, alpha: 1)
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
        navTitleLabel.text = titleStr
        navTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
        navTitleLabel.shadowColor =  UIColor.gray //灰色阴影
        navTitleLabel.shadowOffset = CGSize(width:1.5, height:1.5)  //阴影的偏移量
        navTitleLabel.textColor = UIColor.white
        navView.addSubview(navTitleLabel)
        
        navTitleLabel.snp.makeConstraints{ (make) in
            make.centerY.equalTo(navView).offset(8)
            make.centerX.equalTo(navView)
            
        }
    }
    
    
    func creatTableView() {
        
        self.typeTableView = UITableView()
        self.typeTableView!.delegate = self
        self.typeTableView!.dataSource = self
        self.view.backgroundColor = .white
        self.typeTableView!.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        //设置分割线颜色
        self.typeTableView!.separatorColor = UIColor.lightGray
        //设置分割线内边距
        self.typeTableView!.separatorInset = UIEdgeInsetsMake(0, 120, 0, 10)
        self.typeTableView!.rowHeight = UITableViewAutomaticDimension
        self.typeTableView!.estimatedRowHeight = 300
        
        self.view.addSubview(self.typeTableView!)
        
        self.typeTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "mainTableCell")
        
        self.typeTableView!.snp.makeConstraints{ (make) in
            make.top.equalTo(navView.snp.bottom)
            make.left.bottom.right.equalTo(self.view)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let identifier = "mainCell"
        let cell = SdMainViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if dataList.count != 0 {
            cell.setCellWithDataModelArr(dataModel: dataList[indexPath.row] as! SdDataModel)
            return cell
        }else{
            getData()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let detailVc = SdDetailsViewController()
        
        
        //        let model : SdDataModel = dataList[indexPath.item] as! SdDataModel
        //        detailVc.str = model.link
        //        detailVc.strStoryId = model.id
        //        detailVc.strTitle = model.title
        //        detailVc.strStoryImg = model.img
        //
        //        self.navigationController?.pushViewController(detailVc, animated: true)
        
        
        let particularsVc = SdParticularsViewController()
        let model : SdDataModel = dataList[indexPath.item] as! SdDataModel
        particularsVc.str = model.link
        particularsVc.strStoryId = model.id
        particularsVc.strTitle = model.title
        particularsVc.strStoryImg = model.img
        self.navigationController?.pushViewController(particularsVc, animated: true)
        
    }
    
    
    //数据刷新
    func setupPullToRefresh() {
        self.typeTableView?.addPullToRefresh(PullToRefresh()) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self?.typeTableView?.endRefreshing(at: .top)
                self?.dataList.removeAllObjects()
                
                if  self?.titleStr == "精品推荐"{
                    self?.page = self?.page
                }else{
                    self?.page = "1"
                }
                
                self?.getData()
                self?.typeTableView?.reloadData()
            }
        }
    }
    
    func setdownPullToRefresh() {
        self.typeTableView?.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                let pageValue = Int((self?.page!)!)!
                self?.page = "\(pageValue+1)"
                
                self?.getData()
                self?.typeTableView?.reloadData()
                self?.typeTableView?.endRefreshing(at: .bottom)
            }
        }
    }
    deinit {
        typeTableView?.removeAllPullToRefresh()
    }
    
    
    //MARK: - 懒加载
    lazy var dataList:NSMutableArray = { return NSMutableArray() }()
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
