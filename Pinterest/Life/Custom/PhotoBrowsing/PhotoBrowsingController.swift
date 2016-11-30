//
//  PhotoBrowsingController.swift
//  finding
//
//  Created by bob song on 15/12/1.
//  Copyright © 2015年 zhangli. All rights reserved.
//

import UIKit
import Photos

class PhotoBrowsingController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning  {
    var images:[String] = []
    let cellReuseIdentifier = "PhotoBrowsingCollectionViewCell"
    var collectionView:UICollectionView!
    var l:UILabel!
    var startPage = 0
    var imageViews:[WeakBox<UIImageView>] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let minOutLenght:CGFloat =  UIScreen.main.bounds.size.height
    
    static let photoFrame = CGRect(x:0, y:55, width:SCREEN_W, height:SCREEN_H - 55)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let naviBarView = UIView(frame: CGRect(x:0, y:STATUS_H, width:SCREEN_W, height:35))
        naviBarView.backgroundColor = UIColor.black
        
        let b = UIButton(frame: CGRect(x:0, y:0, width:44, height:44))
        
        b.setImage(UIImage(named: "btn_back"), for: UIControlState.normal)
        b.setImage(UIImage(named: "btn_back"), for: UIControlState.selected)
        b.addTarget(self,action: #selector(PhotoBrowsingController.back), for: .touchUpInside)
        
        l = UILabel(frame: CGRect(x:0, y:0, width:50, height:35))
        l.center.x = naviBarView.center.x
        l.textColor = UIColor.white
        l.textAlignment = .center
        
        
        naviBarView.addSubview(l)
        
        view.addSubview(naviBarView)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width:SCREEN_W, height:SCREEN_H - 55)
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: PhotoBrowsingController.photoFrame, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.addSubview(collectionView)
        
        collectionView.scrollToItem(at: IndexPath(row: startPage, section: 0), at: .left, animated: false)
        
        setLable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        // Configure the cell
        if cell.contentView.viewWithTag(100) != nil {
            cell.contentView.viewWithTag(100)!.removeFromSuperview()
        }
        
        if cell.contentView.viewWithTag(101) != nil {
            cell.contentView.viewWithTag(101)!.removeFromSuperview()
        }
        
