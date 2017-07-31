//
//  ViewController.swift
//  NewsReader
//
//  Created by Myke on 31/07/2017.
//  Copyright © 2017 Myke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var tableview: UITableView!
    
    var articles: [Article]? = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchArticles()
        
        
    }
    
    func fetchArticles() {
        
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=techcrunch&sortBy=top&apiKey=1436ad4d7e164273a9277cd23670b3a4")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {(data,response,error) in
            if error != nil {
                print(error)
                return
            }
            
            self.articles = [Article]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String: AnyObject]] {
                    
                    for articleFromJson in articlesFromJson {
                        
                        let article = Article()
                        
                        if let title = articleFromJson["title"] as? String, let author = articleFromJson["author"] as? String, let desc = articleFromJson["description"] as? String, let url = articleFromJson["url"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.descript = desc
                            article.headline = title
                            article.url = url
                            article.imgageUrl = urlToImage
                          
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.sync {
                    
                    self.tableview.reloadData()
                }
                
                
            }catch let error {
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.titleText.text = self.articles?[indexPath.item].headline
        cell.descriptionText.text = self.articles?[indexPath.item].descript
        cell.author.text = self.articles?[indexPath.item].author
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    

}

