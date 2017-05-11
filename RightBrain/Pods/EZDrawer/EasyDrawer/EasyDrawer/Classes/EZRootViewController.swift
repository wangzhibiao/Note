//
//  EZRootViewController.swift
//  EasyDrawer
//
//  Created by 王小帅 on 2017/2/15.
//  Copyright © 2017年 王小帅. All rights reserved.
//

import UIKit


/// 抽屉菜单点根控制器
class EZRootViewController: UIViewController {

    
    // MARK: - 各个自控制器属性
    
    /// 中间主控制器
    private var mainVC:UIViewController?
    /// 左侧控制器
    private var leftVC:UIViewController?
    /// 右侧控制器
    private var rightVC:UIViewController?
    
    /// 互动手势
    private var panGest:UIPanGestureRecognizer?
    /// 主页的遮罩button 用来监听点击返回的手势
    private var maskButton:UIButton?
    
    // 滑动菜单停靠比例
    var scale:CGFloat = 0.0
    
    
    // MARK: - 初始化方法
    init(mainVC: UIViewController?, leftVC: UIViewController?, rightVC:UIViewController?) {
        
        super.init(nibName: nil, bundle: nil)
        
        // 赋值属性
        self.mainVC = mainVC
        
        // 判断是否有赋值属性
        if leftVC == nil && rightVC == nil {
            
            // 没有设置抽屉 那么只显示主页视图控制器
            view.addSubview((mainVC?.view)!)
            addChildViewController(mainVC!)
            return
        }
        
        // 赋值属性
        self.leftVC = leftVC
        self.rightVC = rightVC
        
        // 设置抽屉位置
        if let left = leftVC {
            
            // 初始位置
            var frame = left.view.frame
            frame = CGRect(x: -frame.width, y: 0, width: frame.width, height: frame.height)
            left.view.frame = frame
            
            // 加入视图同时将视图的控制器添加进来
            view.addSubview(left.view)
            addChildViewController(left)
        }
        
        if let right = rightVC {
            
            // 初始位置
            var frame = right.view.frame
            frame = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
            right.view.frame = frame
            
            // 加入视图同时将视图的控制器添加进来
            view.addSubview(right.view)
            addChildViewController(right)
        }
        
        // 加入主视图
        view.addSubview((mainVC?.view)!)
        addChildViewController(mainVC!)
        
        // 设置滑动手势
        let panGest = UIPanGestureRecognizer(target: self, action: #selector(reconizerHandle(recognizer:)))
        panGest.minimumNumberOfTouches = 1
        panGest.maximumNumberOfTouches = 1
        self.mainVC?.view.addGestureRecognizer(panGest)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

 
    
    // MARK: - 视图移动属性
    // 初始位置
    var startX:CGFloat = 0.0
    var startY:CGFloat = 0.0
    // 左边是图中心点
    var leftCenter:CGPoint = CGPoint.zero
    // 右侧视图中心点
    var rightCenter:CGPoint = CGPoint.zero
    // 主页中心点
    var mainCenter:CGPoint = CGPoint.zero
    
    
    // MARK: - 打开/关闭 抽屉
    
    /// 打开左侧菜单
    func openLeftMenu() {
        // 左侧视图的中心点
        leftCenter = self.leftVC?.view.center ?? CGPoint.zero
        // 主页中心点
        mainCenter = self.mainVC?.view.center ?? CGPoint.zero
        
        // 偏移量
        let delatX:CGFloat = SCREEN_WIDTH * self.scale
        
        // 动画设置
        UIView.animate(withDuration: 0.2,
                       animations: {
                        
                        // 分别对主页和菜单页做位移
                        self.mainVC?.view.center = CGPoint(x: (self.mainCenter.x + delatX),
                                                           y: self.mainCenter.y)
                        self.leftVC?.view.center = CGPoint(x: (self.leftCenter.x + delatX),
                                                           y: self.leftCenter.y)
                        
        }) { (bool) in
            // 动画完成 添加遮罩
            self.addMainMask()
        }
    }
    
    // 打开右侧抽屉
    func openRightMenu() {
        // 左侧视图的中心点
        rightCenter = self.rightVC?.view.center ?? CGPoint.zero
        // 主页中心点
        mainCenter = self.mainVC?.view.center ?? CGPoint.zero
        
        // 偏移量
        let delatX:CGFloat = -SCREEN_WIDTH * self.scale
        
        // 动画设置
        UIView.animate(withDuration: 0.2,
                       animations: {
                        
                        // 分别对主页和菜单页做位移
                        self.mainVC?.view.center = CGPoint(x: (self.mainCenter.x + delatX),
                                                           y: self.mainCenter.y)
                        self.rightVC?.view.center = CGPoint(x: (self.rightCenter.x + delatX),
                                                           y: self.rightCenter.y)
                        
        }) { (bool) in
            // 动画完成 添加遮罩
            self.addMainMask()
        }
    }

    
    /// 关闭菜单
    func closeMenu() {

        // 原始中心点
        let orgCenter = CGPoint(x: CGFloat(SCREEN_WIDTH * 0.5),
                                y: CGFloat(SCREEN_HEIGHT * 0.5))
        
        // 动画设置
        UIView.animate(withDuration: 0.2,
                       animations: {
                        
                        // 分别对主页和菜单页做位移
                        self.mainVC?.view.center = CGPoint(x: orgCenter.x,
                                                           y: orgCenter.y)
                        // 复位左右抽屉
                        self.leftVC?.view.center = CGPoint(x: orgCenter.x - SCREEN_WIDTH,
                                                           y: orgCenter.y)
                        self.rightVC?.view.center = CGPoint(x: orgCenter.x + SCREEN_WIDTH,
                                                           y: orgCenter.y)
                        
        }) { (bool) in
            // 动画完成 移除遮罩
            self.removeMainMask()
        }
        
    }
    
    
    // MARK: - 加入/移除/点击 主页遮罩
    func addMainMask() {
        
        let frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        maskButton = UIButton(frame: frame)
        maskButton?.addTarget(self, action: #selector(maskBtnClick(btn:)), for: .touchUpInside)
        self.mainVC?.view.addSubview(maskButton!)
    }
    
    /// 移除主页遮罩
    func removeMainMask() {
        guard let _ = maskButton else {
            return
        }
        
        maskButton?.removeFromSuperview()
        maskButton = nil
    }
    
    /// 遮罩按钮点击
    func maskBtnClick(btn: UIButton) {
        closeMenu()
    }
    
    
    // MARK: - 手势移动监听方法
    func reconizerHandle(recognizer: UIPanGestureRecognizer) {
        // 主视图和左右侧视图 拖动监听
        let targatView = self.mainVC?.view
        let leftView = self.leftVC?.view
        let rightView = self.rightVC?.view
        
        // 获取被拖动的view在当前view中的坐标点
        let transPoint = recognizer.translation(in: recognizer.view)
        
        // 对当前状态进行判断对不同状态做处理比如判断拖动位置并加入动画处理
        if recognizer.state == UIGestureRecognizerState.began {
            // 如果事件刚刚开始 那么记录下起始点
            startX = targatView?.center.x ?? 0
            startY = targatView?.center.y ?? 0
            
            if let left = leftView {
            
                leftCenter = left.center
            }
            
            if let right = rightView {
            
                rightCenter = right.center
            }
        }
        
        // 事件进行时
        if recognizer.state == UIGestureRecognizerState.changed {
            
            var delatX:CGFloat = startX + transPoint.x
            
            // 因为不能在Y轴拖动 所以y 永远是0
            let delatY:CGFloat = startY
            // 左侧是图的中心偏移
            var changeX:CGFloat = delatX - startX
            
            // 限制拖拽最小的拖拽
            if leftView == nil {
                // 判断位置 加入动画
                if delatX > SCREEN_WIDTH * 0.5 {
                    delatX = SCREEN_WIDTH * 0.5
                    
                }
            }
            if rightView == nil {
            
                // 判断位置 加入动画
                if delatX < SCREEN_WIDTH * 0.5 {
                    delatX = SCREEN_WIDTH * 0.5
                    
                }
            }
            
            
            // 限制最大拖拽范围
            if delatX <= -SCREEN_WIDTH * (self.scale - 0.5) {
                delatX = -SCREEN_WIDTH * (self.scale - 0.5)
                // 当到达限制的时候 偏移也要限制
                changeX = delatX - startX
                
            }else if delatX >= SCREEN_WIDTH * (self.scale + 0.5) {
                delatX = SCREEN_WIDTH * (self.scale + 0.5)
                // 当到达限制的时候 偏移也要限制
                changeX = delatX - startX
            }
            
            // 偏移
            targatView?.center = CGPoint(x: delatX, y: delatY)
            leftView?.center = CGPoint(x: leftCenter.x + changeX, y: leftCenter.y)
            rightView?.center = CGPoint(x: rightCenter.x + changeX, y: rightCenter.y)
            
        }
        
        // 如果用户取消或者停止拖拽 要做判断 确认视图的位置
        if recognizer.state == UIGestureRecognizerState.ended || recognizer.state == UIGestureRecognizerState.cancelled {
            
            // 当前拖坏控制器中点x
            var endX:CGFloat = (targatView?.center.x)!
            
            // 判断位置 做动画悬停
            if endX < SCREEN_WIDTH * 0.5 {// 左侧停靠
                
                if ((SCREEN_WIDTH * 0.5) - endX) <= (SCREEN_WIDTH * self.scale * 0.1) {
                    // 拖动小于停靠比例宽度的十分之一 就回到原位
                    endX = SCREEN_WIDTH * 0.5
                    // 移除遮罩
                    removeMainMask()
                    
                }else {
                    // 大于的话  就停在屏幕宽度的三分之二处
                    endX = -SCREEN_WIDTH * (self.scale - 0.5)
                    // 加入遮罩
                    addMainMask()
                }
                
            }else { // 右侧停靠
                
                if (endX - (SCREEN_WIDTH * 0.5)) <= (SCREEN_WIDTH * self.scale * 0.1) {
                    // 拖动小于停靠比例宽度的十分之一 就回到原位
                    endX = SCREEN_WIDTH * 0.5
                    // 移除遮罩
                    removeMainMask()
                    
                }else {
                    // 大于的话  就停在屏幕宽度的三分之二处
                    endX = SCREEN_WIDTH * (self.scale + 0.5)
                    // 加入遮罩
                    addMainMask()
                }
            }
            
            // 动画停留
            UIView.animate(withDuration: 0.2, animations: {
                
                // 设置主页视图
                targatView?.center = CGPoint(x: endX, y: self.startY)
                
                // 设置抽屉
                leftView?.center = CGPoint(x: self.leftCenter.x + endX - self.startX, y: self.leftCenter.y)
                rightView?.center = CGPoint(x: self.rightCenter.x + endX - self.startX, y: self.rightCenter.y)
                
            })
        }
    }


}
