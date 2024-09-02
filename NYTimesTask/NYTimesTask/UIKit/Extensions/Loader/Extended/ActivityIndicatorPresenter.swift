//
//  NVActivityIndicatorPresenter.swift
//  NVActivityIndicatorView
//
// The MIT License (MIT)

// Copyright (c) 2016 Vinh Nguyen

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#if canImport(UIKit)
    import UIKit

    /// Class packages information used to display UI blocker.
    public final class ActivityData {
        /// Size of activity indicator view.
        let size: CGSize

        /// Message displayed under activity indicator view.
        let message: String?

        /// Font of message displayed under activity indicator view.
        let messageFont: UIFont

        /// Message spacing to activity indicator view.
        let messageSpacing: CGFloat

        /// Animation type.
        let type: ActivityIndicatorType

        /// Color of activity indicator view.
        let color: UIColor

        /// Color of text.
        let textColor: UIColor

        /// Padding of activity indicator view.
        let padding: CGFloat

        /// Display time threshold to actually display UI blocker.
        let displayTimeThreshold: Int

        /// Minimum display time of UI blocker.
        let minimumDisplayTime: Int

        /// Background color of the UI blocker
        let backgroundColor: UIColor

        /**
         Create information package used to display UI blocker.

         Appropriate NVActivityIndicatorView.DEFAULT_* values are used for omitted params.

         - parameter size:                 size of activity indicator view.
         - parameter message:              message displayed under activity indicator view.
         - parameter messageFont:          font of message displayed under activity indicator view.
         - parameter messageSpacing:       message spacing to activity indicator view.
         - parameter type:                 animation type.
         - parameter color:                color of activity indicator view.
         - parameter padding:              padding of activity indicator view.
         - parameter displayTimeThreshold: display time threshold to actually display UI blocker.
         - parameter minimumDisplayTime:   minimum display time of UI blocker.
         - parameter textColor:            color of the text below the activity indicator view. Will match color parameter if not set, otherwise DEFAULT_TEXT_COLOR if color is not set.

         - returns: The information package used to display UI blocker.
         */
        public init(size: CGSize? = nil,
                    message: String? = nil,
                    messageFont: UIFont? = nil,
                    messageSpacing: CGFloat? = nil,
                    type: ActivityIndicatorType? = nil,
                    color: UIColor? = nil,
                    padding: CGFloat? = nil,
                    displayTimeThreshold: Int? = nil,
                    minimumDisplayTime: Int? = nil,
                    backgroundColor: UIColor? = nil,
                    textColor: UIColor? = nil) {
            self.size = size ?? ActivityIndicatorView.DEFAULT_BLOCKER_SIZE
            self.message = message ?? ActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE
            self.messageFont = messageFont ?? ActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT
            self.messageSpacing = messageSpacing ?? ActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_SPACING
            self.type = type ?? ActivityIndicatorView.DEFAULT_TYPE
            self.color = color ?? ActivityIndicatorView.DEFAULT_COLOR
            self.padding = padding ?? ActivityIndicatorView.DEFAULT_PADDING
            self.displayTimeThreshold = displayTimeThreshold ?? ActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD
            self.minimumDisplayTime = minimumDisplayTime ?? ActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME
            self.backgroundColor = backgroundColor ?? ActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR
            self.textColor = textColor ?? color ?? ActivityIndicatorView.DEFAULT_TEXT_COLOR
        }
    }

    private protocol ActivityIndicatorPresenterState {
        func startAnimating(presenter: ActivityIndicatorPresenter, _ fadeInAnimation: FadeInAnimation?)
        func stopAnimating(presenter: ActivityIndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?)
    }

    private struct ActivityIndicatorPresenterStateWaitingToStart: ActivityIndicatorPresenterState {
        func startAnimating(presenter: ActivityIndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
            guard let activityData = presenter.data else { return }

            presenter.show(with: activityData, fadeInAnimation)
            presenter.state = .animating
            presenter.waitingToStartGroup.leave()
        }

        func stopAnimating(presenter: ActivityIndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
            presenter.state = .stopped
            presenter.waitingToStartGroup.leave()
        }
    }

    private struct ActivityIndicatorPresenterStateAnimating: ActivityIndicatorPresenterState {
        func startAnimating(presenter: ActivityIndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
            // Do nothing
        }

        func stopAnimating(presenter: ActivityIndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
            guard let activityData = presenter.data else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(activityData.minimumDisplayTime)) {
                guard presenter.state == .waitingToStop else { return }

                presenter.stopAnimating(fadeOutAnimation)
            }
            presenter.state = .waitingToStop
        }
    }

    private struct ActivityIndicatorPresenterStateWaitingToStop: ActivityIndicatorPresenterState {
        func startAnimating(presenter: ActivityIndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
            presenter.stopAnimating(nil)

            guard let activityData = presenter.data else { return }
            presenter.startAnimating(activityData, fadeInAnimation)
        }

        func stopAnimating(presenter: ActivityIndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
            presenter.hide(fadeOutAnimation)
            presenter.state = .stopped
        }
    }

    private struct ActivityIndicatorPresenterStateStopped: ActivityIndicatorPresenterState {
        func startAnimating(presenter: ActivityIndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
            guard let activityData = presenter.data else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(activityData.displayTimeThreshold)) {
                guard presenter.state == .waitingToStart else { return }

                presenter.startAnimating(activityData, fadeInAnimation)
            }
            presenter.state = .waitingToStart
            presenter.waitingToStartGroup.enter()
        }

        func stopAnimating(presenter: ActivityIndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
            // Do nothing
        }
    }

    /// Presenter that displays NVActivityIndicatorView as UI blocker.
    public final class ActivityIndicatorPresenter {
        fileprivate enum State: ActivityIndicatorPresenterState {
            case waitingToStart
            case animating
            case waitingToStop
            case stopped

            var performer: ActivityIndicatorPresenterState {
                switch self {
                case .waitingToStart: return ActivityIndicatorPresenterStateWaitingToStart()
                case .animating: return ActivityIndicatorPresenterStateAnimating()
                case .waitingToStop: return ActivityIndicatorPresenterStateWaitingToStop()
                case .stopped: return ActivityIndicatorPresenterStateStopped()
                }
            }

            func startAnimating(presenter: ActivityIndicatorPresenter, _ fadeInAnimation: FadeInAnimation?) {
                performer.startAnimating(presenter: presenter, fadeInAnimation)
            }

            func stopAnimating(presenter: ActivityIndicatorPresenter, _ fadeOutAnimation: FadeOutAnimation?) {
                performer.stopAnimating(presenter: presenter, fadeOutAnimation)
            }
        }

        private let restorationIdentifier = "NVActivityIndicatorViewContainer"
        private let messageLabel: UILabel = {
            let label = UILabel()

            label.textAlignment = .center
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false

            return label
        }()

        fileprivate var state: State = .stopped
        fileprivate var data: ActivityData? // Shared activity data across states

        /// The group to synchronize the message so that the one set by `setMessage` is always displayed after the initial message passed to `startAnimating(_:)`.
        fileprivate let waitingToStartGroup = DispatchGroup()

        /// Shared instance of `NVActivityIndicatorPresenter`.
        public static let sharedInstance = ActivityIndicatorPresenter()

        /// Current status of animation, read-only.
        public var isAnimating: Bool { return state == .animating || state == .waitingToStop }

        private init() {}

        // MARK: - Public interface

        /**
         Display UI blocker.

         - parameter data: Information package used to display UI blocker.
         - parameter fadeInAnimation: Fade in animation.
         */
        public final func startAnimating(_ data: ActivityData, _ fadeInAnimation: FadeInAnimation? = nil) {
            self.data = data
            state.startAnimating(presenter: self, fadeInAnimation)
        }

        /**
         Remove UI blocker.

         - parameter fadeOutAnimation: Fade out animation.
         */
        public final func stopAnimating(_ fadeOutAnimation: FadeOutAnimation? = nil) {
            state.stopAnimating(presenter: self, fadeOutAnimation)
        }

        /// Set message displayed under activity indicator view.
        ///
        /// - Parameter message: message displayed under activity indicator view.
        public final func setMessage(_ message: String?) {
            waitingToStartGroup.notify(queue: DispatchQueue.main) {
                self.messageLabel.text = message
            }
        }

        // MARK: - Helpers

        fileprivate func show(with activityData: ActivityData, _ fadeInAnimation: FadeInAnimation?) {
            let containerView = UIView(frame: UIScreen.main.bounds)

            containerView.backgroundColor = activityData.backgroundColor
            containerView.restorationIdentifier = restorationIdentifier
            containerView.translatesAutoresizingMaskIntoConstraints = false
            fadeInAnimation?(containerView)

            let activityIndicatorView = ActivityIndicatorView(
                frame: CGRect(x: 0, y: 0, width: activityData.size.width, height: activityData.size.height),
                type: activityData.type,
                color: activityData.color,
                padding: activityData.padding)

            activityIndicatorView.startAnimating()
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(activityIndicatorView)

            // Add constraints for `activityIndicatorView`.
            ({
                let xConstraint = NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerX, multiplier: 1, constant: 0)
                let yConstraint = NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: activityIndicatorView, attribute: .centerY, multiplier: 1, constant: 0)

                containerView.addConstraints([xConstraint, yConstraint])
            }())

            messageLabel.font = activityData.messageFont
            messageLabel.textColor = activityData.textColor
            messageLabel.text = activityData.message
            containerView.addSubview(messageLabel)

            // Add constraints for `messageLabel`.
            ({
                let leadingConstraint = NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: messageLabel, attribute: .leading, multiplier: 1, constant: -8)
                let trailingConstraint = NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: messageLabel, attribute: .trailing, multiplier: 1, constant: 8)

                containerView.addConstraints([leadingConstraint, trailingConstraint])
            }())
            ({
                let spacingConstraint = NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: activityIndicatorView, attribute: .bottom, multiplier: 1, constant: activityData.messageSpacing)

                containerView.addConstraint(spacingConstraint)
            }())

            guard let keyWindow = UIApplication.shared.keyWindow else { return }

            keyWindow.addSubview(containerView)

            // Add constraints for `containerView`.
            ({
                let leadingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
                let trailingConstraint = NSLayoutConstraint(item: keyWindow, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
                let topConstraint = NSLayoutConstraint(item: keyWindow, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
                let bottomConstraint = NSLayoutConstraint(item: keyWindow, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)

                keyWindow.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
            }())
        }

        fileprivate func hide(_ fadeOutAnimation: FadeOutAnimation?) {
            for window in UIApplication.shared.windows {
                for item in window.subviews
                    where item.restorationIdentifier == restorationIdentifier {
                    if let fadeOutAnimation = fadeOutAnimation {
                        fadeOutAnimation(item) {
                            item.removeFromSuperview()
                        }
                    } else {
                        item.removeFromSuperview()
                    }
                }
            }
        }
    }
#endif
