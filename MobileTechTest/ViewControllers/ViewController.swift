//
//  ViewController.swift
//  MobileTechTest
//
//  Created by victor.sanchez on 9/10/22.
//

import UIKit

class ViewController: UIViewController{
    
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deletePostsButton: UIButton!
    
    let noItemFoundImage: UIImageView = UIImageView(image: UIImage(named: "noItemFound"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts"
        let reloadButton = UIBarButtonItem(title: "Reload posts", style: .done, target: self, action: #selector(loadPosts))
        self.navigationItem.rightBarButtonItem = reloadButton
        self.view.addSubview(self.tableView)
        setItemNotFoundImage()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        fetchPosts(){ result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                self.deletePostsButton.isHidden = false
                self.noItemFoundImage.isHidden = true
                self.tableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "ERROR", message: "Something went wrong, please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    self.noItemFoundImage.isHidden = false
                }
                
            }
        }
    }
    
    @objc func loadPosts(){
        self.fetchPosts(){  result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.deletePostsButton.isHidden = false
                    self.noItemFoundImage.isHidden = true
                    self.tableView.reloadData()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.deletePostsButton.isHidden = true
                    self.noItemFoundImage.isHidden = false
                    let alert = UIAlertController(title: "Error", message: "Something went wrong, please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func didTapDeletePosts(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete all posts?",
                                                message: "This action delete all posts except the posts selected as favorite",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            let postsFavorited = self.posts.filter({ $0.isFavorite ?? true })
            self.posts = postsFavorited
            self.noItemFoundImage.isHidden = postsFavorited.isEmpty ? self.showNotFoundItemImage() : true
            self.reloadTableWithAnimation()
            self.deletePostsButton.isHidden = postsFavorited.isEmpty ? true : false
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadTableWithAnimation(){
        UIView.transition(with: tableView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    func showNotFoundItemImage() -> Bool {
        UIView.transition(with: noItemFoundImage,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: { self.noItemFoundImage.isHidden = false })
        return false
    }
    
    func setItemNotFoundImage() {
        self.noItemFoundImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.noItemFoundImage)
        self.noItemFoundImage.isHidden = true
        self.noItemFoundImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.noItemFoundImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.noItemFoundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.noItemFoundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.postLabel?.text = post.title
        if post.isFavorite == true {
            cell.favoriteImage.image = UIImage(systemName: "star.fill")
        } else {
            cell.favoriteImage.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let post = posts[indexPath.row]
        let favoriteButtonTitle = post.isFavorite ?? false ? "Unfavorite" : "Favorite"
        
        let favoriteButton = UIContextualAction(style: .normal, title: favoriteButtonTitle) { (_, _, _) in
            self.posts[indexPath.row].isFavorite?.toggle()
            self.posts.sort(by: {($0.isFavorite ?? true) && !($1.isFavorite ?? true)})
            self.reloadTableWithAnimation()
        }
        
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.posts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let actions = UISwipeActionsConfiguration(actions: [deleteButton, favoriteButton])
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.fetchAuthor(authorId: posts[indexPath.row].userId){ result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let viewController = PostDetailsViewController(
                        commentId: self.posts[indexPath.row].id,
                        postTitle: self.posts[indexPath.row].title,
                        postDescription: self.posts[indexPath.row].body,
                        authorName: data.name,
                        authorUserName: data.username,
                        authorEmail: data.email,
                        authorCity: data.address.city)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong, please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension ViewController {
    func fetchPosts(completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) { (data,response,error) in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            var dataReceived = [Post]()
            do {
                dataReceived = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
            for item in dataReceived { item.isFavorite = false }
            self.posts = dataReceived
        }
        task.resume()
    }
    
    func fetchAuthor(authorId: Int, completion: @escaping (Result<Author, Error>) -> Void){
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(authorId)")
        let task = URLSession.shared.dataTask(with: url!) { (data,response,error) in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            do {
                let responseData = try JSONDecoder().decode(Author.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}

