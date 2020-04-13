//
//  StickyButtonItem.swift
//  StickyButton
//
//  Created by Achref Marzouki on 23/10/2019.
//  Copyright © 2019 Achref Marzouki. All rights reserved.
//

import UIKit

// MARK: - Aliases

/// A type representing the action handler of a `StickyButton`'s item.
public typealias StickyButtonItemHandler = (StickyButtonItem) -> Void

/// A menu item of the `StickyButton`'s class. It has a title and an icon and acts like a button.
@objcMembers
open class StickyButtonItem: UIView {

    // MARK: - Default properties
    
    /// The item's default height `50`.
    public static var size: CGFloat = 50
    
    
    /// The item's default tap area horizontal padding.
    public static var tapAreaPadding: CGFloat = 10
    
    /// The item's icon default background color `UIColor.white`.
    public static var iconBackgroundColor: UIColor = .white
    
    /// The item's title default background color `UIColor.white`.
    public static var titleBackgroundColor: UIColor = .white
    
    /// The item's title default text color `UIColor.darkGray`.
    public static var titleTextColor: UIColor = .darkGray
    
    /// The item's title default font name `"Helvetica"`.
    public static var titleFontName: String = "Helvetica"
    
    /// The item's title default font size `13`.
    public static var titleFontSize: CGFloat = 13
    
    /// The item's title default horizontal distance from the icon `20`.
    public static var titleOffset: CGFloat = 20
    
    // MARK: - Properties
    
    /// The action handler when the item is selected.
    open var handler: StickyButtonItemHandler?
    
    /// A weak reference to the parent's `StickyButton` instance.
    open weak var stickyButton: StickyButton? {
        didSet { setupSideConstraints() }
    }
    
    /// The item's height. The default value is `50`.
    open var size: CGFloat = StickyButtonItem.size {
        didSet {
            setIconConstraints()
            setNeedsLayout()
        }
    }
    
    /// The item's tap area horizontal padding. The default value is `10`.
    open var tapAreaPadding: CGFloat = StickyButtonItem.tapAreaPadding
    
    /// The item's title.
    open var title: String? {
        didSet {
            titleLabel.text = title
            titleBackgroundView.isHidden = title == nil
            accessibilityLabel = title
            accessibilityIdentifier = title
            setNeedsLayout()
        }
    }
    
    /// The item's title font name. The default value is `Helvetica`.
    open var titleFontName: String = StickyButtonItem.titleFontName {
        didSet { titleFontChanged() }
    }
    
    /// The item's title font size. The default value is `13`.
    open var titleFontSize: CGFloat = StickyButtonItem.titleFontSize {
        didSet { titleFontChanged() }
    }
    
    /// The distance in points between the title and the icon. The default value is `20`.
    open var titleOffset: CGFloat = StickyButtonItem.titleOffset {
        didSet { setNeedsLayout() }
    }
    
    /// The item's title text color. The default value is `UIColor.darkGray`.
    open var titleTextColor: UIColor = StickyButtonItem.titleTextColor {
        didSet {
            titleLabel.textColor = titleTextColor
            setNeedsLayout()
        }
    }
    
    /// The item's title background color. The default value is `UIColor.white`.
    open var titleBackgroundColor: UIColor = StickyButtonItem.titleBackgroundColor {
        didSet {
            titleBackgroundView.backgroundColor = titleBackgroundColor
            setNeedsLayout()
        }
    }
    
    /// The item's icon.
    open var icon: UIImage? {
        didSet {
            iconImageView.image = icon
            setNeedsLayout()
        }
    }
    
    /// The item's icon tint color. The rendering mode of the icon should be set to `.alwaysTemplate` when this proporrty is set.
    open var iconTintColor: UIColor? {
        didSet {
            if iconTintColor != nil {
                iconBackgroundView.tintColor = iconTintColor
                setNeedsLayout()
            }
        }
    }
    
