//
//  UIView + Extension.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.30
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: .zero, height: 5)
    }

    @discardableResult
    func leadingSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func trailingSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func topSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func bottomSpace(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let view = getView(with) else {
            return self
        }
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func widthConstraint(constant: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func heightConstraint(constant: CGFloat, priority: UILayoutPriority = .required) -> UIView {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        constraint.priority = priority
        return self
    }

    @discardableResult
    func horizontalSpacing(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let _ = getView(with) else {
            return self
        }
        return leadingSpace(constant: constant, priority: priority).trailingSpace(constant: -constant, priority: priority)
    }

    @discardableResult
    func verticalSpacing(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let _ = getView(with) else {
            return self
        }
        return topSpace(constant: constant, priority: priority).bottomSpace(constant: -constant, priority: priority)
    }

    @discardableResult
    func spaceAround(with: Any? = nil, constant: CGFloat = 0, priority: UILayoutPriority = .required) -> UIView {
        guard let _ = getView(with) else {
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        return topSpace(constant: constant, priority: priority).bottomSpace(constant: -constant, priority: priority).leadingSpace(constant: constant, priority: priority).trailingSpace(constant: -constant, priority: priority)
    }

    @discardableResult
    func getView(_ with: Any?) -> UIView? {
        if let view = with as? UIView {
            return view
        } else {
            return superview
        }
    }
}
