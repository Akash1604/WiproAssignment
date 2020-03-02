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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel = ViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        postsTable.delegate = self
        postsTable.dataSource = self
        self.title = "POSTS"
        postsTable.tableFooterView = UIView(frame: .zero)
        postsTable.estimatedRowHeight = 1000
        postsTable.rowHeight = UITableView.automaticDimension
        //coredataResult  = CoredataHandler().getAllPosts() ?? nil

        if Reachability.isConnectedToNetwork(){
            getPosts()
        }else{
            postsTable.reloadData()
        }
    }
    
    func getPosts(){
        HttpClientApi.instance().getAPICall(url: Config.POSTS,parameter: [:], method: .get, decodingType: PostData.self, callback: Callback(onSuccess: { (result) in
            self.viewmodel?.response = result as! PostData
            self.viewmodel?.getCanadaDetail(response:self.viewmodel!.response)
            self.canadaDetailArray = self.viewmodel!.canadaDetail
            DispatchQueue.main.async {
                /*if self.coredataResult?.count == 0 {
                    for post in self.viewmodel!.response {
                        CoredataHandler().save(post: post)
                    }
                }*/
                print(self.canadaDetailArray)
                 self.postsTable.reloadData()
            }
        }, onFailure: { (error) in
            print(error)
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
        //return 280.0
    }
}

