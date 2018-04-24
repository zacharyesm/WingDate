//
//  MatchSwipeVC.swift
//  WingMom
//
//  Created by Zack Esm on 4/21/18.
//  Copyright © 2018 Hackchella. All rights reserved.
//

import UIKit

class MatchSwipeVC: UIViewController {
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Parent", "Me"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.tintColor = .red
//        sc.backgroundColor = .white
        return sc
    }()

    /// Data structure for custom cards - in this example, we're using an array of ImageCards
    var cards = [CardView]()
    /// The emojis on the sides are simply part of a view that sits ontop of everything else,
    /// but this overlay view is non-interactive so any touch events are passed on to the next receivers.
//    var emojiOptionsOverlay: EmojiOptionsOverlay!
    
    var users = [User]()
    
    var motherLikes = [String]()
    
    let likeImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "swipe-right_2"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
        return iv
    }()
    
    let dislikeImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "swipe-left"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
        return iv
    }()
    
    let searchingView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.alpha = 0
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        segmentedControl.addTarget(self, action: #selector(indexChange(_:)), for: .valueChanged)
        
        FirebaseService.fs.getUsers { (users) in
            self.users = users
            self.start()
        }
        
    }
    
    @objc func indexChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 && cards.count == 0 { //get mother likes
            
            FirebaseService.fs.getMotherLikes({ (users) in
                self.users = users
                self.start()
            })
        } else {
            FirebaseService.fs.getUsers { (users) in
                self.users = users
                self.start()
            }
        }
    }
    
    fileprivate func setupView() {
//        self.view.backgroundColor = UIColor(red: 28/255, green: 39/255, blue: 101/255, alpha: 1.0)
        view.backgroundColor = .white
        let margins = view.layoutMarginsGuide
        
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.85).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        let swipeSV = UIStackView(arrangedSubviews: [dislikeImage, likeImage])
        swipeSV.translatesAutoresizingMaskIntoConstraints = false
        swipeSV.axis = .horizontal
        swipeSV.distribution = .fillEqually
        
        view.addSubview(swipeSV)
        swipeSV.heightAnchor.constraint(equalToConstant: 80).isActive = true
        swipeSV.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.85).isActive = true
        swipeSV.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
        swipeSV.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        view.addSubview(searchingView)
        searchingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        searchingView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        searchingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        let image = UIImageView(image: #imageLiteral(resourceName: "world"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        searchingView.addSubview(image)
        image.topAnchor.constraint(equalTo: searchingView.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: searchingView.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: searchingView.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: searchingView.bottomAnchor, constant: -50).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "No people in area"
        label.textAlignment = .center
        
        searchingView.addSubview(label)
        label.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: searchingView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: searchingView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: searchingView.bottomAnchor, constant: 0).isActive = true
        
        
    }
    
    func start() {
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        // of course, you could always add new cards to self.cards and call layoutCards() again
        for index in 0...users.count-1 {
            //            let card = ImageCard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.view.frame.height * 0.6))
            let v = CardView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.85, height: view.frame.height * 0.6))
            v.configureView(user: users[index])
            cards.append(v)
        }
        
        // 2. layout the first 4 cards for the user
        layoutCards()
        
        UIView.animate(withDuration: 0.5) {
            self.searchingView.alpha = 0
            self.likeImage.alpha = 1
            self.dislikeImage.alpha = 1
        }
    }
    
    /// Scale and alpha of successive cards visible to the user
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    let cardInteritemSpacing: CGFloat = 15
    
    /// Set up the frames, alphas, and transforms of the first 4 cards on the screen
    func layoutCards() {
        // frontmost card (first card of the deck)
        let firstCard = cards[0]
        self.view.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center = self.view.center
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
        
        // the next 3 cards in the deck
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            
            let card = cards[i]
            
            card.layer.zPosition = CGFloat(cards.count - i)
            
            // here we're just getting some hand-picked vales from cardAttributes (an array of tuples)
            // which will tell us the attributes of each card in the 4 cards visible to the user
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = self.view.center.x
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            // workaround: scale causes heights to skew so compensate for it with some tweaking
            if i == 3 {
                card.frame.origin.y += 1.5
            }
            
            self.view.addSubview(card)
        }
        
        // make sure that the first card in the deck is at the front
        self.view.bringSubview(toFront: cards[0])
    }
    
    /// This is called whenever the front card is swiped off the screen or is animating away from its initial position.
    /// showNextCard() just adds the next card to the 4 visible cards and animates each card to move forward.
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        // 1. animate each card to move forward one by one
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                if i == 1 {
                    card.center = self.view.center
                } else {
                    card.center.x = self.view.center.x
                    card.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
            
        }
        
        // 2. add a new card (now the 4th card in the deck) to the very back
        if 4 > (cards.count - 1) {
            if cards.count != 1 {
                self.view.bringSubview(toFront: cards[1])
            }
            return
        }
        let newCard = cards[4]
        newCard.layer.zPosition = CGFloat(cards.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        // initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = cards[1].frame.origin.y - (4 * cardInteritemSpacing)
        self.view.addSubview(newCard)
        
        // animate to end state of new card
        UIView.animate(withDuration: animationDuration, delay: (3 * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.cards[1].frame.origin.y - (3 * self.cardInteritemSpacing) + 1.5
        }, completion: { (_) in
            
        })
        // first card needs to be in the front for proper interactivity
        self.view.bringSubview(toFront: self.cards[1])
        
    }
    
    /// Whenever the front card is off the screen, this method is called in order to remove the card from our data structure and from the view.
    func removeOldFrontCard() {
        cards[0].removeFromSuperview()
        cards.remove(at: 0)
        if cards.count == 0 && segmentedControl.selectedSegmentIndex == 0 { //update momLikes
            FirebaseService.fs.addToMotherLikes(userIds: motherLikes)
        }
        
        if cards.count == 0 {
            UIView.animate(withDuration: 0.5) {
                self.searchingView.alpha = 1
                self.likeImage.alpha = 0
                self.dislikeImage.alpha = 0
            }
        }
        
    }
    
    /// UIKit dynamics variables that we need references to.
    var dynamicAnimator: UIDynamicAnimator!
    var cardAttachmentBehavior: UIAttachmentBehavior!
    
    /// This method handles the swiping gesture on each card and shows the appropriate emoji based on the card's center.
    @objc func handleCardPan(sender: UIPanGestureRecognizer) {
        // if we're in the process of hiding a card, don't let the user interace with the cards yet
        if cardIsHiding { return }
        // change this to your discretion - it represents how far the user must pan up or down to change the option
        let optionLength: CGFloat = 60
        // distance user must pan right or left to trigger an option
        let requiredOffsetFromCenter: CGFloat = 15
        
        let panLocationInView = sender.location(in: view)
        let panLocationInCard = sender.location(in: cards[0])
        switch sender.state {
        case .began:
            dynamicAnimator.removeAllBehaviors()
            let offset = UIOffsetMake(panLocationInCard.x - cards[0].bounds.midX, panLocationInCard.y - cards[0].bounds.midY);
            // card is attached to center
            cardAttachmentBehavior = UIAttachmentBehavior(item: cards[0], offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            dynamicAnimator.addBehavior(cardAttachmentBehavior)
        case .changed:
            cardAttachmentBehavior.anchorPoint = panLocationInView
            
        case .ended:
            
            dynamicAnimator.removeAllBehaviors()
            
            if false {
                // animate card to get "swallowed" by heart
                
                let currentAngle = CGFloat(atan2(Double(cards[0].transform.b), Double(cards[0].transform.a)))
                
//                let heartCenter = emojiOptionsOverlay.heartEmoji.center
                var newTransform = CGAffineTransform.identity
                newTransform = newTransform.scaledBy(x: 0.05, y: 0.05)
                newTransform = newTransform.rotated(by: currentAngle)
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
//                    self.cards[0].center = heartCenter
                    self.cards[0].transform = newTransform
                    self.cards[0].alpha = 0.5
                }, completion: { (_) in
//                    self.emojiOptionsOverlay.updateHeartEmoji(isFilled: false, isFocused: false)
                    self.removeOldFrontCard()
                })
                
//                emojiOptionsOverlay.hideFaceEmojis()
                showNextCard()
                
            } else {
//                emojiOptionsOverlay.hideFaceEmojis()
//                emojiOptionsOverlay.updateHeartEmoji(isFilled: false, isFocused: false)
                
                if !(cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter) || cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter)) {
                    // snap to center
                    let snapBehavior = UISnapBehavior(item: cards[0], snapTo: self.view.center)
                    dynamicAnimator.addBehavior(snapBehavior)
                } else {
                    
                    if segmentedControl.selectedSegmentIndex == 0 && cards[0].center.x > self.view.center.x { //like
                        motherLikes.append(cards[0].user.id)
                    }
                    
                    if segmentedControl.selectedSegmentIndex == 1 && cards[0].center.x > self.view.center.x { //match
                        let alert = UIAlertController(title: "Congrats!", message: "It's a Match!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    let velocity = sender.velocity(in: self.view)
                    let pushBehavior = UIPushBehavior(items: [cards[0]], mode: .instantaneous)
                    pushBehavior.pushDirection = CGVector(dx: velocity.x/10, dy: velocity.y/10)
                    pushBehavior.magnitude = 175
                    dynamicAnimator.addBehavior(pushBehavior)
                    // spin after throwing
                    var angular = CGFloat.pi / 2 // angular velocity of spin
                    
                    let currentAngle: Double = atan2(Double(cards[0].transform.b), Double(cards[0].transform.a))
                    
                    if currentAngle > 0 {
                        angular = angular * 1
                    } else {
                        angular = angular * -1
                    }
                    let itemBehavior = UIDynamicItemBehavior(items: [cards[0]])
                    itemBehavior.friction = 0.2
                    itemBehavior.allowsRotation = true
                    itemBehavior.addAngularVelocity(CGFloat(angular), for: cards[0])
                    dynamicAnimator.addBehavior(itemBehavior)
                    
                    showNextCard()
                    hideFrontCard()
                    
                }
            }
        default:
            break
        }
    }
    
    /// This function continuously checks to see if the card's center is on the screen anymore. If it finds that the card's center is not on screen, then it triggers removeOldFrontCard() which removes the front card from the data structure and from the view.
    var cardIsHiding = false
    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoveTimer: Timer? = nil
            cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
                guard self != nil else { return }
                if !(self!.view.bounds.contains(self!.cards[0].center)) {
                    cardRemoveTimer!.invalidate()
                    self?.cardIsHiding = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self?.cards[0].alpha = 0.0
                    }, completion: { (_) in
                        self?.removeOldFrontCard()
                        self?.cardIsHiding = false
                    })
                }
            })
        } else {
            // fallback for earlier versions
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.cards[0].alpha = 0.0
            }, completion: { (_) in
                self.removeOldFrontCard()
            })
        }
    }


}
