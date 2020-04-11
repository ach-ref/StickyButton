//
//  StickyButton.swift
//  StickyButton
//
//  Created by Achref Marzouki on 22/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit


// MARK: Button sticky side

/// A type representing the side on which the sticky button is glued.
public enum StickyButtonSide: Int, CustomStringConvertible {
    case left, right
    
    public var description: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        }
    }
}

// MARK: Sticky Button

/// A sticky floating action button. Can be used diretly in the interface builder.
@IBDesignable
@objcMembers
open class StickyButton: UIView {
    
    // MARK: - Default properties
    
    public static var size: CGFloat = 70
    
    // MARK: - IBInspectable
    
    /// The button's size. It represents the circle's diameter.
    @IBInspectable
    open var size: CGFloat = StickyButton.size {
        didSet {
            frame.size = CGSize(width: size, height: size)
            setNeedsDisplay()
        }
    }
    
    /// The horizontal margin bteween the button and the safe area.
    /// If the button is  glued to the left it will be the left margin otherwise it represents the right margin. Default value is `20`.
    @IBInspectable
    open var horizontalMargin: CGFloat = 20 {
        didSet { setNeedsDisplay() }
    }
    
    /// The bottom margin according to the safe area. The default value is `20`.
    @IBInspectable
    open var bottomMargin: CGFloat = 20 {
        didSet { setNeedsDisplay() }
    }
    
    /// The horizontal spacing between each item when the menu is shown. The default value is `8`.
    @IBInspectable
    open var itemsSpacing: CGFloat = 8
    
    /// The button's tint color. This property acts like an ordinary tint color of an `UIButton`.
    /// If the `buttonImage` property is set make sure that the rendering mode of the image is `.alwaysTemplate`.
    @IBInspectable
    open var buttonTintColor: UIColor = .white {
        didSet { setNeedsDisplay() }
    }
    
    /// The button's background color.
    @IBInspectable
    open var buttonBackgroundColor: UIColor = UIColor(red: 31/255.0, green: 180/255.0, blue: 246/255.0, alpha: 1) {
        didSet { setNeedsDisplay() }
    }
    
