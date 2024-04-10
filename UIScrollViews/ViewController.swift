//
//  ViewController.swift
//  UIScrollViews
//
//  Created by Palliboina on 05/04/24.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var stackView: UIStackView!
    //var imageView:UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var mainScroll:UIScrollView!
    var page:Int = 0
    var imageViews:[UIImageView] = []
    var rotating:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let images = ["family","teddy","mobile"]
        
        pageControl.numberOfPages = images.count
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .blue
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        /*stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true*/
        
        let scrollWidth = stackView.frame.size.width
        let scrollHeight = stackView.frame.size.height
        
        /*imageView = UIImageView(image: UIImage(named: "mobile"))
        let imgWidth = imageView.frame.size.width
        let imgHeight = imageView.frame.size.height*/
        
        mainScroll = UIScrollView(frame: .zero)
        ///mainScroll.contentSize = CGSize(width: scrollWidth * CGFloat(images.count), height: scrollHeight)
        //to show with status bar occupied
        mainScroll.contentInsetAdjustmentBehavior = .never
        mainScroll.isPagingEnabled = true
        mainScroll.delegate = self
        
        
        for img in images {
            ///let childScroll = UIScrollView(frame: CGRect(x: posX, y: 0, width: scrollWidth, height: scrollHeight))
            let childScroll = UIScrollView(frame: .zero)
            ///childScroll.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
            childScroll.contentInsetAdjustmentBehavior = .never
            childScroll.minimumZoomScale = 1.0
            childScroll.maximumZoomScale = 4.0
            childScroll.delegate = self
            
            ///let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollWidth, height: scrollHeight))
            let imgView = UIImageView(frame: .zero)
            imgView.image = UIImage(named: img)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imageViews.append(imgView)
            
            childScroll.addSubview(imgView)
            mainScroll.addSubview(childScroll)
            
        }
        /*let teddyImg = UIImageView(image:UIImage(named:"teddy"))
        teddyImg.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(teddyImg)
        
        //prevent the scroll this image with rest of content in scroll view
        teddyImg.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor, constant: 25).isActive = true
        teddyImg.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 25).isActive = true*/
        
        /*let scrollWidth = scrollView.frame.size.width
        let scrollHeight = scrollView.frame.size.height
        let minScale = min(scrollWidth/imgWidth,scrollHeight/imgHeight)
        let maxScale = max(minScale*4.0,1.0)
        
        scrollView.zoomScale = minScale //initial present the image
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale*/
        
        stackView.addArrangedSubview(mainScroll)
        
        updateSize()
        
    }
    
    func updateSize(){
        let scrollWidth = stackView.frame.size.width
        let scrollHeight = stackView.frame.size.height
        
        var posX:CGFloat = 0
        for imgView in imageViews{
            let scroll = imgView.superview as! UIScrollView
            scroll.frame = CGRect(x: posX, y: 0, width: scrollWidth, height: scrollHeight)
            scroll.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
            imgView.frame = CGRect(x: 0, y: 0, width: scrollWidth, height: scrollHeight)
            posX = posX + scrollWidth
        }
        mainScroll.contentSize = CGSize(width: scrollWidth * CGFloat(imageViews.count), height: scrollHeight)
        
        let currentScrollView = imageViews[page].superview as! UIScrollView
        mainScroll.contentOffset = CGPoint(x: currentScrollView.frame.origin.x, y: 0)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViews[page]  //return which view is going to be zooom
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !rotating {
            let getPage = round(mainScroll.contentOffset.x / (stackView.frame.size.width))
            let currentPage = Int(getPage)
            if currentPage != page{
                let scroll = imageViews[page].superview as! UIScrollView
                scroll.setZoomScale(1.0, animated: true)
                page = Int(currentPage)
                pageControl.currentPage = page
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("rotated")
        rotating = true
        coordinator.animate(alongsideTransition: nil, completion: {(context:UIViewControllerTransitionCoordinatorContext!) in
            let scroll = self.imageViews[self.page].superview as! UIScrollView
            scroll.setZoomScale(1.0, animated: true)
            self.updateSize()
            self.rotating = false
        })
    }


}

