//
//  SdCollectionViewController.swift
//  GhostStory
//
//  Created by FDart on 2018/1/19.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit
import SVProgressHUD

class SdCollectionViewController: SdBaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    var navView: UIView!
    var navTitleLabel: UILabel!
    var collectionTableView :UITableView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        makeNavView()
        //创建视图
        creatTableView()
        getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshClick), name: NSNotification.Name(rawValue:"refresh"), object: nil)
        
    }

    func getData(){
        var dataMdels = [SdDataModel]()
        
        for newsList in  SQLiteManager.sharInstance.HQBSelectFromTable(tableName: "storys", arFieldsKey:["desc","storyId","img","link","title"]) {
            let yp_newsList = SdDataModel(dict: newsList as! [String: AnyObject])
            dataMdels.append(yp_newsList)
        }
        
        self.dataList.addObjects(from: dataMdels)
        self.collectionTableView!.reloadData()
        
        if dataList.count == 0 {
            SVProgressHUD.showInfo(withStatus: "您没有收藏故事");
            
            DispatchQueue(label: "延迟一秒").asyncAfter(deadline: .now() + 1.5)
            {
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    // 刷新
    @objc fileprivate func refreshClick(){
       self.dataList.removeAllObjects()
       getData()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refresh"), object: nil)
    }
    // 导航栏
    func makeNavView() {
        
        navView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64))
        navView.backgroundColor = UIColor.RGB_COLOR(0, g: 121, b: 108, alpha: 1)
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
        navTitleLabel.text = "我的收藏"
        navTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: UIFont.Weight.RawValue(B600)))
        navTitleLabel.shadowColor =  UIColor.black //灰色阴影
        navTitleLabel.shadowOffset = CGSize(width:0, height:0)  //阴影的偏移量
        navTitleLabel.textColor = UIColor.white
        navView.addSubview(navTitleLabel)
        
        navTitleLabel.snp.makeConstraints{ (make) in
            make.centerY.equalTo(navView).offset(8)
            make.centerX.equalTo(navView)
            
        }
    }
    
    func creatTableView() {
        
        self.collectionTableView = UITableView()
        self.collectionTableView!.delegate = self
        self.collectionTableView!.dataSource = self
        self.view.backgroundColor = .white
        //self.collectionTableView!.separatorStyle = UITableViewCellSeparatorStyle.none
        //设置分割线颜色
        self.collectionTableView!.separatorColor = UIColor.lightGray
        //设置分割线内边距
        self.collectionTableView!.separatorInset = UIEdgeInsetsMake(0, 120, 0, 10)
        self.collectionTableView!.rowHeight = UITableViewAutomaticDimension
        self.collectionTableView!.estimatedRowHeight = 300
        
        self.view.addSubview(self.collectionTableView!)
        
        self.collectionTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "mainTableCell")
        
        self.collectionTableView!.snp.makeConstraints{ (make) in
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
        cell.setCellWithDataModelArr(dataModel: dataList[indexPath.row] as! SdDataModel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let particularsVc = SdParticularsViewController()
        let model : SdDataModel = dataList[indexPath.item] as! SdDataModel
        particularsVc.strStoryId = model.storyId
        particularsVc.strTitle = model.title
        self.navigationController?.pushViewController(particularsVc, animated: true)
    }
    
    //MARK: - 懒加载
    lazy var dataList:NSMutableArray = { return NSMutableArray() }()
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    

}
