//
//  SwipeButton.swift
//  Analog
//
//  Created by Frederik Christensen on 26/04/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import UIKit

public class SwipeButton: UIControl {
    public enum SpinnerState {
        case off
        case spinning
        case hidden
    }

    var backgroundColors: [UInt : UIColor] = [:]
    var circleViewMargin: CGFloat = 4

    private(set) var swipeState: SpinnerState = .off

    let gestureRecognizer = UIPanGestureRecognizer()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe to use"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = Font.font(size: 19)
        label.textColor = Color.cappuccino
        label.alpha = 0.51
        return label
    }()

    private(set) lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.milk
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        return view
    }()

    private lazy var traceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.yellow
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()

    private var traceViewLeadingConstraint: NSLayoutConstraint?
    private var isMoving: Bool = false
    private let feedbackGenerator = UIImpactFeedbackGenerator()

    init() {
        super.init(frame: .zero)
        configureView()
        configureConstraints()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureView() {
        backgroundColor = .clear
        gestureRecognizer.maximumNumberOfTouches = 1
        gestureRecognizer.minimumNumberOfTouches = 1
        gestureRecognizer.delegate = self
        gestureRecognizer.delaysTouchesEnded = false
        gestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
        labelContainerView.addSubview(titleLabel)
        traceView.addSubview(labelContainerView)
        traceView.addSubview(circleView)
        addSubview(traceView)
        feedbackGenerator.prepare()
    }

    public func configureConstraints() {
        labelContainerView.bottomAnchor.constraint(equalTo: traceView.bottomAnchor).isActive = true
        labelContainerView.topAnchor.constraint(equalTo: traceView.topAnchor).isActive = true
        labelContainerView.trailingAnchor.constraint(equalTo: traceView.trailingAnchor).isActive = true
        labelContainerView.leadingAnchor.constraint(equalTo: traceView.leadingAnchor, constant: circleViewMargin * 2).isActive = true

        addConstraint(titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: intrinsicContentSize.height / 4))
        addConstraint(titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor))
        titleLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, constant: -intrinsicContentSize.height).isActive = true
        titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: intrinsicContentSize.height + 8).isActive = true

        circleView.topAnchor.constraint(equalTo: traceView.topAnchor, constant: circleViewMargin).isActive = true
        circleView.bottomAnchor.constraint(equalTo: traceView.bottomAnchor, constant: -circleViewMargin).isActive = true
        circleView.leadingAnchor.constraint(equalTo: traceView.leadingAnchor, constant: circleViewMargin).isActive = true
        circleView.widthAnchor.constraint(equalTo: circleView.heightAnchor).isActive = true

        traceView.topAnchor.constraint(equalTo: topAnchor, constant: circleViewMargin).isActive = true
        traceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -circleViewMargin).isActive = true
        traceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -circleViewMargin).isActive = true

        traceViewLeadingConstraint = traceView.leadingAnchor.constraint(equalTo: traceView.superview!.leadingAnchor)
        traceViewLeadingConstraint?.isActive = true
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        circleView.layer.cornerRadius = bounds.height / 2 - circleViewMargin * 2
        traceView.layer.cornerRadius = bounds.height / 2 - circleViewMargin
        circleView.layer.shadowOpacity = isEnabled ? 0.3 : 0.2
        let leading = (swipeState == .off) ? 0 : bounds.width - bounds.height + circleViewMargin
        if !isMoving, traceViewLeadingConstraint?.constant != leading {
            traceViewLeadingConstraint?.constant = leading
        }
    }

    private func updateBackgroundColor() {
        circleView.backgroundColor = isEnabled == false ? backgroundColors[UIControl.State.disabled.rawValue] : backgroundColors[UIControl.State.normal.rawValue]
    }

    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        circleView.backgroundColor = color
        circleView.layer.shadowColor = color.cgColor
        backgroundColors[state.rawValue] = color
    }

    public func setBackgroundColors(_ color: UIColor) {
        setBackgroundColor(color, for: .normal)
    }

    override public var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let leadingSpace = max(0, min(location.x, bounds.width - bounds.height / 2) - circleView.bounds.width / 2)
        switch gesture.state {
        case .began where circleView.convert(circleView.frame, to: self).insetBy(dx: -20, dy: 0).contains(location):
            isMoving = true
            UIView.animate(withDuration: 0.1) {
                self.traceViewLeadingConstraint?.constant = leadingSpace
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        case .changed where isMoving:
            traceViewLeadingConstraint?.constant = leadingSpace
            layoutIfNeeded()
        case .ended where isMoving:
            isMoving = false
            if location.x > (bounds.width - bounds.height) * 0.7 {
                if swipeState != .spinning {
                    setSwipeState(.spinning)
                    sendActions(for: .valueChanged)
                    feedbackGenerator.impactOccurred()
                }
            } else {
                if swipeState != .off {
                    setSwipeState(.off)
                    sendActions(for: .valueChanged)
                }
            }
            UIView.animate(withDuration: 0.125) {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        default:
            break
        }
    }

    func setSwipeState(_ swipeState: SpinnerState, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.swipeState = swipeState
        if animated && window != nil {
            setNeedsLayout()
            UIView.animate(withDuration: 0.25, animations: {
                self.applyPropertiesForState(swipeState)
                self.layoutIfNeeded()
            }, completion: { _ in
                completion?()
            })
        } else {
            applyPropertiesForState(swipeState)
            setNeedsLayout()
            completion?()
        }
    }

    private func applyPropertiesForState(_ state: SpinnerState) {
        switch state {
        case .off:
            gestureRecognizer.isEnabled = true
            traceViewLeadingConstraint?.constant = 0
            circleView.alpha = 1
            traceView.transform = .identity
        case .spinning:
            gestureRecognizer.isEnabled = false
            traceViewLeadingConstraint?.constant = bounds.width - bounds.height
            circleView.alpha = 1
            traceView.transform = .identity

            self.sendActions(for: .primaryActionTriggered)
        case .hidden:
            circleView.alpha = 1
            traceView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
    }

    public func reset() {
        self.setSwipeState(.off, animated: true)
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }
}

extension SwipeButton: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer === self.gestureRecognizer
    }

    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, gestureRecognizer === self.gestureRecognizer else { return true }
        let velocity = panGestureRecognizer.velocity(in: self)
        return abs(velocity.x) > abs(velocity.y)
    }
}
