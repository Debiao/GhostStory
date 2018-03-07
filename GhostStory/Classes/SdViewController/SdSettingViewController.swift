//
//  SdSettingViewController.swift
//  GhostStory
//
//  Created by FDart on 2018/1/19.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit
import SVProgressHUD

class SdSettingViewController: SdBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    var settingTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingTableView = UITableView()
        self.settingTableView!.delegate = self
        self.settingTableView!.dataSource = self
        self.settingTableView!.separatorStyle = .none
        
        self.settingTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "settingTableCell")
        self.view.addSubview(self.settingTableView!)
        
        self.view.backgroundColor = .white
        
        let headerImg = UIImageView()
        self.view.addSubview(headerImg)
        
        headerImg.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(self.view.frame.size.height/2.5)
        }
        headerImg.image = UIImage(named:"nav_header")
        
        self.settingTableView!.snp.makeConstraints{ (make) in
            make.top.equalTo(headerImg.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(self.view)
            
        }
        
        let BackBtn:UIButton = UIButton(type:.contactAdd)
        let iconSearchImage = UIImage(named:"弹窗－关闭")?.withRenderingMode(.alwaysOriginal)
        BackBtn.addTarget(self, action:#selector(pop), for:.touchUpInside)
        
        BackBtn.setImage(iconSearchImage, for:.normal)
        BackBtn.adjustsImageWhenHighlighted=false //使触摸模式下按钮也不会变暗（半透明）
        BackBtn.adjustsImageWhenDisabled=false //使禁用模式下按钮也不会变暗（半透明
        view.addSubview(BackBtn)
        
        BackBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view.snp.top).offset(24)
            make.right.equalTo(-14)
        }
    }
    
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Tabledelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingTableCell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if (indexPath.row == 0) {
            let imag = UIImage(named:"收藏")
            cell.imageView?.image = imag
        }else if (indexPath.row == 1){
            let imag = UIImage(named:"关于")
            cell.imageView?.image = imag
        }else if (indexPath.row == 2){
            let imag = UIImage(named:"清除缓存")
            cell.imageView?.image = imag
        }
        
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.textLabel?.textColor = UIColor.black
       
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let collectionVc = SdCollectionViewController()
             self.navigationController?.pushViewController(collectionVc, animated: false)
        }else if (indexPath.row == 1){
            let aboutVc = SdAboutViewController()
             self.navigationController?.pushViewController(aboutVc, animated: false)
        }else if (indexPath.row == 2){
            
            SVProgressHUD.showInfo(withStatus: "清除成功");
            DispatchQueue(label: "延迟一秒").asyncAfter(deadline: .now() + 1.5)
            {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    // MARK: - dataSource
    lazy var dataSource : [String] = {return ["我的收藏","关于","清除缓存"]}()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
