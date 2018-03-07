//
//  SdStretchableHeaderView.swift
//  GhostStory
//
//  Created by sundebiao on 2018/1/3.
//  Copyright © 2018年 sundebiao. All rights reserved.
//

import UIKit

class SdStretchableHeaderView: NSObject {
    private var stretchView = UIView()
    private var imageRatio: CGFloat
    private var originFrame = CGRect()
    
    public init(stretchableView: UIView) {
        
        stretchView = stretchableView
        originFrame = stretchableView.frame
        imageRatio = stretchableView.bounds.height / stretchableView.bounds.width
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        if yOffset > 0 { // 往上移动
            var frame = originFrame
            frame.origin.y = originFrame.origin.y - yOffset
            stretchView.frame = frame
        } else { // 往下移动
            var frame = originFrame
            frame.size.height = originFrame.size.height - yOffset
            frame.size.width = frame.size.height / imageRatio
            frame.origin.x = originFrame.origin.x - (frame.size.width - originFrame.size.width) * 0.5
            stretchView.frame = frame
        }
    }
}