    /// The expanding circular view (when the menu is shown) background color.
    @IBInspectable
    open var overlayViewBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3) {
        didSet { overlayView.backgroundColor = overlayViewBackgroundColor }
    }
    
    /// The button's image. By default it's a plus sign.
    @IBInspectable
    open var buttonImage: UIImage? {
        didSet { setNeedsDisplay() }
    }
    
    /// The close button's image. By default it's a cross sign (rotation of 45° of the plus sign).
    @IBInspectable
    open var closeButtonImage: UIImage?
    
    /// The rotation angle of the button in degrees while showing the menu. The default Value is `45`. `0` would mean no rotation.
    @IBInspectable
    open var rotationDegree: CGFloat = 45
    
    /// The button's shadow radius. The default value is `3`.
    @IBInspectable
    open var shadowRadius: CGFloat = 3 {
        didSet { setNeedsDisplay() }
    }
    
    /// The buttn's shadow offset. The default value is `CGSize(width: 0, height: 2)`.
    @IBInspectable
    open var shadowOffset: CGSize = CGSize(width: 0, height: 2) {
        didSet { setNeedsDisplay() }
    }
    
    /// The button's shadow opacity. The default value is `0.4`.
    @IBInspectable
    open var shadowOpacity: Float = 0.4 {
        didSet { setNeedsDisplay() }
    }
    
    /// The button's shadow color. The default value is `UIColor.black`.
    @IBInspectable
    open var shadowColor: UIColor = .black {
        didSet { setNeedsDisplay() }
    }
    
    /// Automatically close or not the menu on background tap. The default value is `true`.
    @IBInspectable
    open var autoCloseOnBackgroundTap: Bool = true
    
    /// Open the menu even when there is no items. The default value is `true`.
    @IBInspectable
    open var showMenuWhenEmpty: Bool = true
    
    /// Show a shake animation when trying to open an empty menu. The `showMenuWhenEmpty` property should be disabled.
    /// The default value is `true`.
    @IBInspectable
    open var animateEmpty: Bool = true
    
    /// The button will shows on top of the keyboard according to bottom margin. The default value is `true`.
    @IBInspectable
    open var showOnTopOfKeyboard: Bool = true
    
    /// The height of each item. The default value is `50`.
    @IBInspectable
    open var itemSize: CGFloat = StickyButtonItem.size {
        didSet { setMenuItems(items) }
    }
    
    /// The image tint color for each item. The rendering mode of the icon (image) needs to be set to `.alwaysTemplate` in order to get the icon tinted.
    /// The default value is `nil`.
    @IBInspectable
    open var itemIconTintColor: UIColor? {
        didSet { setMenuItems(items) }
    }
    
    /// The icon's circle background color for each item. The default value is `UIcolor.white`.
    @IBInspectable
    open var itemIconBackground: UIColor = StickyButtonItem.iconBackgroundColor {
        didSet { setMenuItems(items) }
    }
    
    /// The title's text color for each item. The default value is `UIColor.darkGray`.
    @IBInspectable
    open var itemTitleTextColor: UIColor = StickyButtonItem.titleTextColor {
        didSet { setMenuItems(items) }
    }
    
    /// The title's background color for each item. The default value is `UIcolor.white`.
    @IBInspectable
    open var itemTitleBackground: UIColor = StickyButtonItem.titleBackgroundColor {
        didSet { setMenuItems(items) }
    }
    
    /// The title's font name for each item. The default value is `Helvetica`.
    @IBInspectable
    open var itemTitleFontName: String = StickyButtonItem.titleFontName {
        didSet { setMenuItems(items) }
    }
    
    /// The title's font size for each item. The default value is `13`.
    @IBInspectable
    open var itemTitleFontSize: CGFloat = StickyButtonItem.titleFontSize {
        didSet { setMenuItems(items) }
    }
    
    /// The distance between the titile and the icon for each item. The default value is `20`.
    @IBInspectable
    open var itemTitleOffset: CGFloat = StickyButtonItem.titleOffset {
        didSet { setMenuItems(items) }
    }
    
    // MARK: - Properties
    
    /// Represents a global manager of a unique instance of the button which will be present in all screens.
    public static let global = StickyButtonManager.shared
    
    public var delegate: StickyButtonDelegate?
    
    /// True when the menu is shown
    open var isOpen: Bool = false
    
    /// Represents the side on which the button is glued. It's a read-only property.
    open var stickySide: StickyButtonSide {
        let centerX = convert(center, to: nil).x
        let screenBounds = UIScreen.main.bounds
        let distanceFromLeftEdge = centerX, distanceFromRightEdge = screenBounds.width - centerX
        return distanceFromLeftEdge < distanceFromRightEdge ? .left : .right
    }
    
    /// An array of the items. It's a read-only property. To set it please consider using the `setItems(_:)` method.
    open private(set) var items: [StickyButtonItem] = []
    
    // MARK: - Private
    
    /// Shake animation string ket.
    private let shakeAnimationKey = "shake"
    
    /// Button's circle shape
    private let circleShape = CAShapeLayer()
    
    /// Button's plus shaep.
    private let plusShape = CAShapeLayer()
    
    /// When the button is highlighted, it's overlaid with this tint layer.
    private let highlightedShape = CAShapeLayer()
    
    /// The button's accessibility view.
    private let accessibilityView = UIView()
    
    /// The background view of the menu when it's shown.
    private let overlayView = UIView()
    
    /// The button's image view. For acustom icon use.
    private var imageView = UIImageView()
    
    /// The rotation angle in radian according to the current sticky side of the button.
    private var rotationRadian: CGFloat {
        let unsignedDegree = abs(rotationDegree)
        let degree = stickySide == .left ? -unsignedDegree : unsignedDegree
        return degree.radianValue
    }
    
    /// A dictionary of items' bottom anchors used to update thier y postions.
    private var itemAnchors: [String : NSLayoutConstraint] = [:]
    
    /// The current keyboard size.
    private var keyboardSize: CGSize = .zero
    
    /// The button's current frame.
    private var currentFrame: CGRect {
        let x = (frame.width - size) * 0.5, y = (frame.height - size) * 0.5
        return CGRect(x: x, y: y, width: size, height: size)
    }
    
    
    // MARK: - Initializers
    
    /// Init with a custom frame
    /// - Parameter frame: The frame rectangle for the button, measured in points.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        size = min(frame.size.width, frame.size.height)
        initialSetup()
    }
    
    /// Init with data in a given unarchiver.
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        size = min(frame.size.width, frame.size.height)
        initialSetup()
    }
    
    /// Initi with size
    /// - Parameter size: The size of the button. It represents the diameter of a circle or the side of a square.
    public init(size: CGFloat) {
        self.size = size
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        initialSetup()
    }
    
    /// Performs the initial settings for the button
    private func initialSetup() {
        clipsToBounds = false
        layer.masksToBounds = false
        backgroundColor = .clear
        addGestureRecognizers()
        addObservers()
        setupButtonAccessibility()
    }
    
    // MARK: - Deinit
    
    /// Deinitializer
    deinit {
        // remove all observers
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Sizing
    
    /// The button's intrinsic size.
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: size, height: size)
    }
    
    // MARK: - Life cycle
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        placeItems()
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateButtonAccessibility()
        #if !TARGET_INTERFACE_BUILDER
        updatePosition()
        #endif
    }
    
    // MARK: - Drawing
    
    open override func draw(_ rect: CGRect) {
        //layer
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        // circle
        layoutCircle()
        // image
        layoutImage()
        // overlay view
        layoutOverlayView()
    }
    
    /// Draws the circle shape
    private func layoutCircle() {
        // circle
        let aFrame = currentFrame
        circleShape.removeFromSuperlayer()
        circleShape.path = UIBezierPath(ovalIn: aFrame).cgPath
        circleShape.frame = aFrame
        circleShape.fillColor = buttonBackgroundColor.cgColor
        circleShape.shadowOpacity = shadowOpacity
        circleShape.shadowRadius = shadowRadius
        circleShape.shadowOffset = shadowOffset
        circleShape.shadowColor = shadowColor.cgColor
        layer.addSublayer(circleShape)
        
        // selected state shape
        highlightedShape.removeFromSuperlayer()
        highlightedShape.path = UIBezierPath(ovalIn: aFrame).cgPath
        highlightedShape.frame = aFrame
        highlightedShape.fillColor = UIColor.clear.cgColor
        layer.addSublayer(highlightedShape)
    }
    
    /// Layout the plus shape or setup the icon if it was set.
    private func layoutImage() {
        // if the button image is set
        guard buttonImage == nil else {
            setupImageView()
            return
        }
        
        // draw plus layer
        plusShape.removeFromSuperlayer()
        let currentTransform = plusShape.transform
        plusShape.transform = CATransform3DIdentity
        plusShape.frame = currentFrame
        plusShape.path = plusBezierPath().cgPath
        plusShape.transform = currentTransform
        plusShape.lineCap = .round
        plusShape.strokeColor = buttonTintColor.cgColor
        plusShape.lineWidth = 2.0
        layer.addSublayer(plusShape)
    }
    
    /// Setup the icon image view according the selected icon.
    private func setupImageView() {
        let imageViewSize = size / sqrt(2) - 16
        let centerX = frame.width * 0.5, centerY = frame.height * 0.5
        let x = centerX - imageViewSize * 0.5, y = centerY - imageViewSize * 0.5
        imageView.removeFromSuperview()
        imageView = UIImageView(image: buttonImage)
        imageView.clipsToBounds = true
        imageView.tintColor = buttonTintColor
        let currentTransform = imageView.transform
        imageView.transform = .identity
        imageView.frame = CGRect(x: x, y: y, width: imageViewSize, height: imageViewSize)
        imageView.transform = currentTransform
        addSubview(imageView)
    }
    
    /// Returns the bezier path of the plus sign.
    private func plusBezierPath() -> UIBezierPath {
        let path = UIBezierPath(), plusSizeRadius = size / 4
        let centerX = frame.width * 0.5, centerY = frame.height * 0.5
        path.move(to: CGPoint(x: centerX - plusSizeRadius , y: centerY))
        path.addLine(to: CGPoint(x: centerX + plusSizeRadius, y: centerY))
        path.move(to: CGPoint(x: centerX, y: centerY - plusSizeRadius))
        path.addLine(to: CGPoint(x: centerX, y: centerY + plusSizeRadius))
        return path
    }
    
    /// Draws the overlay (expanding background)
    private func layoutOverlayView() {
        
        guard !isOpen else {
            return
        }
        
        overlayView.removeFromSuperview()
        let currentTransform = overlayView.transform
        overlayView.transform = .identity
        overlayView.frame = currentFrame
        overlayView.transform = currentTransform
        overlayView.layer.cornerRadius = size * 0.5
        overlayView.alpha = 0
        overlayView.backgroundColor = overlayViewBackgroundColor
        addSubview(overlayView)
        sendSubviewToBack(overlayView)
    }
    
    // MARK: - Positioning
    
    /// Perform an animating side switch if needed.
    ///
    /// - Parameter side: The desired side of type `StickyButtonSide`.
    /// - Returns: A boolean indicating if wether or not it's possible to change the side.
    /// Basically the function is called with the side param equal to the current side it will returns `false`.
    @discardableResult
    open func setStickySide(_ side: StickyButtonSide) -> Bool {
        
        guard side != stickySide else {
            return false
        }
        
        if side == .left {
            stickTotheLeft()
        }
        else {
            stickTotheRight()
        }
        
        return true
    }
    
    /// Updates the button's position
    private func updatePosition() {
        placeSelf(newDirection: stickySide, animated: false)
    }
    
    /// Update the button's position and stick it to the left.
    /// - Parameter animated: A boolean indicating whether or not to animate the position changes.
    private func stickTotheLeft(animated: Bool = false) {
        // notify delegate before side switch
        delegate?.stickyButtonWillChangeSide()
        // switch side
        placeSelf(newDirection: .left, animated: animated)
        items.forEach({ $0.stickySideChanged() })
        // notify delegate after side switch
        delegate?.stickyButtonDidChangeSide()
    }
    
    /// Update the button's position and stick it to the right.
    /// - Parameter animated: A boolean indicating whether or not to animate the position changes.
    private func stickTotheRight(animated: Bool = false) {
        // notify delegate before side switch
        delegate?.stickyButtonWillChangeSide()
        // switch side
        placeSelf(newDirection: .right, animated: animated)
        items.forEach({ $0.stickySideChanged() })
        // notify delegate after side switch
        delegate?.stickyButtonDidChangeSide()
    }
    
    /// Place the button in the screen according to the given new direction (side).
    /// - Parameter newDirection: The side on which the button will be glued. The possible values are `.left` or `.right`
    /// - Parameter animated: A boolean indicating whether or not to animate the position changes.
    private func placeSelf(newDirection: StickyButtonSide, animated: Bool) {
        // safe area
        guard let safeArea = superview?.safeAreaLayoutGuide.layoutFrame else { return }
        // bring self to front
        superview!.bringSubviewToFront(self)
        // y pos
        var yPos = safeArea.maxY - bottomMargin - size - keyboardSize.height
        yPos += keyboardSize.height > 0 ? superview!.safeAreaInsets.bottom : 0
        frame.origin.y = yPos
        
        // x pos
        let xPos: CGFloat = newDirection == .left ? safeArea.minX + horizontalMargin : safeArea.maxX - horizontalMargin - size
        guard frame.origin.x != xPos  else { return }
        if animated {
            #if !TARGET_INTERFACE_BUILDER
            // animate x position
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.1,
                           options: .curveEaseInOut,
                           animations: {
                            
                            self.frame.origin.x = xPos
            }, completion: nil)
            #else
            frame.origin.x = xPos
            #endif
        }
        else {
            frame.origin.x = xPos
        }
    }
    
    // MARK: - Touches
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isOpen else {
            // select
            highlightedShape.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
            return
        }
        
        // when the menu is open
        // only select if the touch occurs inside the circle
        if let location = touches.first?.location(in: self), currentFrame.contains(location) {
            highlightedShape.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // deselect
        highlightedShape.fillColor = UIColor.clear.cgColor
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // deselect
        highlightedShape.fillColor = UIColor.clear.cgColor
        
        // handle tap action
        if isButtonTap(touches: touches) {
            toggleMenu()
        }
    }
    
    /// Returns a boolean indicating whether or not the touches represents a tap inside the button.
    /// - Parameter touches: A set of `UITouch` instances that represent the touches for the ending phase of the event represented by event
    private func isButtonTap(touches: Set<UITouch>) -> Bool {
        let infPoint = CGPoint(x: CGFloat.infinity, y: CGFloat.infinity)
        let touchLocation = touches.first?.location(in: self) ?? infPoint
        let isTap = touches.count == 1 && touches.first?.tapCount == 1
        
        guard isOpen else { return isTap }
        
        let buttonTapped = isTap && currentFrame.contains(touchLocation)
        let itemTapped = items.filter({ $0.tapArea().contains(touches.first?.location(in: $0) ?? infPoint) }).count > 0
        var result = isTap && !itemTapped
        result = autoCloseOnBackgroundTap ? result : result && buttonTapped
        
        return result
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if isOpen {
            for item in items {
                if item.isHidden || item.alpha == 0 { continue }
                let itemPoint = item.convert(point, from: self)
                if item.tapArea().contains(itemPoint) {
                    return item.hitTest(itemPoint, with: event)
                }
            }
            
            // when the menu is open
            // all touches belong to self
            return self
        }
        
        return super.hitTest(point, with: event)
    }
    
    // MARK: - Swipe handling
    
    /// Add swipe gesture recongnizers (left and right) to the button to allow dragging.
    private func addGestureRecognizers() {
        // swipe right
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        rightSwipeGesture.direction = .right
        addGestureRecognizer(rightSwipeGesture)
        // swipe left
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        leftSwipeGesture.direction = .left
        addGestureRecognizer(leftSwipeGesture)
    }
    
    /// Handle the swipe gesture.
    /// - Parameter gestureRecognizer: A concrete subclass of UIGestureRecognizer that looks for swiping gestures in one or more directions.
    @objc private func swipeHandler(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
        guard gestureRecognizer.state == .ended, !isOpen, delegate?.stickyButtonShouldChangeSide() ?? true else {
            return
        }
        
        // go left
        if stickySide == .right && gestureRecognizer.direction == .left {
            stickTotheLeft(animated: true)
            return
        }
        // go right
        if stickySide == .left && gestureRecognizer.direction == .right {
            stickTotheRight(animated: true)
        }
    }
    
    // MARK: - Menu
    
    /// Simply toggle the menu (show / hide).
    open func toggleMenu() {
        // show
        guard isOpen else {
            guard delegate?.stickyButtonShouldShowItems() ?? true else { return }
            items.forEach({ $0.stickySideChanged() })
            showMenu()
            return
        }
        // hide
        hideMenu()
    }
    
    /// Performs a shake animation only whten the `animateEmpty` is `true`.
    private func performEmptyMenuAnimation() {
        guard animateEmpty else { return }
        // remove animation if exists
        layer.removeAnimation(forKey: shakeAnimationKey)
        // add
        let animation = CAKeyframeAnimation(keyPath: "position.x")
        animation.values = [-30, 30, -20, 20, -10, 10, -5, 5, 0]
        animation.isAdditive = true
        animation.duration = 0.6
        layer.add(animation, forKey: shakeAnimationKey)
    }
    
    /// Shows the menu with animation.
    open func showMenu() {
        
        guard showMenuWhenEmpty else {
            performEmptyMenuAnimation()
            return
        }
        
        // notify delegate that items will shown
        delegate?.stickyButtonWillShowItems()
        
        // vars
        let screenBounds = UIScreen.main.bounds, circleCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let aFrame = frameForCircle(withScreenBounds: screenBounds, startingPoint: circleCenter)
        // bring self to front
        superview?.bringSubviewToFront(self)
        // make sure no pending layout
        layoutIfNeeded()
        // new items anchors
        let yOrigin = -size * 0.5 - 30
        let yOffset = itemSize + itemsSpacing
        for (i, item) in items.enumerated() {
            let hash = item.hashString
            let yAnchor = itemAnchors[hash]
            yAnchor?.constant = yOrigin - yOffset * CGFloat(i) - itemSize * 0.5
        }
        CATransaction.begin()
        // animate imageView's image change
        UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.closeButtonImage
        }, completion: nil)
        // animate the rest
        overlayView.frame = aFrame
        overlayView.center = circleCenter
        overlayView.layer.cornerRadius = aFrame.size.width * 0.5
        overlayView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.plusShape.transform = CATransform3DMakeRotation(self.rotationRadian, 0, 0, 1)
            self.imageView.transform = CGAffineTransform(rotationAngle: self.rotationRadian)
            self.overlayView.transform = .identity
            self.overlayView.alpha = 1
            self.items.forEach({ $0.alpha = 1 })
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }, completion: { success in
            self.isOpen = true
            self.updateButtonAccessibility()
            // notify delegate that items have been shown
            self.delegate?.stickyButtonDidShowItems()
        })
        CATransaction.commit()
    }
    
    /// Hides the menu with animation.
    open func hideMenu() {
        
        // make sure the menu is open
        guard isOpen else {
            return
        }
        
        // notify delegate that items will be hidden
        delegate?.stickyButtonWillHideItems()
        
        // make sure no pending layout
        layoutIfNeeded()
        // update iems anchors
        items.forEach({ itemAnchors[$0.hashString]?.constant = 0 })
        CATransaction.begin()
        // animate imageView's image change
        UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.buttonImage
        }, completion: nil)
        // animate the rest
        UIView.animate(withDuration: 0.3, animations: {
            self.plusShape.transform = CATransform3DIdentity
            self.imageView.transform = .identity
            self.overlayView.frame = self.currentFrame
            self.overlayView.layer.cornerRadius = self.overlayView.frame.width * 0.5
            self.overlayView.center = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
            self.items.forEach({ $0.alpha = 0 })
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }, completion: { success in
            self.overlayView.alpha = 0
            self.isOpen = false
            self.updateButtonAccessibility()
            // notify delegate that items have been hidden
            self.delegate?.stickyButtonDidHideItems()
        })
        CATransaction.commit()
    }
    
    /// Updates the overlay view position and size.
    private func updateOverlayViewFrame() {
        let screenBounds = UIScreen.main.bounds, circleCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        self.overlayView.frame = frameForCircle(withScreenBounds: screenBounds, startingPoint: circleCenter)
        self.overlayView.layer.cornerRadius = self.overlayView.frame.width * 0.5
        self.overlayView.center = circleCenter
    }
    
    /// Returns a frame for the overlay view according to the starting point and the screen bouns.
    /// - Parameter bounds: The screen bounds.
    /// - Parameter startingPoint: The center of the button.
    private func frameForCircle(withScreenBounds bounds: CGRect, startingPoint: CGPoint) -> CGRect {
        let toPoint = self.toPoint(fromScreenBounds: bounds)
        let fromPoint = convert(startingPoint, to: nil)
        let dx = fromPoint.x - toPoint.x, dy = fromPoint.y - toPoint.y
        let distance = sqrt(dx * dx + dy * dy) * 2
        return CGRect(origin: startingPoint, size: CGSize(width: distance, height: distance))
    }
    
    /// Returns the end point of a line starting from the button's center according to the current device orientation.
    /// It represents the overlay view's circle radius.
    /// - Parameter bounds: The screen bouns.
    private func toPoint(fromScreenBounds bounds: CGRect) -> CGPoint {
        let orientation = statusBarOrientation
        var x = stickySide == .left ? bounds.minX : bounds.maxX
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            x = stickySide == .left ? bounds.maxX * 4 * 0.2 : bounds.maxX * 0.2
        }
        let y = bounds.minY
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Interface builder
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        size = min(frame.width, frame.height)
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Notifications
    
    /// Add observers for keyabord and device orientation changes.
    open func addObservers() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Items
    
    /// Sets the button's items.
    /// - Parameter items: An array of the button's items of type `StickyButtonItem`.
    open func setMenuItems(_ items: [StickyButtonItem]) {
        self.items = items
        self.items.forEach({ setItemDefaults($0) })
        placeItems()
    }
    
    /// Adds an item to the button according to the given title, icon and handler.
    /// This method will apply the item's appearance chosen at the button's level. So if you change any item's property before calling this method it will be overriden.
    /// - Parameter title: The item's title. Optional `String`.
    /// - Parameter icon: The item's icon. Optional `UIImage`.
    /// - Parameter handler: A closure to handle the action when the item is selected. Optional `StickyButtonItemHandler`.
    @discardableResult
    open func addItem(title: String?, icon: UIImage?, handler: StickyButtonItemHandler?) -> StickyButtonItem {
        let item = StickyButtonItem(title: title, image: icon, handler: handler)
        setItemDefaults(item)
        items.append(item)
        placeItem(item)
        return item
    }
    
    /// Adds the given item to the button. Use this method to give a custom appearance to the item.
    /// - Parameter item: The item to add.
    @discardableResult
    open func addItem(_ item: StickyButtonItem) -> StickyButtonItem{
        items.append(item)
        item.stickyButton = self
        placeItem(item)
        return item
    }
    
    /// Place all the items at the same Y as the button.
    private func placeItems() {
        items.forEach({ placeItem($0) })
    }
    
    /// Place a signle item at the same Y as the button.
    /// - Parameter item: The item to place.
    private func placeItem(_ item: StickyButtonItem) {
        // safe area
        guard let edge = superview?.safeAreaLayoutGuide else { return }
        // add item as a subview
        item.removeFromSuperview()
        if let heightAnchor = item.constraints.filter({ $0.identifier == "ItemHeightAnchor" }).first {
            item.removeConstraint(heightAnchor)
        }
        addSubview(item)
        // item constraints
        item.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = item.heightAnchor.constraint(equalToConstant: itemSize)
        heightConstraint.identifier = "ItemHeightAnchor"
        heightConstraint.isActive = true
        item.leadingAnchor.constraint(equalTo: edge.leadingAnchor, constant: horizontalMargin).isActive = true
        edge.trailingAnchor.constraint(equalTo: item.trailingAnchor, constant: horizontalMargin).isActive = true
        
        let itemCenterYAnchor = item.centerYAnchor.constraint(equalTo: centerYAnchor)
        itemCenterYAnchor.identifier = item.hashString
        itemAnchors[item.hashString] = itemCenterYAnchor
        itemCenterYAnchor.priority = UILayoutPriority(rawValue: 999)
        itemCenterYAnchor.isActive = true
    }
    
    /// Applies to the given item the chosen appearance at the button's level.
    /// - Parameter item: The item to setup.
    private func setItemDefaults(_ item: StickyButtonItem) {
        item.size = itemSize
        item.titleOffset = itemTitleOffset
        item.titleFontName = itemTitleFontName
        item.titleFontSize = itemTitleFontSize
        item.titleTextColor = itemTitleTextColor
        item.titleBackgroundColor = itemTitleBackground
        item.iconTintColor = itemIconTintColor
        item.iconBackgroundColor = itemIconBackground
        item.stickyButton = self
    }
}

