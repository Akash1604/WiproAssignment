//
//  ViewController.swift
//  AssignmentTestApp
//
//  Created by akash on 26/02/20.
//  Copyright © 2020 akash. All rights reserved.
//

import UIKit
import SystemConfiguration
import SDWebImage


class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var postsTable:UITableView!
    var viewmodel : ViewModel?
    var canadaDetailArray = [CanadaDetails]()
    var refreshControl = UIRefreshControl()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel = ViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        self.postsTable.addSubview(refreshControl)
        
        postsTable.delegate = self
        postsTable.dataSource = self
        self.title = "POSTS"
        postsTable.tableFooterView = UIView(frame: .zero)
        postsTable.estimatedRowHeight = 1000
        postsTable.rowHeight = UITableView.automaticDimension

        if Reachability.isConnectedToNetwork(){
            getPosts()
        }else{
            postsTable.reloadData()
        }
    }
    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        if Reachability.isConnectedToNetwork(){
            getPosts()
        }else{
            postsTable.reloadData()
        }
    }
    func getPosts(){
        HttpClientApi.instance().getAPICall(url: Config.POSTS,parameter: [:], method: .get, decodingType: PostData.self, callback: Callback(onSuccess: { [weak self] (result) in
            guard let weakSelf = self else { return }
            weakSelf.viewmodel?.response = result as! PostData
            weakSelf.viewmodel?.getCanadaDetail(response:weakSelf.viewmodel!.response)
            weakSelf.canadaDetailArray = weakSelf.viewmodel!.canadaDetail
            DispatchQueue.main.async {
                weakSelf.title = weakSelf.viewmodel?.response.title
                print(weakSelf.canadaDetailArray)
                 weakSelf.postsTable.reloadData()
                weakSelf.refreshControl.endRefreshing()
            }
        }, onFailure: { [weak self] (error) in
            print(error)
            guard let weakSelf = self else { return }
            weakSelf.refreshControl.endRefreshing()
        }))
    }
    
}

extension ViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.canadaDetailArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let post = canadaDetailArray[indexPath.row]
        if canadaDetailArray.count > 0 {
            cell.title.text = post.title
            cell.body.text = post.description
            if let imageRef = post.imageHref {
                cell.imgView.sd_setImage(with: URL(string: imageRef), placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.imgView.image = UIImage(named: "placeholder")
            }
            
        }else{
            cell.title.text = "-"
            cell.body.text = "-"
            cell.imgView.image = UIImage(named: "placeholder")
        }
        

        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 5

        cell.layer.shadowOpacity = 0.40
        cell.layer.masksToBounds = false;
        cell.clipsToBounds = false;
        cell.body.numberOfLines = 0
        cell.title.numberOfLines = 0
        cell.title.lineBreakMode = NSLineBreakMode.byCharWrapping


        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

