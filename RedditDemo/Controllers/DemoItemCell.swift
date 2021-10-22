//
//  DemoItemCell.swift
//  RedditDemo
//
//  Created by Muhammad Usman on 22/10/2021.
//

import UIKit

class DemoItemCell: UITableViewCell {
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let scoreView: UIView = {
        let label = UIView()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let commentsView: UIView = {
        let label = UIView()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let score: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let comments: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = .init(5)
        stackView.axis = .horizontal
        return stackView
    }()
    
    
    
    let ivTopLine: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        line.translatesAutoresizingMaskIntoConstraints = false
//        imageView.addTopAndBottomBorders()
        return line
    }()
    
    let ivBottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = .black
        line.translatesAutoresizingMaskIntoConstraints = false
//        imageView.addTopAndBottomBorders()
        return line
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: DemoItemCell.identifier)
        backgroundColor = .white
        addSubview(cardView)
        cardView.anchor(top: topAnchor,
                        left: leftAnchor,
                        bottom: bottomAnchor,
                        right: rightAnchor,
                        paddingTop: .init(12),
                        paddingLeft: .init(12),
                        paddingBottom: .init(12),
                        paddingRight: .init(12))

        
        cardView.shadowColor = UIColor.blue.withAlphaComponent(.init(0.25))
        cardView.shadowRadius = 2
        cardView.shadowOpacity = 2
        cardView.shadowOffset = .init(width: 2, height: 2)
        
        cardView.addSubview(title)
        
        
        
        scoreView.addSubview(score)
        commentsView.addSubview(comments)
        
        score.anchor(top: scoreView.topAnchor, left: scoreView.leftAnchor, bottom: scoreView.bottomAnchor, right: scoreView.rightAnchor)
        comments.anchor(top: commentsView.topAnchor, left: commentsView.leftAnchor, bottom: commentsView.bottomAnchor, right: commentsView.rightAnchor)
        
        stackView.addArrangedSubview(scoreView)
        stackView.addArrangedSubview(commentsView)
        
        title.anchor(top: cardView.topAnchor,
                     left: cardView.leftAnchor,
                     right: cardView.rightAnchor,
                     paddingTop: .init(8),
                     paddingLeft: .init(8),
                     paddingBottom: .init(8),
                     paddingRight: .init(8))
        
        cardView.addSubview(postImageView)
        
        postImageView.anchor(top: title.bottomAnchor,
                             left: cardView.leftAnchor,
                             right: cardView.rightAnchor,
                             paddingLeft: .init(0),
                             paddingRight: .init(0),
                             width: cardView.bounds.width)
        
        cardView.addSubview(stackView)
        
        stackView.anchor(top: postImageView.bottomAnchor,
                         left: cardView.leftAnchor,
                         bottom: cardView.bottomAnchor,
                         right: cardView.rightAnchor,
                         paddingTop: .init(8),
                         paddingLeft: .init(8),
                         paddingBottom: .init(8),
                         paddingRight: .init(8))
//
        
        cardView.addSubview(ivBottomLine)
        cardView.addSubview(ivTopLine)
        cardView.bringSubviewToFront(ivTopLine)
        ivBottomLine.anchor(left: cardView.leftAnchor, bottom: postImageView.bottomAnchor, right: cardView.rightAnchor,height: .init(1))
        ivTopLine.anchor(top: postImageView.topAnchor,left: cardView.leftAnchor, bottom: title.bottomAnchor, right: cardView.rightAnchor,height: .init(1))
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCell(_ item:ItemList?){
        title.text = item?.title
        score.text = "Score : \(item?.score ?? 0)"
        comments.text = "Comments : \(item?.num_comments ?? 0)"
        let cellWidth = DataManager.sharedInstance.screenWidth - 24
        let thumbWidth = CGFloat.init(item?.thumbnail_width ?? 0)
        let thumbHeight = CGFloat.init(item?.thumbnail_height ?? 0)
        let ratioOfImage = (CGFloat.init(thumbWidth)/CGFloat.init(thumbHeight))
        let imageHeight = floor(CGFloat.init(cellWidth)/ratioOfImage)
        
        if imageHeight > CGFloat.init(0){
            postImageView.loadGif(url: URL.init(item?.thumbnail ?? ""), placeholder: .BannerImage, mode: .scaleAspectFit)
            postImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        }else{
            postImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true

            
        }
        
    }
    
}
