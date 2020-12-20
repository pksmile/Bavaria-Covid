//
//  BottomSheetVC.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/20/20.
//

import UIKit

let timeToLoadData : TimeInterval = 600.0
    
class BottomSheetVC: UIViewController {
    
    
    @IBOutlet var labelRulesMsg: UILabel!
    var labelTimer: UILabel = UILabel()
    var imageUp: UIImageView = UIImageView()
    var activityLoader: UIActivityIndicatorView = UIActivityIndicatorView()
    //for 10 minutes time interval to fetch data
    var duration: TimeInterval = timeToLoadData
    var countDown : Timer?
    
    var fullView: CGFloat = 650
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 55
        //return UIScreen.main.bounds.height - (left.frame.maxY + UIApplication.shared.statusBarFrame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fullView = view.frame.height - 200
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        
        roundViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGesture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func roundViews() {
        view.clipsToBounds = true
    }
    
    func prepareBackgroundView(){
       
        let blurEffect = UIBlurEffect.init(style: UIBlurEffect.Style.light)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
    
    func onFetchStart() {
        enableDisableProperty(interAction: false, timer: true)
        if countDown != nil{
            countDown!.invalidate()
        }else{
            print("Timer is null")
        }
    }
    
    func onFetchEnd() {
        enableDisableProperty(interAction: true, timer: false)
        activityLoader.stopAnimating()
        duration = timeToLoadData
        countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
        
    }
    
    func enableDisableProperty(interAction: Bool, timer: Bool) {
        self.view.isUserInteractionEnabled = interAction
        activityLoader.isHidden = interAction
        imageUp.isHidden = timer
        labelTimer.isHidden = timer
        
    }
    
    fileprivate func setupView() {
        activityLoader = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        activityLoader = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 50.0))
        activityLoader.startAnimating()
        view.addSubview(activityLoader)
        
        imageUp = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 50.0))
        imageUp.image = UIImage.init(named: "ic_up")
        imageUp.contentMode = .scaleAspectFit
        imageUp.isHidden = true
        view.addSubview(imageUp)
        
        labelTimer = UILabel(frame: CGRect(x: self.view.frame.width / 2, y: 0.0, width: self.view.frame.width / 2, height: 50.0))
        labelTimer.textAlignment = .right
        view.addSubview(labelTimer)
    }
    
    func rotateDropDownIcon(rotateImage: Bool) {
        if rotateImage{
            UIView.animate(withDuration: 3.0, animations: {
                self.imageUp.transform = CGAffineTransform.identity
            })
        }else{
            UIView.animate(withDuration: 3.0, animations: {
                self.imageUp.transform = CGAffineTransform(rotationAngle: .pi)
            })
        }
    }
    
    @objc func timer() {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        let formattedDuration = formatter.string(from: duration)
        duration -= 1
        labelTimer.text = "\(BottomSheet.loadData) \(String(describing: formattedDuration!))"
    }
    
    func setMessage(msg: String) {
        print(msg)
        labelRulesMsg.text = msg
    }
}

extension BottomSheetVC{
    
    //MARK: -Gesture UI
    func setupGesture() {
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                
                if  velocity.y >= 0 {
                    self.rotateDropDownIcon(rotateImage: true)
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.rotateDropDownIcon(rotateImage: false)
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                }, completion: nil)
        }
    }
}