// MARK: - Device orientation management

extension StickyButton {
    
    /// Returns the device orientation.
    open var statusBarOrientation: UIInterfaceOrientation {
        
        guard #available(iOS 13.0, *) else {
            return UIApplication.shared.statusBarOrientation
        }
        
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
    }
    
    /// Called when the device changed it's orientation. Basically it updates the button's position and layout.
    /// - Parameter notification: A container for information broadcast through a notification center to all registered observers.
    @objc private func deviceOrientationDidChange(_ notification: Notification) {
        updatePosition()
        if isOpen {
            updateOverlayViewFrame()
        }
    }
}

// MARK: - Keyboard management

extension StickyButton {
    
    /// Called when the kayboard is about to showing up. It updates the button's position.
    /// - Parameter notification: A container for information broadcast through a notification center to all registered observers.
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard showOnTopOfKeyboard else { return }
        keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size ?? .zero
        updatePosition()
    }
    
    /// Called when the kayboard is about to hide. It updates the button's position.
    /// - Parameter notification: A container for information broadcast through a notification center to all registered observers.
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardSize = .zero
        updatePosition()
    }
}

// MARK: - Accessibility

extension StickyButton {
    
    /// Sets the accessibility properties of the button.
    internal func setupButtonAccessibility() {
        // for UI testing
        isAccessibilityElement = false
        accessibilityIdentifier = "Sticky Button"
        accessibilityTraits.insert(.button)
        overlayView.accessibilityIdentifier = "Sticky Button Overlay"
        // accessibility view for the button
        accessibilityView.accessibilityLabel = String(format: "Sticky Button on the %@ side", stickySide.description)
        accessibilityView.isAccessibilityElement = true
        accessibilityView.accessibilityTraits.insert(.button)
        addSubview(accessibilityView)
        // excluded elements
        imageView.isAccessibilityElement = false
        overlayView.isAccessibilityElement = false
    }
    
    /// Update the button's accessibility information.
    internal func updateButtonAccessibility() {
        accessibilityViewIsModal = isOpen
        accessibilityView.frame = bounds
        accessibilityView.accessibilityLabel = String(format: "Sticky Button on the %@ side", stickySide.description)
        items.forEach { $0.updateItemAccessibility() }
    }
    
    /// The button's accessibility label. A succinct label that identifies the accessibility element, in a localized string.
    open override var accessibilityLabel: String? {
        get { accessibilityView.accessibilityLabel }
        set { accessibilityView.accessibilityLabel = newValue }
    }
    
    /// The button's accessibility hint. A brief description of the result of performing an action on the accessibility element, in a localized string.
    open override var accessibilityHint: String? {
        get { accessibilityView.accessibilityHint }
        set { accessibilityView.accessibilityHint = newValue }
    }
    
    /// The button's accessibility value. The value of the accessibility element, in a localized string.
    open override var accessibilityValue: String? {
        get { accessibilityView.accessibilityValue }
        set { accessibilityView.accessibilityValue = newValue }
    }
}