        let imageView = PhotoBrowsingImageView(frame: cell.contentView.bounds)
        imageView.tag = 100
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        let pinchGestureRecognizer =  UIPinchGestureRecognizer(target: self,
                                                               action: #selector(self.handlePinches))
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        let twoTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(self.handleTaps))
        twoTapGestureRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(twoTapGestureRecognizer)
        
        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(self.handleTap))
        oneTapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(oneTapGestureRecognizer)
        oneTapGestureRecognizer.require(toFail: twoTapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressGestures))
        
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        
        /* Maximum 100 points of movement allowed before the gesture
         is recognized */
        longPressGestureRecognizer.allowableMovement = 25
        
        /* The user must press 2 fingers (numberOfTouchesRequired) for
         at least 1 second for the gesture to be recognized */
        longPressGestureRecognizer.minimumPressDuration = 1
        imageView.addGestureRecognizer(longPressGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handleImagePanGesture))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        imageView.addGestureRecognizer(panGestureRecognizer)
        imageView.panGestureRecognizer = panGestureRecognizer
        imageView.panGestureRecognizer.isEnabled = false
        
        imageView.cell = cell
        
        cell.contentView.addSubview(imageView)
        
        let imageUrl = images[indexPath.row]
        print("imageUrl: \(imageUrl)")
        imageView.setImageForURLString(str: imageUrl)
        
        return cell
    }
    
    func handleLongPressGestures(sender: UILongPressGestureRecognizer){
        if self.presentedViewController != nil {
            return
        }
        let controller = UIAlertController(title: nil,message: nil,preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "保存图片", style: UIAlertActionStyle.default, handler: {(paramAction:UIAlertAction!) in
            DispatchQueue.global().async(execute: {
                let imgData = UIImageJPEGRepresentation((sender.view! as! UIImageView).image!, 1)
                let img = UIImage(data: imgData!)!
                PHPhotoLibrary.shared().performChanges({
                    _ = PHAssetChangeRequest.creationRequestForAsset(from: img)
                },
               completionHandler: { success, error in
                    if success == true{
                        print("保存成功")
                    }
                })
            })
        })
        controller.addAction(action)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(paramAction:UIAlertAction!) in
        })
        controller.addAction(cancelAction)
        
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func handlePinches(sender: UIPinchGestureRecognizer){
        let imageView = (sender.view! as! UIImageView)
        
        if sender.state != .ended && sender.state != .failed{
            
            imageView.transform = (imageView as! PhotoBrowsingImageView).lastTransform.scaledBy(x: sender.scale, y: sender.scale)
            
            if imageView.transform.a < 0.5 {
                imageView.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            }
            
            
            
            if imageView.transform.a >= 3 {
                imageView.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)
            }
        }else{
            
            
            if imageView.transform.a < CGAffineTransform.identity.a || imageView.frame.origin.y > SCREEN_H - minOutLenght || imageView.frame.maxY < minOutLenght
                || imageView.frame.origin.x > 0 || imageView.frame.maxX < SCREEN_W{
                
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    imageView.transform = CGAffineTransform.identity
                    imageView.center = imageView.superview!.center
                    
                })
                movingState = .Still
            }else if imageView.transform.a > 2.5 {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    imageView.transform = CGAffineTransform.identity.scaledBy(x: 2.5, y: 2.5)
                })
            }
            
            (imageView as! PhotoBrowsingImageView).lastTransform = imageView.transform
            
            if !imageView.transform.isIdentity{
                (imageView as! PhotoBrowsingImageView).panGestureRecognizer.isEnabled = true
                (imageView as! PhotoBrowsingImageView).panGestureRecognizer.delegate = self
                
                movingState = .Moving
                
                indexPathForAugmented = collectionView.indexPath(for: (imageView as! PhotoBrowsingImageView).cell)!
            }
            
            
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == collectionView.panGestureRecognizer{
            return true
        }else{
            return false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //        print("shouldReceiveTouch")
        return true
    }
    
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleTap(sender: UITapGestureRecognizer){
        
        //        print("one tap")
        //        self.dismissViewControllerAnimated(true, completion: nil)
        back()
    }
    
    func handleTaps(sender: UITapGestureRecognizer){
        let imageView = (sender.view! as! UIImageView)
        if imageView.transform.isIdentity{
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                imageView.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
            })
            
            (imageView as! PhotoBrowsingImageView).panGestureRecognizer.isEnabled = true
            (imageView as! PhotoBrowsingImageView).panGestureRecognizer.delegate = self
            
            movingState = .Moving
            
            
            indexPathForAugmented = collectionView.indexPath(for: (imageView as! PhotoBrowsingImageView).cell)!
        }else{
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                imageView.transform = CGAffineTransform.identity
                imageView.center = imageView.superview!.center
            })
            
            movingState = .Still
        }
        (imageView as! PhotoBrowsingImageView).lastTransform = imageView.transform
        
    }
    
    enum ImageMovingState: Int  {
        case Left=0, Right, Moving, Still
    }
    
    var movingState = ImageMovingState.Still
    
    
    
    func handleImagePanGesture(sender: UIPanGestureRecognizer){
        if sender.state != .ended && sender.state != .failed{
            
            //            print("handleImagePanGesture")
            
            let translation = sender.translation(in: sender.view!.superview!)
            
            
            
            
            if movingState == .Moving {
                
                var center = sender.view!.center
                
                center.y += translation.y
                center.x += translation.x
                
                
                sender.view!.center = center
                
                if sender.view!.frame.origin.y > SCREEN_H - minOutLenght {
                    sender.view!.frame.origin.y = SCREEN_H - minOutLenght
                }
                
                if sender.view!.frame.origin.y < minOutLenght - sender.view!.frame.size.height  {
                    sender.view!.frame.origin.y = minOutLenght - sender.view!.frame.size.height
                }
                
            }
            
            
            sender.setTranslation(CGPoint.zero, in: sender.view!.superview!)
            
            if sender.view!.frame.origin.x > 0 {
                sender.view!.frame.origin.x = 0
                movingState = .Left
                
            }
            
            if sender.view!.frame.origin.x < SCREEN_W - sender.view!.frame.size.width {
                sender.view!.frame.origin.x = SCREEN_W - sender.view!.frame.size.width
                movingState = .Right
                
            }
            
        }else {

        }
        
        
    }
    
    func setLable(){
        var pageNumber = Int(self.collectionView.contentOffset.x/self.collectionView.frame.size.width + 1)
        if pageNumber == 0{
            pageNumber = 1
        }
        l.text = "\(pageNumber)/\(images.count)"
    }
    
    
    var indexPathForAugmented = IndexPath(row: 3, section: 0)
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //                print("scrollViewDidScroll")
        
        setLable()
        
        if collectionView.contentOffset.x >= CGFloat(indexPathForAugmented.row + 1) * SCREEN_W || collectionView.contentOffset.x <= CGFloat(indexPathForAugmented.row - 1) * SCREEN_W{
            movingState = .Still
            if let cell = collectionView.cellForItem(at: indexPathForAugmented){
                if let v = cell.contentView.viewWithTag(100){
                    if v.transform != .identity{
                        v.transform = CGAffineTransform.identity
                        v.center = v.superview!.center
                    }
                }
            }
            
        }
        
        if movingState == .Moving {
            collectionView.scrollToItem(at: indexPathForAugmented, at: UICollectionViewScrollPosition.left, animated: false)
        }
        
        if collectionView.contentOffset.x >= CGFloat(indexPathForAugmented.row) * SCREEN_W && movingState == .Left{
            collectionView.scrollToItem(at: indexPathForAugmented, at: UICollectionViewScrollPosition.left, animated: false)
            movingState = .Moving
        }
        
        if collectionView.contentOffset.x <= CGFloat(indexPathForAugmented.row) * SCREEN_W && movingState == .Right{
            collectionView.scrollToItem(at: indexPathForAugmented, at: UICollectionViewScrollPosition.left, animated: false)
            movingState = .Moving
        }
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //        print("scrollViewWillBeginDragging")
    }
    
    var transView:UIView?
    
    var desFrame:CGRect!
    
    var navigationOperation: UINavigationControllerOperation?
    
    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationOperation = operation
        if operation == .push{
            if toVC is PhotoBrowsingController{
                if transView != nil {
                    return self
                }else{
                    return nil
                }
                
            }else{
                return nil
            }
        }else if operation == .pop {
            if fromVC is PhotoBrowsingController{
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
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        if navigationOperation == UINavigationControllerOperation.push {
            
            containerView.addSubview(fromViewController.view!)
            containerView.addSubview(toViewController.view!)
            toViewController.view.alpha = 0
            containerView.addSubview(transView!)
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.transView!.frame = self.desFrame
            }, completion: {(finished: Bool) -> Void in
                toViewController.view.alpha = 1
                self.transView!.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        } else if navigationOperation == UINavigationControllerOperation.pop {
            //            containerView.addSubview(fromViewController.view!)
            containerView.addSubview(toViewController.view!)
            
            containerView.addSubview(transView!)
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                self.transView!.frame = self.desFrame
                //            fromViewController.view!.alpha = 0
                
            }, completion: {(finished: Bool) -> Void in
                self.transView!.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        }
    }
    
    func back() {
        if navigationController != nil {
            let cell = collectionView.visibleCells.first!
            if let image = (cell.contentView.viewWithTag(100) as? UIImageView)?.image{
                let frame = LifeUtils.aspectFitFrameForFrame(PhotoBrowsingController.photoFrame, size: image.size)
                let iv = UIImageView(frame: frame)
                iv.contentMode = .scaleAspectFill
                iv.image = image
                iv.clipsToBounds = true
                let index = collectionView.indexPath(for: cell)
                let imageView = imageViews[index!.row].value
                let window = UIApplication.shared.keyWindow
                desFrame = imageView?.convert((imageView?.bounds)!, to: window)
                transView = iv
                if desFrame.maxY - 64 > 0 && desFrame.origin.y < SCREEN_H{
                    
                }else{
                    desFrame = CGRect(x: SCREEN_W/2, y: SCREEN_H/2, width: 0, height: 0)
                }
            }else{
                transView = nil
            }
            
            _ = navigationController?.popViewController(animated: true)
        }else{
            dismiss(animated: false, completion: nil)
        }
    }
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}

class PhotoBrowsingImageView:UIImageView{
    var lastTransform:CGAffineTransform = CGAffineTransform.identity
    var panGestureRecognizer:UIPanGestureRecognizer!
    var cell:UICollectionViewCell!
}

class PhotoBrowsingCell{
    
}
