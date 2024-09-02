//
//  ListTableViewCell.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    private let containerView = Helper.makeUIView(cornerRadius: 10)
    private let userImageView = Helper.makeImageView(cornerRadius: 10)
    private let titleLabel = Helper.makeLabel(line: 2, fontFamily: UIFont.systemFont(ofSize: 16, weight: .semibold), textColor: .black, align: .left)
    private let userLabel = Helper.makeLabel(line: 2, fontFamily: UIFont.systemFont(ofSize: 14, weight: .semibold), textColor: .darkGray, align: .left)
    private let createdLabel = Helper.makeLabel(line: 2, fontFamily: UIFont.systemFont(ofSize: 14, weight: .medium), textColor: .lightGray, align: .center)
    private let updatedLabel = Helper.makeLabel(line: 2, fontFamily: UIFont.systemFont(ofSize: 14, weight: .medium), textColor: .lightGray, align: .center)
    private let textHStackView = Helper.makeStackView(axis: .horizontal, distribution: .fillEqually, alignment: .fill)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.applyShadow(cornerRadius: 10)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupView() {
        contentView.addSubview(containerView)
        containerView.horizontalSpacing(constant: 16).verticalSpacing(constant: 8)
        containerView.addSubview(userImageView)
        userImageView.verticalSpacing(constant: 8).leadingSpace(constant: 8).widthConstraint(constant: 112)

        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.heightConstraint(constant: 40)
        titleLabel.text = "Do feel free to write back for any clarifications if any."

        containerView.addSubview(userLabel)
        userLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        userLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        userLabel.heightConstraint(constant: 20)
        userLabel.text = "Created by:- Monish Kumar"

        containerView.addSubview(textHStackView)
        textHStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        textHStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        textHStackView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 8).isActive = true
        textHStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true

        textHStackView.addArrangedSubview(createdLabel)
        textHStackView.addArrangedSubview(updatedLabel)

        createdLabel.text = "Created by \n ---"
        updatedLabel.text = "Closed by \n ---"
    }

    override func prepareForReuse() {
        userImageView.image = nil
    }

    func configue(data: NYTimesDataModel) {
        titleLabel.text = data.title
        userLabel.text = "Author: \(data.author ?? "No Author")".capitalized
        if let publishedDate = data.newsPublishedDate {
            createdLabel.attributedText = Helper.attributedDate(text: publishedDate, type: .create)
        }
        if let updatedDate = data.newsUpdatedDate {
            updatedLabel.attributedText = Helper.attributedDate(text: updatedDate, type: .update)
        }
        if let userImageURL = data.imageUrl {
            userImageView.loadImageUsingCacheWithURLString(userImageURL, placeHolder: UIImage(named: "launchIcon"))
        }
    }
}