    /// The item's icon background color. The default value is `UIColor.white`.
    open var iconBackgroundColor: UIColor = StickyButtonItem.iconBackgroundColor {
        didSet {
            iconBackgroundView.backgroundColor = iconBackgroundColor
            setNeedsDisplay()
        }
    }
    
    // MARK: - Private
    
    /// A shape overlaid the item's icon when the item is highlighted.
    private let highlightedIconShape = CAShapeLayer()
    
    /// A shape overlaid the item's title when the item is highlighted.
    private let highlightedTitleShape = CAShapeLayer()
    
    /// The item's accessibility view.
    private let accessibilityView = UIView()
    
    /// The item's icon accessibility view.
    private let accessibilityIconView = UIView()
    
    /// The item's title accessibility view.
    private let accessibilityTitleView = UIView()
    
    /// The item's title label.
    private var titleLabel: UILabel!
    
    /// The item's title background view.
    private var titleBackgroundView: UIView!
    
    /// The item's title icon image view.
    private var iconImageView: UIImageView!
    
    /// The item's title icon background view.
    private var iconBackgroundView: UIView!
    
    /// The side on which the item will be stacked. The default value is `.left`. This property is handled
    private var stickySide: StickyButtonSide {
        return stickyButton?.stickySide ?? .left
    }
    
    // MARK: - Identification
    
    /// Returns a unique identifier for the item's instance.
    var hashString: String {
        return String(UInt(bitPattern: ObjectIdentifier(self)))
    }
    
    // MARK: - Initializers
    
    @available(*, unavailable)
    public override init(frame: CGRect) {
        fatalError("disabled init")
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("disabled init")
    }
    
    @available(*, unavailable)
    public init() {
        fatalError("disabled init")
    }
    
    /// Returns an item according to the given title, image and handler.
    /// - Parameter title: The item's title.
    /// - Parameter image: The item's image.
    /// - Parameter handler: The action handler which will be called when the item will be selected.
    public init(title: String?, image: UIImage?, handler: StickyButtonItemHandler? = nil) {
        super.init(frame: .zero)
        self.title = title
        self.icon = image
        self.handler = handler
        initialSetup()
        setupAccessibility()
    }
    
    /// Initial item's UI settings
    private func initialSetup() {
        alpha = 0
        backgroundColor = .clear
        isUserInteractionEnabled = true
        
        // icon image view
        iconImageView = UIImageView(image: icon)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // icon background view
        iconBackgroundView = UIView()
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        iconBackgroundView.backgroundColor = iconBackgroundColor
        iconBackgroundView.layer.cornerRadius = size * 0.5
        iconBackgroundView.layer.shadowOpacity = 1
        iconBackgroundView.layer.shadowRadius = 2
        iconBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 1)
        iconBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        iconBackgroundView.addSubview(iconImageView)
        addSubview(iconBackgroundView)
        
        // title label
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = titleTextColor
        titleFontChanged()
        
        // title background view
        titleBackgroundView = UIView()
        titleBackgroundView.isHidden = title == nil
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleBackgroundView.backgroundColor = titleBackgroundColor
        titleBackgroundView.layer.cornerRadius = 4
        titleBackgroundView.layer.shadowOpacity = 0.8
        titleBackgroundView.layer.shadowOffset = CGSize(width: 1, height: 1)
        titleBackgroundView.layer.shadowRadius = 2
        titleBackgroundView.layer.shadowColor = UIColor.lightGray.cgColor
        titleBackgroundView.addSubview(titleLabel)
        addSubview(titleBackgroundView)
        
