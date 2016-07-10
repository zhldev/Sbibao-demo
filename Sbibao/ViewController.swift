//
//  ViewController.swift
//  Sbibao
//
//  Created by Zeng on 16/7/10.
//  Copyright © 2016年 Zeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
//    var finished: ()->()?
    //当前写法代表闭包返回值可以是nil
    var finished: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //OC中的解决方案
        //_weak typeof(self) weakSelf = self
        
        weak var weakSelf = self
        loadData { 
            print("回到主线程，更新UI")
            weakSelf!.view.backgroundColor = UIColor.redColor()
        }
        
//        scrollView =  createScroView { () -> Int in
//            return 10
//        }
       
        //通过闭包告诉定义方法创建多少按钮
        scrollView = createScroView({ () -> Int in
            return 8
            }, btnWithIndex: { (index) -> UIView in
                let width = 80
                let btn = UIButton()
                btn.setTitle("标题\(index)", forState: .Normal)
                btn.frame = CGRect(x: index*width+5, y: 0, width: width, height:50 )
                return btn
        })
    }
    
    
    func createScroView(btnCount: ()-> Int, btnWithIndex: (index: Int) -> UIView) -> UIScrollView{
        let count = btnCount()
        

        for i in 0..<count{
            
            let subView = btnWithIndex(index: i)
            scrollView.addSubview(subView)
            scrollView.contentSize = CGSize(width: CGFloat(count)*subView.frame.width, height: 50)


            /*
            let btn = UIButton()
            btn.setTitle("标题\(i)", forState: .Normal)
            btn.frame = CGRect(x: i*width+5, y: 0, width: width, height:50 )
            scrollView.addSubview(btn)
             */

        }
 
        return scrollView
    }
    
    
    /** 闭包的循环引用 */
    
    
    func loadData(finished: ()->()){
        print("执行耗时操作")
        self.finished = finished
        finished()
    }
    
    
    //出栈会被释放，相当于OC中的dealloc
    deinit{
        print("退出栈，回退")
    }

}

