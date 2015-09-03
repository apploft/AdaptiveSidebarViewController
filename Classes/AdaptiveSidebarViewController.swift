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

class AdaptiveSidebarViewController : UIViewController {
    
    //MARK: Public

    var mainViewController : UIViewController?
    var sideViewController : UIViewController?
    var sideViewWidth : CGFloat = 320 {
        didSet {
            sideViewWidthConstraint.constant = sideViewWidth
        }
    }
    
    func showSideView(animated: Bool) {
        updateSideView(0, animated: animated)
    }
    
    func hideSideView(animated: Bool) {
        updateSideView(sideViewWidth, animated: animated)
    }
    
    func sideViewVisible() -> Bool {
        return sideViewRightConstraint.constant == 0
    }
    
    //MARK: Private
    
    private var mainViewContainer: UIView!
    private var sideViewContainer: UIView!
    
    private var sideViewWidthConstraint : NSLayoutConstraint!
    private var sideViewRightConstraint : NSLayoutConstraint!
    
    private var toggleAnimationInProgress = false
    
    private func updateSideView(constant: CGFloat, animated: Bool) {
        if isSideViewControllerShownInSideViewContainer() {
            if toggleAnimationInProgress == false {
                sideViewRightConstraint.constant = constant
                view.setNeedsUpdateConstraints()
                
                if animated {
                    toggleAnimationInProgress = true
                    
                    UIView.animateWithDuration(0.5, animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        }, completion: { [weak self] finished in
                            self?.toggleAnimationInProgress = false
                        })
                }
            }
        } else {
            if let sideViewController = sideViewController {
                if constant == 0 {
                    showViewController(sideViewController, sender: self)
                } else {
                    hideViewController(sideViewController, animated: animated)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerViews()
        
        if let mainViewController = mainViewController {
            addViewControllerToContainer(mainViewController, container: mainViewContainer)
        }
        
        if let sideViewController = sideViewController where isRegularSize() {
            addViewControllerToContainer(sideViewController, container: sideViewContainer)
        }
    }
    
    private func addViewControllerToContainer(viewController: UIViewController, container: UIView) {
        addChildViewController(viewController)
        let subview = viewController.view
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        viewController.beginAppearanceTransition(true, animated: false)
        container.addSubview(subview)
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[subview]|", options: nil, metrics: nil, views: ["subview" : subview])
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|", options: nil, metrics: nil, views: ["subview" : subview])
        container.addConstraints(hConstraints)
        container.addConstraints(vConstraints)
        
        viewController.endAppearanceTransition()
        viewController.didMoveToParentViewController(self)
    }

    private func removeViewControllerFromContainer(viewController: UIViewController, container: UIView) {
        viewController.willMoveToParentViewController(nil)
        viewController.beginAppearanceTransition(false, animated: false)
        viewController.view.removeConstraints()
        viewController.view.removeFromSuperview()
        viewController.view.setTranslatesAutoresizingMaskIntoConstraints(true)
        viewController.endAppearanceTransition()
        viewController.removeFromParentViewController()
    }
    
    private func setupContainerViews() {
        mainViewContainer = UIView()
        mainViewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainViewContainer.backgroundColor = UIColor.blueColor()
        view.addSubview(mainViewContainer)
        let mHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainView]|", options: nil, metrics: nil, views: ["mainView" : mainViewContainer])
        let mVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainView]|", options: nil, metrics: nil, views: ["mainView" : mainViewContainer])
        view.addConstraints(mHConstraints)
        view.addConstraints(mVConstraints)
        
        sideViewContainer = UIView()
        sideViewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        sideViewContainer.backgroundColor = UIColor.redColor()
        view.addSubview(sideViewContainer)
        
        sideViewWidthConstraint = NSLayoutConstraint(item: sideViewContainer, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sideViewWidth)
        sideViewRightConstraint = NSLayoutConstraint(item: sideViewContainer, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: sideViewWidth)
        let sVConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[sideView]|", options: nil, metrics: nil, views: ["sideView" : sideViewContainer])
        view.addConstraint(sideViewWidthConstraint)
        view.addConstraint(sideViewRightConstraint)
        view.addConstraints(sVConstraints)
    }
    
    
    private func isRegularSize(traitCollection : UITraitCollection = UIScreen.mainScreen().traitCollection) -> Bool {
        return traitCollection.horizontalSizeClass == .Regular && traitCollection.verticalSizeClass == .Regular
    }
    
    private func isSideViewControllerShownInSideViewContainer() -> Bool {
        if let superview = sideViewController?.view.superview where superview.isEqual(sideViewContainer) {
            return true
        }
        return false
    }
    
    private func hideViewController(viewController: UIViewController, animated: Bool) {
        if let navigationController = navigationController {
            navigationController.popViewControllerAnimated(animated)
        } else {
            viewController.dismissViewControllerAnimated(animated, completion: nil)
        }
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        if let sideViewController = sideViewController {
            hideSideView(false)
            if isRegularSize(traitCollection: newCollection) {
                removeViewControllerFromContainer(sideViewController, container: sideViewContainer)
                addViewControllerToContainer(sideViewController, container: sideViewContainer)
            } else {
                removeViewControllerFromContainer(sideViewController, container: sideViewContainer)
            }
        }
    }
}

private extension UIView {
    func removeConstraints() {
        var list = [AnyObject]()
        if let constraints = superview?.constraints() {
            for c in constraints {
                if c.firstItem as? UIView == self || c.secondItem as? UIView == self {
                    list.append(c)
                }
            }
            self.superview!.removeConstraints(list)
        }
    }
}
