//
//  EZDrawerManager.swift
//  EasyDrawer
//
//  Created by 王小帅 on 2017/2/16.
//  Copyright © 2017年 王小帅. All rights reserved.
//
// 单例方法 用来设置视图之间的关系
//

import UIKit

public class EZDrawer: NSObject {

    // 根控制器
    var root: EZRootViewController?
    
    // 滑动菜单停靠比例 默认 0.7 范围在 0.1～0.9
    var scale:CGFloat = 0.7 {
        didSet{
            if scale < 0.1 {
                scale = 0.1
            }else if scale > 0.9 {
                scale = 0.9
            }
            // 实时修改停靠比例
            root?.scale = scale
        }
    }
    
    // MARK: - 初始化
    private override init() {
    }
    
    // 单例
    public static let shared = EZDrawer()
    
    /// 返回根控制器
    ///
    /// - Parameters:
    ///   - main: 主页控制器
    ///   - left: 左侧抽屉控制器
    ///   - right: 右侧抽屉控制器
    /// - Returns: 跟控制器
   public func setupChilds(main: UIViewController?, left: UIViewController?, right: UIViewController?) -> UIViewController? {
        
        // 如果没有设置主控制器 返回nil
        guard let main = main
            else {
                return nil
            }
        
        // 实例跟控制器
        root = EZRootViewController(mainVC: main, leftVC: left, rightVC: right)
        root?.scale = self.scale
        
        return root
    }
    
    
    // MARK: - 打开和关闭抽屉
    
    // 打开左侧抽屉
   public func openLeftDrawer() {
        self.root?.openLeftMenu()
    }
    
    // 打开右侧抽屉
    public func openRightDrawer() {
        self.root?.openRightMenu()
    }
    
    // 关闭抽屉 不区分左右
   public func closeDrawer() {
        self.root?.closeMenu()
    }
    
    
}
