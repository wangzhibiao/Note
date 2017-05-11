# EZDrawer Swift3.0 
* 一个简陋的抽屉菜单效果。可同时或单独包含左右抽屉菜单。
* Installation with CocoaPods：`pod 'EZDrawer'`

```objc
        // 创建控制器
        let main = EZMainViewController()
        let left = EZLeftViewController()
        let right = EZRightViewController()
        
        // 管理器
        let manager = EZDrawerManager.shared
        
        // 创建根是图如果没有主页视图控制器则返回nil 
          let root = manager.setupChilds(main: main, left: nil, right: nil)
//        let root = manager.setupChilds(main: main, left: left, right: nil)
//        let root = manager.setupChilds(main: main, left: nil, right: right)

        // 设置停靠比例默认 0.7 范围 0.1～0.9
        manager.scale = 0.6
        
        // 设置根是图
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = root
        window?.makeKeyAndVisible()
```
