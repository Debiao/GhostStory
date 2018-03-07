//
//  SdAboutViewController.swift
//  GhostStory
//
//  Created by FDart on 2018/1/19.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit


class SdAboutViewController: SdBaseViewController,UITableViewDelegate,UITableViewDataSource{
   

    var navView: UIView!
    //var BgView: UIView!
    var navTitleLabel: UILabel!
    var aboutTable:UITableView?
    
    var adHeaders:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    
        adHeaders = [
            "夜半故事",
            "作者",
            "支持"
        ]
        
       creatTableView()
       makeNavView()
    }
    
    
    func creatTableView() {
        
        self.aboutTable = UITableView()
        self.aboutTable!.delegate = self
        self.aboutTable!.dataSource = self
        self.aboutTable!.separatorStyle = .none
        self.view.backgroundColor = .white
        
        //self.aboutTable!.separatorStyle = UITableViewCellSeparatorStyle.singleLine //设置分割线颜色
        //self.aboutTable!.separatorColor = UIColor.lightGray //设置分割线内边距
        //self.aboutTable!.separatorInset = UIEdgeInsetsMake(0, 120, 0, 10)
        self.aboutTable!.rowHeight = UITableViewAutomaticDimension
        self.aboutTable!.estimatedRowHeight = 300
        self.view.addSubview(self.aboutTable!)
        self.aboutTable!.register(UITableViewCell.self, forCellReuseIdentifier: "aboutTableCell")
        self.aboutTable!.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view).offset(64)
            make.left.bottom.right.equalTo(self.view)
        }
    }
    
   
    //返回分区头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
        return self.adHeaders?[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:do {return 2}
        case 1:do {return 2}
        default:do {return 2}
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
    
        
        let headerViewBotton = UIView(frame: CGRect(x: 10, y: 0, width: SCREEN_WIDTH-20, height: 0.33))
        headerViewBotton.backgroundColor = UIColor.lightGray
        headerView.addSubview(headerViewBotton)
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.row {
        case 0:
            do {return 20}
        default:
            do {return 65}
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutTableCell", for: indexPath)
       // cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
       
        switch indexPath.section {
        
        case 0:do {
            
            if (indexPath.row == 0) {
                cell.textLabel?.text = "当前版本 (1.1.2)"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = UIColor.black
        
            }else if (indexPath.row == 1){
                cell.textLabel?.text = "为应用评分"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = UIColor.black
                
                let cellLabel = UILabel()//frame: CGRect(x: 15, y:15, width: SCREEN_WIDTH, height: 74)
                cellLabel.text = "如果觉得应用不错,那就评分鼓励一下吧"
                cellLabel.textColor = UIColor.RGB_COLOR(104, g: 104, b: 104, alpha: 1)
                cellLabel.font = UIFont.systemFont(ofSize: 12)
                cell.contentView.addSubview(cellLabel)
                
                cellLabel.snp.makeConstraints{ (make) in
                    make.left.equalTo(cell.textLabel!)
                    make.bottom.equalTo(cell.textLabel!.snp.bottom).offset(25)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(74)
                }
                
                
                
            }
                 return cell
            
            }
        case 1:do {
            if (indexPath.row == 0) {
                cell.textLabel?.text = "sunshuo"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = UIColor.black

                
            }else if (indexPath.row == 1){
                cell.textLabel?.text = "关注我的Github"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = UIColor.black
            
                let cellLabel = UILabel()//frame: CGRect(x: 15, y:15, width: SCREEN_WIDTH, height: 74)
                cellLabel.text = "来GitHub看看我吧"
                cellLabel.textColor = UIColor.RGB_COLOR(104, g: 104, b: 104, alpha: 1)
                cellLabel.font = UIFont.systemFont(ofSize: 12)
                cell.contentView.addSubview(cellLabel)
                
                cellLabel.snp.makeConstraints{ (make) in
                    make.left.equalTo(cell.textLabel!)
                    make.bottom.equalTo(cell.textLabel!.snp.bottom).offset(25)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(74)
                }
                
            }
            
            return cell
            }
        default:do {
            
            if (indexPath.row == 0) {
                cell.textLabel?.text = "欢迎反馈,帮我改进提升应用"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = UIColor.black
                
            }else if (indexPath.row == 1){
                cell.textLabel?.text = "捐助"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = UIColor.black
               
                let cellLabel = UILabel()//frame: CGRect(x: 5, y:15, width: SCREEN_WIDTH, height: 74)
                cellLabel.text = "如果你赞赏这款应用,请随意打赏"
                cellLabel.textColor = UIColor.RGB_COLOR(104, g: 104, b: 104, alpha: 1)
                cellLabel.font = UIFont.systemFont(ofSize: 12)
                cell.contentView.addSubview(cellLabel)
                
                cellLabel.snp.makeConstraints{ (make) in
                    make.left.equalTo(cell.textLabel!)
                    make.bottom.equalTo(cell.textLabel!.snp.bottom).offset(25)
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(74)
                }
            }
            return cell
            
            }
            
        }
        
        
        
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
        navTitleLabel.text = "关 于"
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

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch indexPath.section {
        case 0:
            do{
                if indexPath.row == 0{
                    print("版本号")
                }else{
                     print("应用评分")
                }
            }
        case 1:
            do{
                if indexPath.row == 0{
                     print("sunshuo")
                }else{
                     print("关注我的")
                }
            }
        default:
            do{
                if indexPath.row == 0{
                     print("反馈")
                }else{
                    print("捐助")
                }
            }
           
        }
        
    }
    
    
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
