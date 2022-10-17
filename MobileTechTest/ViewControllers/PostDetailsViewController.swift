//
//  PostDetailsViewController.swift
//  Zemoga
//
//  Created by victor.sanchez on 6/10/22.
//

import RxCocoa
import RxSwift
import UIKit

class PostDetailsViewController: UIViewController, UITableViewDelegate {
    
    private var viewModel = ViewModel()
    private var disposeBag = DisposeBag()
    private var commentId: Int
    private var postTitle: String
    private var postDescription: String
    private var authorName: String
    private var authorUserName: String
    private var authorEmail: String
    private var authorCity: String
    var comments = [Comment]()
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Author:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorUserNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorEmailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City:"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let authorCityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Comments"
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(PostDetailsTableViewCell.self, forCellReuseIdentifier: "PostDetailsTableViewCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        [self.titleLabel,
         self.postTitleLabel,
         self.descriptionLabel,
         self.postDescriptionLabel,
         self.authorLabel,
         self.authorNameLabel,
         self.usernameLabel,
         self.authorUserNameLabel,
         self.emailLabel,
         self.authorEmailLabel,
         self.cityLabel,
         self.authorCityLabel,
         self.commentsLabel].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    init(commentId: Int, postTitle: String, postDescription: String, authorName: String, authorUserName: String,
         authorEmail: String, authorCity: String) {
        self.commentId = commentId
        self.postTitle = postTitle
        self.postDescription = postDescription
        self.authorName = authorName
        self.authorUserName = authorUserName
        self.authorEmail = authorEmail
        self.authorCity = authorCity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Details"
        configureView()
        viewModel.fetchComments(commentId: commentId, completion: { result in
            switch result {
            case .success(_):
                print("**** SUCCESS ****")
            case .failure(_):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong, please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        bindTableData()
        addConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.frame = view.bounds
    }
    
    func configureView() {
        postTitleLabel.text = postTitle
        postDescriptionLabel.text = postDescription
        authorNameLabel.text = authorName
        authorUserNameLabel.text = authorUserName
        authorEmailLabel.text = authorEmail
        authorCityLabel.text = authorCity
        [mainView,
         stackView,
         tableView].forEach { view.addSubview($0) }
    }
    
    func bindTableData(){
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.comments.bind(to: tableView.rx.items(cellIdentifier: "PostDetailsTableViewCell", cellType: PostDetailsTableViewCell.self)) { row, item, cell in
            cell.textLabel?.text = "Name: \(item.name)\nEmail: \(item.email)\nComment: \(item.body)"
            cell.textLabel?.numberOfLines = 0
        }.disposed(by: disposeBag)
    }
    
    func addConstraints(){
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}
