//
//  SidebarContainerViewController.swift
//
// Copyright (c) 2015 apploft GmbH (http://www.apploft.de)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public class AdaptiveSidebarViewController : UIViewController {
    
    //MARK: Public

    public var mainViewController : UIViewController?
    public var sideViewController : UIViewController?
    public var sideViewWidth : CGFloat = 320 {
        didSet {
            sideViewWidthConstraint.constant = sideViewWidth
        }
    }
    
    public func showSideView(animated: Bool) {
        updateSideView(0, animated: animated)
    }
    
    public func hideSideView(animated: Bool) {
        updateSideView(sideViewWidth, animated: animated)
    }
    
    public var sideViewVisible: Bool {
      get {
        return sideViewRightConstraint.constant == 0
      }
    }
    
    //MARK: Private
    
    private var mainViewContainer: UIView!
    private var sideViewContainer: UIView!
    
    private var sideViewWidthConstraint : NSLayoutConstraint!
    private var sideViewRightConstraint : NSLayoutConstraint!
    
    private var toggleAnimationInProgress = false
    
    private func updateSideView(_ constant: CGFloat, animated: Bool) {
        if isSideViewControllerShownInSideViewContainer() {
            if toggleAnimationInProgress == false {
                sideViewRightConstraint.constant = constant
                view.setNeedsUpdateConstraints()
                
                if animated {
                    toggleAnimationInProgress = true
                    
                    UIView.animate(withDuration: 0.5, animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        }, completion: { [weak self] finished in
                            self?.toggleAnimationInProgress = false
                        })
                }
            }
        } else {
            if let sideViewController = sideViewController {
                if constant == 0 {
                    show(sideViewController, sender: self)
                } else {
                    hideViewController(sideViewController, animated: animated)
                }
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerViews()
        
        if let mainViewController = mainViewController {
            addViewControllerToContainer(mainViewController, container: mainViewContainer)
        }
        
        if let sideViewController = sideViewController, isRegularSize() {
            addViewControllerToContainer(sideViewController, container: sideViewContainer)
        }
    }
    
    private func addViewControllerToContainer(_ viewController: UIViewController, container: UIView) {
        addChild(viewController)
        let subview = viewController.view!
        subview.translatesAutoresizingMaskIntoConstraints = false
        viewController.beginAppearanceTransition(true, animated: false)
        container.addSubview(subview)
        
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: [], metrics: nil, views: ["subview" : subview])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: [], metrics: nil, views: ["subview" : subview])
        container.addConstraints(hConstraints)
        container.addConstraints(vConstraints)
        
        viewController.endAppearanceTransition()
        viewController.didMove(toParent: self)
    }

    private func removeViewControllerFromContainer(viewController: UIViewController, container: UIView) {
        viewController.willMove(toParent: nil)
        viewController.beginAppearanceTransition(false, animated: false)
        viewController.view.removeConstraints()
        viewController.view.removeFromSuperview()
        viewController.view.translatesAutoresizingMaskIntoConstraints = true
        viewController.endAppearanceTransition()
        viewController.removeFromParent()
    }
    
    private func setupContainerViews() {
        mainViewContainer = UIView()
        mainViewContainer.translatesAutoresizingMaskIntoConstraints = false
        mainViewContainer.backgroundColor = UIColor.blue
        view.addSubview(mainViewContainer)
        let mHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainView]|", options: [], metrics: nil, views: ["mainView" : mainViewContainer!])
        let mVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainView]|", options: [], metrics: nil, views: ["mainView" : mainViewContainer!])
        view.addConstraints(mHConstraints)
        view.addConstraints(mVConstraints)
        
        sideViewContainer = UIView()
        sideViewContainer.translatesAutoresizingMaskIntoConstraints = false
        sideViewContainer.backgroundColor = UIColor.red
        view.addSubview(sideViewContainer)
        
        sideViewWidthConstraint = NSLayoutConstraint(item: sideViewContainer!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: sideViewWidth)
        sideViewRightConstraint = NSLayoutConstraint(item: sideViewContainer!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: sideViewWidth)
        let sVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[sideView]|", options: [], metrics: nil, views: ["sideView" : sideViewContainer!])
        view.addConstraint(sideViewWidthConstraint)
        view.addConstraint(sideViewRightConstraint)
        view.addConstraints(sVConstraints)
    }
    
    
    private func isRegularSize(traitCollection : UITraitCollection = UIScreen.main.traitCollection) -> Bool {
        return traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular
    }
    
    private func isSideViewControllerShownInSideViewContainer() -> Bool {
        if let superview = sideViewController?.view.superview, superview.isEqual(sideViewContainer) {
            return true
        }
        return false
    }
    
    private func hideViewController(_ viewController: UIViewController, animated: Bool) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: animated)
        } else {
            viewController.dismiss(animated: animated, completion: nil)
        }
    }
    
    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if let sideViewController = sideViewController {
            hideSideView(animated: false)
            if isRegularSize(traitCollection: newCollection) {
                removeViewControllerFromContainer(viewController: sideViewController, container: sideViewContainer)
                addViewControllerToContainer(sideViewController, container: sideViewContainer)
            } else {
                removeViewControllerFromContainer(viewController: sideViewController, container: sideViewContainer)
            }
        }
    }
}

private extension UIView {
    func removeConstraints() {
        var list = [NSLayoutConstraint]()
        if let constraints = superview?.constraints {
            for c in constraints {
                if c.firstItem as? UIView == self || c.secondItem as? UIView == self {
                    list.append(c)
                }
            }
            self.superview!.removeConstraints(list)
        }
    }
}
