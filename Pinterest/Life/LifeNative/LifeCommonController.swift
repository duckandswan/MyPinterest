//
//  LifeCommonController.swift
//  finding
//
//  Created by bob song on 16/3/17.
//  Copyright © 2016年 zhangli. All rights reserved.
//

import UIKit
//父Controller
class LifeCommonController:UIViewController, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate {
    
    var lifeCollectionView:MyRefreshCollectionView!

    var mainLifeData:LifeData = LifeData()
    
    var lifeDatas:[LifeData] = []
    
    weak var lifeInner:LifeInnerController?
    
    func frameForIndex(_ index:Int)->CGRect{
        let iH = mainLifeData.lifeModels[index].imagesH
        let indexPath = IndexPath(row: index, section: 1)
        
        return frameForCollectionView(indexPath, iH: iH)
    }
    
    func frameForCollectionView(_ indexPath:IndexPath,iH:CGFloat)->CGRect{
        let window = UIApplication.shared.keyWindow!
        let layoutAttributes = lifeCollectionView.layoutAttributesForItem(at: indexPath)!
        var newFrame = lifeCollectionView.convert(layoutAttributes.frame, to: window)
        
//        if newFrame.origin.y + iH < 64 || newFrame.origin.y > UIScreen.main.bounds.size.height - 70{
//            lifeCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: false)
//            newFrame = lifeCollectionView.convert(layoutAttributes.frame, to: window)
//        }
        lifeCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: false)
        newFrame = lifeCollectionView.convert(layoutAttributes.frame, to: window)
        
        newFrame.size.height = iH
        return newFrame
    }
    
    func footerRefreshData(){
        
    }
    
    var transView:UIView?
    
    var desFrame:CGRect!
    
    func presentLifeInner(_ cell:CommonCollectionViewCell,index:Int){
        let lifeModel = self.mainLifeData.lifeModels[index]

        let window = UIApplication.shared.keyWindow
        
        let frame = cell.contentView.convert(cell.iView.frame, to: window)
        
        transView = cell.iView.snapshotView(afterScreenUpdates: true)
        transView!.frame = frame
        
        let imagesY = lifeModel.bigImageY
        let bigImagesH = lifeModel.bigImagesH
        desFrame = CGRect(x: LifeConstant.bigMargin, y: 64 + imagesY, width: LifeConstant.bigInnerWidth, height: bigImagesH)
        
        let lifeInnerController = LifeInnerController()
        self.lifeInner = lifeInnerController
        self.lifeInner!.delegate = self
        self.lifeInner!.currentIndex = index
        
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(lifeInner!, animated: true)
    
    
    }
    
    var navigationOperation: UINavigationControllerOperation?
    
    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationOperation = operation
        if operation == .push{
            if toVC is LifeInnerController{
                return self
            }else{
                return nil
            }
        }else if operation == .pop {
            if fromVC is LifeInnerController{
                if transView != nil {
                    return self
                }else{
                    return nil
                }
            }else{
                return nil
            }
        }else{
            return nil
        }
        
    }
    
    //UIViewControllerTransitioningDelegate
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.view!
        let fromView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.view!
        
        
        if navigationOperation == UINavigationControllerOperation.push {
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
            toView.alpha = 0.0
            containerView.addSubview(transView!)
            UIView.animate(withDuration: 0.35, animations: {() -> Void in
                self.transView!.frame = self.desFrame
                toView.alpha = 1
                
                }, completion: {(finished: Bool) -> Void in
                    self.transView!.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        } else if navigationOperation == UINavigationControllerOperation.pop {
            containerView.addSubview(toView)
            
            containerView.addSubview(transView!)
            UIView.animate(withDuration: 0.35, animations: {() -> Void in
                self.transView!.frame = self.desFrame
                }, completion: {(finished: Bool) -> Void in
                    self.transView!.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
    }

    
}
