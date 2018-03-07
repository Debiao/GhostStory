//
//  SQLiteManager.swift
//  GhostStory
//
//  Created by FDart on 2018/1/20.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit
import FMDB
import SwiftyJSON

class SQLiteManager: NSObject {
    
    static let sharInstance:SQLiteManager = SQLiteManager()
    
    func database()->FMDatabase{
        //获取沙盒路径
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        path = path + "/swiftLearn.sqlite"
        //传入路径，初始化数据库，若该路径没有对应的文件，则会创建此文件
        print("数据库user.sqlite 的路径===" + path)
        return FMDatabase.init(path:path)
    }
    
    
    func HQBCreateTable(tableName:String , arFields:NSArray, arFieldsType:NSArray){
        let db = database()
        if db.open() {
            var  sql = "CREATE TABLE IF NOT EXISTS " + tableName + "(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
            let arFieldsKey:[String] = arFields as! [String]
            let arFieldsType:[String] = arFieldsType as! [String]
            for i in 0..<arFieldsType.count {
                if i != arFieldsType.count - 1 {
                    sql = sql + arFieldsKey[i] + " " + arFieldsType[i] + ", "
                }else{
                    sql = sql + arFieldsKey[i] + " " + arFieldsType[i] + ")"
                }
            }
            do{
                try db.executeUpdate(sql, values: nil)
                print("数据库操作====" + tableName + "表创建成功！")
            }catch{
                print(db.lastErrorMessage())
            }
            
        }
        db.close()
        
    }
    
    
    func HQBInsertDataToTable(tableName:String,dicFields:NSDictionary){
        let db = database()
        if db.open() {

            let arFieldsKeys:[String] = dicFields.allKeys as! [String]
            let arFieldsValues:[Any] = dicFields.allValues
            var sqlUpdatefirst = "INSERT INTO '" + tableName + "' ("
            var sqlUpdateLast = " VALUES("
            for i in 0..<arFieldsKeys.count {
                if i != arFieldsKeys.count-1 {
                    sqlUpdatefirst = sqlUpdatefirst + arFieldsKeys[i] + ","
                    sqlUpdateLast = sqlUpdateLast + "?,"
                }else{
                    sqlUpdatefirst = sqlUpdatefirst + arFieldsKeys[i] + ")"
                    sqlUpdateLast = sqlUpdateLast + "?)"
                }
            }
            do{
                try db.executeUpdate(sqlUpdatefirst + sqlUpdateLast, values: arFieldsValues)
                print("数据库操作==== 添加数据成功！")

            }catch{
                print(db.lastErrorMessage())
            }

        }
    }
    
    
    
    
  
    //MARK: - 修改数据
    /// 修改数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - dicFields: key为表字段，value为要修改的值
    ///   - ConditionsKey: 过滤筛选的字段
    ///   - ConditionsValue: 过滤筛选字段对应的值
    /// - Returns: 操作结果 true为成功，false为失败
    func HQBModifyToData(tableName:String , dicFields:NSDictionary ,ConditionsKey:String ,ConditionsValue :Int)->(Bool){
        var result:Bool = false
        let arFieldsKey : [String] = dicFields.allKeys as! [String]
        var arFieldsValues:[Any] = dicFields.allValues
        arFieldsValues.append(ConditionsValue)
        var sqlUpdate  = "UPDATE " + tableName +  " SET "
        for i in 0..<dicFields.count {
            if i != arFieldsKey.count - 1 {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?,"
            }else {
                sqlUpdate = sqlUpdate + arFieldsKey[i] + " = ?"
            }
            
        }
        sqlUpdate = sqlUpdate + " WHERE " + ConditionsKey + " = ?"
        let db = database()
        if db.open() {
            do{
                try db.executeUpdate(sqlUpdate, values: arFieldsValues)
                print("数据库操作==== 修改数据成功！")
                result = true
            }catch{
                print(db.lastErrorMessage())
            }
        }
        return result
    }

    
    
    //MARK: - 查询数据
    /// 查询数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - arFieldsKey: 要查询获取的表字段
    /// - Returns: 返回相应数据
//    func HQBSelectFromTable(tableName:String,arFieldsKey:NSArray)->([NSMutableDictionary]){
//        let db = database()
//        let dicFieldsValue :NSMutableDictionary = [:]
//
//        var dict: NSDictionary = NSDictionary()
//
//
//        let array: NSMutableArray = NSMutableArray()
//
//
//        let sql = "SELECT * FROM " + tableName
//        if db.open() {
//            do{
//                let rs = try db.executeQuery(sql, values: nil)
//                while rs.next() {
//
//                  // let studentId = rs.string(forColumn: ("id"))
//
//                    for  i in 0..<arFieldsKey.count {
//                        dicFieldsValue.setObject(rs.string(forColumn: arFieldsKey[i] as! String)!, forKey: arFieldsKey[i] as! NSCopying)
//                        dict = dicFieldsValue
//                    }
//
//                    print("--------",dicFieldsValue)
//
//                    array.add(dict)
//                    print("+++++++",array)
//                }
//            }catch{
//                print(db.lastErrorMessage())
//            }
//
//        }
//
//        return array as! [NSMutableDictionary]
//    }
    func HQBSelectFromTable(tableName:String,arFieldsKey:NSArray)->([NSMutableDictionary]){
        let db = database()
        var arFieldsValue = [NSMutableDictionary]()
        let sql = "SELECT * FROM " + tableName
        if db.open() {
            do{
                let rs = try db.executeQuery(sql, values: nil)
                while rs.next() {
                    let dic :NSMutableDictionary = [:]
                    for i in 0..<arFieldsKey.count {
                        dic.setObject(rs.string(forColumn: arFieldsKey[i] as! String)!, forKey: arFieldsKey[i] as! NSCopying)
                    }
                   arFieldsValue.append(dic)
                }
            }catch{
                print(db.lastErrorMessage())
            }
            
        }
        return arFieldsValue
    }
 
    
    
    //MARK: - 删除数据
    /// 删除数据
    ///
    /// - Parameters:
    ///   - tableName: 表名称
    ///   - FieldKey: 过滤的表字段
    ///   - FieldValue: 过滤表字段对应的值
    func HQBDeleteFromTable(tableName:String,FieldKey:String,FieldValue:Any) {
        let db = database()
        
        if db.open() {
            let  sql = "DELETE FROM '" + tableName + "' WHERE " + FieldKey + " = ?"
            
            do{
                try db.executeUpdate(sql, values: [FieldValue])
                print("删除成功")
            }catch{
                print(db.lastErrorMessage())
            }
        }
        
    }

    
 
    
}