        // fixed constraints
        setupFixedConstraints()
    }
    
    // MARK: - Drawing
    
    /// Draws the highlighted item's shape.
    private func setupHighlightedShapes() {
        // icon shape
        let iconFrame = iconBackgroundView.frame
        highlightedIconShape.removeFromSuperlayer()
        highlightedIconShape.path = UIBezierPath(ovalIn: iconFrame).cgPath
        highlightedIconShape.fillColor = UIColor.clear.cgColor
        layer.addSublayer(highlightedIconShape)
        
        // title shape
        let titleFrame = titleBackgroundView.frame
        let radius = titleBackgroundView.layer.cornerRadius
        highlightedTitleShape.removeFromSuperlayer()
        highlightedTitleShape.path = UIBezierPath(roundedRect: titleFrame, cornerRadius: radius).cgPath
        highlightedTitleShape.fillColor = UIColor.clear.cgColor
        layer.addSublayer(highlightedTitleShape)
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // icon bakcground circle
        iconBackgroundView.layer.cornerRadius = size * 0.5
        // highlighted shapes
        setupHighlightedShapes()
        // update accessibility views frames
        updateItemAccessibility()
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        // highlighted shapes
        setupHighlightedShapes()
    }
    
    /// Sets the fixed constraints of different elements. Basically it sets the vertical constraints.
    private func setupFixedConstraints() {
        // title
        let titleLabelTop = titleLabel.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 8)
        titleLabelTop.identifier = "titleLabelTop"
        titleLabelTop.isActive = true
        let titleLabelBottom = titleBackgroundView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        titleLabelBottom.identifier = "titleLabelBottom"
        titleLabelBottom.isActive = true
        let titleLeading = titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 8)
        titleLeading.identifier = "titleLabelLeading"
        titleLeading.isActive = true
        let titleLabelTrailing = titleBackgroundView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8)
        titleLabelTrailing.identifier = "titleLabelTrailing"
        titleLabelTrailing.isActive = true
        
        // title background
        let titleBackgroundTop = titleBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0)
        titleBackgroundTop.identifier = "titleBackgroundTop"
        titleBackgroundTop.isActive = true
        let titleBacgroundCenterY = titleBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor)
        titleBacgroundCenterY.identifier = "titleBacgroundCenterY"
        titleBacgroundCenterY.isActive = true
        
        // icon
        setIconConstraints()
        
        // icon background
        let iconBackgroundTopAcnhor = iconBackgroundView.topAnchor.constraint(equalTo: topAnchor)
        iconBackgroundTopAcnhor.identifier = "iconBackgroundTop"
        iconBackgroundTopAcnhor.isActive = true
        let iconBackgroundBottom = bottomAnchor.constraint(equalTo: iconBackgroundView.bottomAnchor)
        iconBackgroundBottom.identifier = "iconBackgroundBottom"
        iconBackgroundBottom.isActive = true
        let iconBackgroundWidth = iconBackgroundView.widthAnchor.constraint(equalTo: iconBackgroundView.heightAnchor)
        iconBackgroundWidth.identifier = "iconBackgroundWidth"
        iconBackgroundWidth.isActive = true
    }
    
    private func setIconConstraints() {
        
        let padding: CGFloat = 4
        let squareSide = (size * sqrt(2) * 0.5) - padding
        
        setElementConstraint(container: iconImageView, anchor: iconImageView.widthAnchor, constant: squareSide, identifier: "iconWidth")
        setElementConstraint(container: iconBackgroundView,
                             firstAnchor: iconImageView.centerXAnchor,
                             secondAnchor: iconBackgroundView.centerXAnchor,
                             identifier: "iconCenterX")
        
        setElementConstraint(container: iconImageView, anchor: iconImageView.heightAnchor, constant: squareSide, identifier: "iconHeight")
        setElementConstraint(container: iconBackgroundView,
                             firstAnchor: iconImageView.centerYAnchor,
                             secondAnchor: iconBackgroundView.centerYAnchor,
                             identifier: "iconCenterY")
    }
    
    /// Sets and updates the horizontal constraints according to the current sticky side.
    private func setupSideConstraints() {
        
        guard stickySide == .left else {
            // stick to the right
            stackElementsToTheRight()
            return
        }
        
        // stick to the left
        stackElementsToTheLeft()
    }
    
    /// Stacks elements on the left side.
    private func stackElementsToTheLeft() {
        // icon background view
        let stickyButtonCircleRadius = (stickyButton?.frame.width ?? size) * 0.5
        setElementConstraint(container: self,
                             firstAnchor: iconBackgroundView.centerXAnchor,
                             secondAnchor: leadingAnchor,
                             constant: stickyButtonCircleRadius,
                             identifier: "iconBackgroundCenterX")
        // title leading
        setElementConstraint(container: self,
                             firstAnchor: titleBackgroundView.leadingAnchor,
                             secondAnchor: iconBackgroundView.trailingAnchor,
                             constant: titleOffset,
                             identifier: "titleBackgroundOffset")
        // title trailing
        setElementConstraint(container: self,
                             firstAnchor: trailingAnchor,
                             secondAnchor: titleBackgroundView.trailingAnchor,
                             constant: 0,
                             identifier: "titleBackgroundDistanceFromEdge",
                             priority: .defaultHigh,
                             operation: ">=")
    }
    
    /// Stacks elements on the right side.
    private func stackElementsToTheRight() {
        // button
        let stickyButtonCircleRadius = (stickyButton?.frame.width ?? size) * 0.5
        setElementConstraint(container: self,
                             firstAnchor: trailingAnchor,
                             secondAnchor: iconBackgroundView.centerXAnchor,
                             constant: stickyButtonCircleRadius,
                             identifier: "iconBackgroundCenterX")
        // title trailing
        setElementConstraint(container: self,
                             firstAnchor: iconBackgroundView.leadingAnchor,
                             secondAnchor: titleBackgroundView.trailingAnchor,
                             constant: titleOffset,
                             identifier: "titleBackgroundOffset")
        // title leading
        setElementConstraint(container: self,
                             firstAnchor: titleBackgroundView.leadingAnchor,
                             secondAnchor: leadingAnchor,
                             constant: 0,
                             identifier: "titleBackgroundDistanceFromEdge",
                             priority: .defaultHigh,
                             operation: ">=")
    }
    
    /// Called when the sticky button was dragged to a different side.
    open func stickySideChanged() {
        setupSideConstraints()
    }
    
    // MARK: - UI
    
    /// Update the title label font.
    private func titleFontChanged() {
        // make sure the font name and size are correct
        guard let font = UIFont(name: titleFontName, size: titleFontSize) else { return }
        // update the font
        titleLabel.font = font
        setNeedsLayout()
    }
    
    // MARK: - Touch
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // select
        setHighlighted()
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // deselect
        setUnhighlighted()
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // deselect
        setUnhighlighted()
        
        if touches.count == 1, touches.first!.tapCount == 1 {
            stickyButton?.hideMenu()
            handler?(self)
        }
    }
    
    // MARK: - Highlight
    
    /// Set the item in a highlighted state.
    private func setHighlighted() {
        highlightedIconShape.fillColor = UIColor.white.withAlphaComponent(0.7).cgColor
        if title != nil { highlightedTitleShape.fillColor = UIColor.white.withAlphaComponent(0.7).cgColor }
    }
    
    /// Set the item in a normal state (unhighlights).
    private func setUnhighlighted() {
        highlightedIconShape.fillColor = UIColor.clear.cgColor
        highlightedTitleShape.fillColor = UIColor.clear.cgColor
    }
    
    // MARK: - Helpers
    
    /// Sets or updates an existing constraint according to the new params.
    ///
    /// - Parameter container: The element which contains the constraint to update.
    /// - Parameter firstAnchor: The first element's acnhor.
    /// - Parameter secondAnchor: The first element's acnhor.
    /// - Parameter constant: The constant of the constraint.
    /// - Parameter identifier: A unique `String` identifier.
    /// - Parameter priority: The priority of the constarint. By default it's set to `UILayoutPriority.required`.
    /// - Parameter operation: A string representing the comparison operator. Possible values are `"=="`, `"<="` and `">="`.
    private func setElementConstraint<T: AnyObject>(container: AnyObject,
                                                    firstAnchor: NSLayoutAnchor<T>,
                                                    secondAnchor: NSLayoutAnchor<T>,
                                                    constant: CGFloat = 0,
                                                    identifier: String,
                                                    priority: UILayoutPriority = .required,
                                                    operation: String = "==") {
        
        if let constraint = container.constraints?.filter({ $0.identifier == identifier }).first {
            container.removeConstraint(constraint)
        }
        
        var constraint: NSLayoutConstraint?
        switch operation {
        case "==": constraint = firstAnchor.constraint(equalTo: secondAnchor, constant: constant)
        case "<=": constraint = firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: constant)
        case ">=": constraint = firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: constant)
        default: break
        }
        
        guard let aConstraint = constraint else { return }
        aConstraint.priority = priority
        aConstraint.identifier = identifier
        aConstraint.isActive = true
    }
    
    /// Sets or updates an existing constraint according to the new params.
    ///
    /// - Parameter container: The element which contains the constraint to update.
    /// - Parameter firstAnchor: The element's acnhor.
    /// - Parameter constant: The constant of the constraint.
    /// - Parameter identifier: A unique `String` identifier.
    /// - Parameter priority: The priority of the constarint. By default it's set to `UILayoutPriority.required`.
    /// - Parameter operation: A string representing the comparison operator. Possible values are `"=="`, `"<="` and `">="`.
    private func setElementConstraint(container: AnyObject,
                                      anchor: NSLayoutDimension,
                                      constant: CGFloat,
                                      identifier: String,
                                      priority: UILayoutPriority = .required,
                                      operation: String = "==") {
        
        if let constraint = container.constraints?.filter({ $0.identifier == identifier }).first {
            container.removeConstraint(constraint)
        }
        
        var constraint: NSLayoutConstraint?
        switch operation {
        case "==": constraint = anchor.constraint(equalToConstant: constant)
        case "<=": constraint = anchor.constraint(lessThanOrEqualToConstant: constant)
        case ">=": constraint = anchor.constraint(greaterThanOrEqualToConstant: constant)
        default: break
        }
        
        guard let aConstraint = constraint else { return }
        aConstraint.priority = priority
        aConstraint.identifier = identifier
        aConstraint.isActive = true
    }
    
    /// Returns a frame of the tappable area according to the title length and the `tapAreaPadding` property.
    open func tapArea() -> CGRect {
        let padding = tapAreaPadding
        guard title != nil else {
            return CGRect(x: iconBackgroundView.frame.minX - padding, y: 0, width: size + 2 * padding, height: size)
        }
        
        let x = stickySide == .left ? iconBackgroundView.frame.minX - padding : titleBackgroundView.frame.minX - padding
        var width = titleBackgroundView.frame.maxX - iconBackgroundView.frame.minX + 2 * padding
        width = stickySide == .right ? iconBackgroundView.frame.maxX - titleBackgroundView.frame.minX + 2 * padding : width
        
        return CGRect(x: x, y: 0, width: width, height: size)
    }
}

// MARK: - Accessibility Handling

extension StickyButtonItem {
    
    /// Sets the accessibility properties of the item.
    internal func setupAccessibility() {
        // item's accessibility
        isAccessibilityElement = true
        accessibilityLabel = title
        accessibilityTraits.insert(.button)
        // excluded
        titleLabel.isAccessibilityElement = false
        iconImageView.isAccessibilityElement = false
        // UI testing
        accessibilityIdentifier = title
    }
    
    /// Update the item's accessibility frames.
    internal func updateItemAccessibility() {
        guard let superview = superview else { return }
        let tapArea = self.tapArea()
        let point = frame.origin + CGPoint(x: tapArea.minX, y: 0)
        let aFrame = CGRect(origin: point, size: tapArea.size)
        accessibilityFrame = superview.convert(aFrame, to: nil)
    }
}
