//
//  YMVideoTopicController.swift
//  TodayNews
//
//  Created by 杨蒙 on 16/8/5.
//  Copyright © 2016年 hrscy. All rights reserved.
//

import UIKit

let videoTopicCellID = "YMVideTopicCell"

class YMVideoTopicController: UITableViewController {

    // 下拉刷新的时间
    private var pullRefreshTime: NSTimeInterval?
    // 记录点击的顶部标题
    var videoTitle: YMVideoTopTitle?
    // 存放新闻主题的数组
    var videoTopics = [YMVideoTopic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupRefresh()
    }
    
    private func setupUI() {
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        let nib = UINib(nibName: String(YMVideoTopicCell), bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: videoTopicCellID)
        tableView.rowHeight = 270
        tableView.separatorStyle = .None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension YMVideoTopicController {
    
    /// 添加上拉刷新和下拉刷新
    private func setupRefresh() {
        pullRefreshTime = NSDate().timeIntervalSince1970
        // 获取首页不同分类的新闻内容
        YMNetworkTool.shareNetworkTool.loadVideoCategoryNewsFeed(videoTitle!.category!, tableView: tableView) { [weak self] (nowTime, newTopics) in
            self!.pullRefreshTime = nowTime
            self!.videoTopics = newTopics
            self!.tableView.reloadData()
        }
        // 获取更多新闻内容
        YMNetworkTool.shareNetworkTool.loadVideoCategoryMoreNewsFeed(videoTitle!.category!, lastRefreshTime: pullRefreshTime!, tableView: tableView) { [weak self] (moreTopics) in
            self?.videoTopics += moreTopics
            self!.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(videoTopicCellID) as! YMVideoTopicCell
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
