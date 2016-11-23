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
    
    //    override func prefersStatusBarHidden() -> Bool {
    //        return true
    //    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
//    static let w = UIScreen.mainScreen().bounds.size.width
//    static let h = UIScreen.mainScreen().bounds.size.height
    
//    static let bH:CGFloat = 35
//    
//    static let lW:CGFloat = 50
//    static let lH = bH
//    
//    static let barY = UIApplication.sharedApplication().statusBarFrame.size.height
//    static let barH = bH
//    
//    static let cY = barY + barH
//    static let cH = h - cY
    
    let minOutLenght:CGFloat =  UIScreen.mainScreen().bounds.size.height
    
    static let photoFrame = CGRectMake(0, 55, SCREEN_W, SCREEN_H - 55)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height))
        statusBarView.backgroundColor = UIColor.blackColor()
        
//        setNeedsStatusBarAppearanceUpdate()
        
        view.addSubview(statusBarView)
        

        
       
        
        let naviBarView = UIView(frame: CGRectMake(0, STATUS_H, SCREEN_W, 35))
        naviBarView.backgroundColor = UIColor.blackColor()
        
        let b = UIButton(frame: CGRectMake(0, 0, 44, 44))
        
        b.setImage(UIImage(named: "btn_back"), forState: UIControlState.Normal)
        b.setImage(UIImage(named: "btn_back"), forState: UIControlState.Selected)
        b.addTarget(self,action: #selector(PhotoBrowsingController.back), forControlEvents: .TouchUpInside)
        
        l = UILabel(frame: CGRectMake(0, 0, 50, 35))
        l.center.x = naviBarView.center.x
        l.textColor = UIColor.whiteColor()
        
        
        
        
//        naviBarView.addSubview(b)
        naviBarView.addSubview(l)
        
        view.addSubview(naviBarView)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSizeMake(SCREEN_W, SCREEN_H - 55)
        flowLayout.scrollDirection = .Horizontal
        
        collectionView = UICollectionView(frame: PhotoBrowsingController.photoFrame, collectionViewLayout: flowLayout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.pagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        view.addSubview(collectionView)
        
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: startPage, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
        setLable()
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(animated: Bool) {
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        // Configure the cell
        if cell.contentView.viewWithTag(100) != nil {
            cell.contentView.viewWithTag(100)!.removeFromSuperview()
        }
        
        if cell.contentView.viewWithTag(101) != nil {
            cell.contentView.viewWithTag(101)!.removeFromSuperview()
        }
        
        let imageView = PhotoBrowsingImageView(frame: cell.contentView.bounds)
        imageView.tag = 100
        imageView.userInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.clipsToBounds = true
        
        let pinchGestureRecognizer =  UIPinchGestureRecognizer(target: self,
            action: #selector(PhotoBrowsingController.handlePinches(_:)))
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        let twoTapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(PhotoBrowsingController.handleTaps(_:)))
        twoTapGestureRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(twoTapGestureRecognizer)
        
        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(PhotoBrowsingController.handleTap(_:)))
        oneTapGestureRecognizer.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(oneTapGestureRecognizer)
        oneTapGestureRecognizer.requireGestureRecognizerToFail(twoTapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PhotoBrowsingController.handleLongPressGestures(_:)))
        
        longPressGestureRecognizer.numberOfTouchesRequired = 1
        
        /* Maximum 100 points of movement allowed before the gesture
        is recognized */
        longPressGestureRecognizer.allowableMovement = 25
        
        /* The user must press 2 fingers (numberOfTouchesRequired) for
        at least 1 second for the gesture to be recognized */
        longPressGestureRecognizer.minimumPressDuration = 1
        imageView.addGestureRecognizer(longPressGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
            action: #selector(PhotoBrowsingController.handleImagePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        imageView.addGestureRecognizer(panGestureRecognizer)
        imageView.panGestureRecognizer = panGestureRecognizer
        imageView.panGestureRecognizer.enabled = false
        
        imageView.cell = cell
        
        cell.contentView.addSubview(imageView)

        let imageUrl = images[indexPath.row].changeImageUrlToUsIp()
        print("imageUrl: \(imageUrl)")
        imageView.sd_setImageWithURL(NSURL(string: imageUrl))

        return cell
    }
    
    
    func handleLongPressGestures(sender: UILongPressGestureRecognizer){
        let controller = UIAlertController(title: nil,message: nil,preferredStyle: .ActionSheet)
        let action = UIAlertAction(title: "保存图片", style: UIAlertActionStyle.Default, handler: {(paramAction:UIAlertAction!) in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
                    let imgData = UIImageJPEGRepresentation((sender.view! as! UIImageView).image!, 1)
                    let img = UIImage(data: imgData!)!
                    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                        _ = PHAssetChangeRequest.creationRequestForAssetFromImage(img)
                        
                        },
                        completionHandler: { success, error in
                            if success == true{
                                MessagePrompter.prompt("保存成功", vc: self)
                            }
                        }
                    )
                    
                }
            })
        controller.addAction(action)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {(paramAction:UIAlertAction!) in
                })
        controller.addAction(cancelAction)
        
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func handlePinches(sender: UIPinchGestureRecognizer){
        let imageView = (sender.view! as! UIImageView)
        
        if sender.state != .Ended && sender.state != .Failed{
            
            imageView.transform = CGAffineTransformScale((imageView as! PhotoBrowsingImageView).lastTransform , sender.scale, sender.scale)
            
            if imageView.transform.a < 0.5 {
                imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity , 0.5, 0.5)
            }

            
            
            if imageView.transform.a >= 3 {
                imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity , 3, 3)
            }
        }else{
           
            
            if imageView.transform.a < CGAffineTransformIdentity.a || imageView.frame.origin.y > h - minOutLenght || imageView.frame.maxY < minOutLenght
            || imageView.frame.origin.x > 0 || imageView.frame.maxX < w{
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    imageView.transform = CGAffineTransformIdentity
                    imageView.center = imageView.superview!.center
                    
                })
                movingState = .Still
            }else if imageView.transform.a > 2.5 {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity , 2.5, 2.5)
                })
            }
            
             (imageView as! PhotoBrowsingImageView).lastTransform = imageView.transform
            
            if !CGAffineTransformIsIdentity(imageView.transform){
                (imageView as! PhotoBrowsingImageView).panGestureRecognizer.enabled = true
                (imageView as! PhotoBrowsingImageView).panGestureRecognizer.delegate = self
                
                movingState = .Moving
                
                indexP = collectionView.indexPathForCell((imageView as! PhotoBrowsingImageView).cell)!
            }
            
            
            
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == collectionView.panGestureRecognizer{
            return true
        }else{
            return false
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        print("shouldReceiveTouch")
        return true
    }
    
    func dismiss(){
//        print("\nbutton click")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleTap(sender: UITapGestureRecognizer){
        
//        print("one tap")
//        self.dismissViewControllerAnimated(true, completion: nil)
        back()
    }
    
    func handleTaps(sender: UITapGestureRecognizer){
        let imageView = (sender.view! as! UIImageView)
        if CGAffineTransformIsIdentity(imageView.transform){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            imageView.transform = CGAffineTransformScale(CGAffineTransformIdentity , 2, 2)
            })
        
        (imageView as! PhotoBrowsingImageView).panGestureRecognizer.enabled = true
        (imageView as! PhotoBrowsingImageView).panGestureRecognizer.delegate = self
        
        movingState = .Moving
        
        
        indexP = collectionView.indexPathForCell((imageView as! PhotoBrowsingImageView).cell)!
    }else{
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            imageView.transform = CGAffineTransformIdentity
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
        if sender.state != .Ended && sender.state != .Failed{
            
//            print("handleImagePanGesture")
        
        let translation = sender.translationInView(sender.view!.superview!)
        
        
        
        
        if movingState == .Moving {
            
            var center = sender.view!.center
            
            center.y += translation.y
            center.x += translation.x
            
            
            sender.view!.center = center
            
            if sender.view!.frame.origin.y > h - minOutLenght {
                sender.view!.frame.origin.y = h - minOutLenght
            }
            
            if sender.view!.frame.origin.y < minOutLenght - sender.view!.frame.size.height  {
                sender.view!.frame.origin.y = minOutLenght - sender.view!.frame.size.height
            }
    
        }
        
        
        sender.setTranslation(CGPointZero, inView: sender.view!.superview!)
        
        if sender.view!.frame.origin.x > 0 {
            sender.view!.frame.origin.x = 0
            movingState = .Left
            
        }
        
        if sender.view!.frame.origin.x < w - sender.view!.frame.size.width {
                sender.view!.frame.origin.x = w - sender.view!.frame.size.width
                movingState = .Right
                
        }
        
        
        
        
        
        
    }else {
//        print("fail")
        }
        
        
    }
    
    func setLable(){
            var pageNumber = Int(self.collectionView.contentOffset.x/self.collectionView.frame.size.width + 1)
            if pageNumber == 0{
                pageNumber = 1
            }
            l.text = "\(pageNumber)/\(images.count)"
    }
    

    var indexP = NSIndexPath(forRow: 3, inSection: 0)
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
//                print("scrollViewDidScroll")
        
        setLable()
        
        if collectionView.contentOffset.x >= CGFloat(indexP.row + 1) * w || collectionView.contentOffset.x <= CGFloat(indexP.row - 1) * w{
            movingState = .Still
        }
        
        if movingState == .Moving {
            collectionView.scrollToItemAtIndexPath(indexP, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        }
        
        if collectionView.contentOffset.x >= CGFloat(indexP.row) * w && movingState == .Left{
            collectionView.scrollToItemAtIndexPath(indexP, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
            movingState = .Moving
        }
        
        if collectionView.contentOffset.x <= CGFloat(indexP.row) * w && movingState == .Right{
                collectionView.scrollToItemAtIndexPath(indexP, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                movingState = .Moving
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
            //        print("scrollViewWillBeginDragging")
    }
    
    var transView:UIView?
    
    var desFrame:CGRect!
    
    var navigationOperation: UINavigationControllerOperation?
    
    // UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        navigationOperation = operation
        if operation == .Push{
            if toVC is PhotoBrowsingController{
                if transView != nil {
                    return self
                }else{
                    return nil
                }
                
            }else{
                return nil
            }
        }else if operation == .Pop {
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
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        
        
        
        //        var detailVC: DetailViewController!
        //        var fromView: UIView!
        //        var alpha: CGFloat = 1.0
        //        var destTransform: CGAffineTransform!
        //
        //        var snapshotImageView: UIView!
        
        
        
        if navigationOperation == UINavigationControllerOperation.Push {
            
            containerView.addSubview(fromViewController.view!)
            containerView.addSubview(toViewController.view!)
            toViewController.view.alpha = 0
            containerView.addSubview(transView!)
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.transView!.frame = self.desFrame
                }, completion: {(finished: Bool) -> Void in
                    toViewController.view.alpha = 1
                    self.transView!.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
            
        } else if navigationOperation == UINavigationControllerOperation.Pop {
            //            containerView.addSubview(fromViewController.view!)
            containerView.addSubview(toViewController.view!)
            
            containerView.addSubview(transView!)
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                self.transView!.frame = self.desFrame
                //            fromViewController.view!.alpha = 0
                
                }, completion: {(finished: Bool) -> Void in
                    self.transView!.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
            
        }
    }
    
    func back() {
        if navigationController != nil {
            let cell = collectionView.visibleCells().first!
            if let image = (cell.contentView.viewWithTag(100) as? UIImageView)?.image{
                let frame = LifeUtils.aspectFitFrameForFrame(PhotoBrowsingController.photoFrame, size: image.size)
                let iv = UIImageView(frame: frame)
                iv.contentMode = .ScaleAspectFill
                iv.image = image
                iv.clipsToBounds = true
                let index = collectionView.indexPathForCell(cell)
                let imageView = imageViews[index!.row].value
                let window = UIApplication.sharedApplication().keyWindow
                desFrame = imageView.convertRect(imageView.bounds, toView: window)
//                if desFrame.maxY - 64 > 0 && desFrame.origin.y < SCREEN_H{
//                   transView = iv
//                }else{
//                    transView = nil
//                }
                transView = iv
                if desFrame.maxY - 64 > 0 && desFrame.origin.y < SCREEN_H{
                    
                }else{
                    desFrame = CGRect(x: SCREEN_W/2, y: SCREEN_H/2, width: 0, height: 0)
                }
            }else{
                transView = nil
            }
            
            navigationController?.popViewControllerAnimated(true)
        }else{
            dismissViewControllerAnimated(false, completion: nil)
            
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
        var lastTransform:CGAffineTransform = CGAffineTransformIdentity
        var panGestureRecognizer:UIPanGestureRecognizer!
        var cell:UICollectionViewCell!

}

class PhotoBrowsingCell{
    
}
