#if os(iOS) || os(tvOS)
import UIKit
typealias View = UIView
extension View {
    var snp_constraints: [AnyObject] { return self.constraints }
}
#else
import AppKit
typealias View = NSView
extension View {
    var snp_constraints: [AnyObject] { return self.constraints }
}
#endif

import XCTest
@testable import SnapKit

class SnapKitTests: XCTestCase {
    
    let container = View()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLayoutGuideConstraints() {
        #if os(iOS) || os(tvOS)
            let vc = UIViewController()
            vc.view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            
            vc.view.addSubview(self.container)
            
            self.container.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(vc.topLayoutGuide.snp.bottom)
                make.bottom.equalTo(vc.bottomLayoutGuide.snp.top)
            }
            
            print(vc.view.snp_constraints)
            
            XCTAssertEqual(vc.view.snp_constraints.count, 6, "Should have 6 constraints installed")
        #endif
    }
    
    func testMakeConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(v2.snp.top).offset(50)
            make.left.equalTo(v2.snp.top).offset(50)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v2.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(v1)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 6, "Should have 6 constraints installed")
        
    }
    
    func testMakeImpliedSuperviewConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(50.0)
            make.left.equalTo(50.0)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v2.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(v1)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 6, "Should have 6 constraints installed")
    }
    
    func testUpdateConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(v2.snp.top).offset(50)
            make.left.equalTo(v2.snp.top).offset(50)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v1.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(v2.snp.top).offset(15)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should still have 2 constraints installed")
        
    }
    
    func testRemakeConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(v2.snp.top).offset(50)
            make.left.equalTo(v2.snp.top).offset(50)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v1.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(v2)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 4 constraints installed")
        
    }
    
    func testRemoveConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        v1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(v2.snp.top).offset(50)
            make.left.equalTo(v2.snp.top).offset(50)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints installed")
        
        v1.snp.removeConstraints()
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
    }
    
    func testPrepareConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        let constraints = v1.snp.prepareConstraints { (make) -> Void in
            make.edges.equalTo(v2)
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
        for constraint in constraints {
            constraint.activate()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 4 constraints installed")
        
        for constraint in constraints {
            constraint.deactivate()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
    }
    
    func testReactivateConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        let constraints = v1.snp.prepareConstraints { (make) -> Void in
            make.edges.equalTo(v2)
            return
        }
        
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
        
        for constraint in constraints {
            constraint.activate()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 4 constraints installed")
        
        for constraint in constraints {
            constraint.deactivate()
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints installed")
    }
    
    func testActivateDeactivateConstraints() {
        let v1 = View()
        let v2 = View()
        self.container.addSubview(v1)
        self.container.addSubview(v2)
        
        var c1: Constraint? = nil
        var c2: Constraint? = nil
        
        v1.snp.prepareConstraints { (make) -> Void in
            c1 = make.top.equalTo(v2.snp.top).offset(50).constraint
            c2 = make.left.equalTo(v2.snp.top).offset(50).constraint
            return
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints")
        
        c1?.activate()
        c2?.activate()
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints")
        
        c1?.deactivate()
        c2?.deactivate()
        
        XCTAssertEqual(self.container.snp_constraints.count, 0, "Should have 0 constraints")
        
        c1?.activate()
        c2?.activate()
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints")
        
    }
    
    func testEdgeConstraints() {
        let view = View()
        self.container.addSubview(view)
        
        view.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.container).offset(50.0)
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 4, "Should have 4 constraints")
        
        
        let constraints = self.container.snp_constraints as! [NSLayoutConstraint]
        
        XCTAssertEqual(constraints[0].constant, 50, "Should be 50")
        XCTAssertEqual(constraints[1].constant, 50, "Should be 50")
        XCTAssertEqual(constraints[2].constant, 50, "Should be 50")
        XCTAssertEqual(constraints[3].constant, 50, "Should be 50")
    }
    
    func testSizeConstraints() {
        let view = View()
        self.container.addSubview(view)
        
        view.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.left.top.equalTo(self.container)
        }
        
        XCTAssertEqual(view.snp_constraints.count, 2, "Should have 2 constraints")
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints")
        
        let constraints = view.snp_constraints as! [NSLayoutConstraint]

        // no guarantee which order the constraints are in, but we should test their couple
        let widthHeight = (NSLayoutAttribute.width.rawValue, NSLayoutAttribute.height.rawValue)
        let heightWidth = (widthHeight.1, widthHeight.0)
        let firstSecond = (constraints[0].firstAttribute.rawValue, constraints[1].firstAttribute.rawValue)

        // constraint values are correct in either width, height or height, width order
        XCTAssertTrue(firstSecond == widthHeight || firstSecond == heightWidth, "2 contraint values should match")
        XCTAssertEqual(constraints[0].constant, 50, "Should be 50")
        XCTAssertEqual(constraints[1].constant, 50, "Should be 50")
    }
    
    func testCenterConstraints() {
        let view = View()
        self.container.addSubview(view)
        
        view.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.container).offset(50.0)
        }
        
        XCTAssertEqual(self.container.snp_constraints.count, 2, "Should have 2 constraints")
        
        
        let constraints = self.container.snp_constraints as! [NSLayoutConstraint]
        
        XCTAssertEqual(constraints[0].constant, 50, "Should be 50")
        XCTAssertEqual(constraints[1].constant, 50, "Should be 50")
    }
    
    func testConstraintIdentifier() {
        let identifier = "Test-Identifier"
        let view = View()
        self.container.addSubview(view)
        
        view.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.container.snp.top).labeled(identifier)
        }
        
        let constraints = container.snp_constraints as! [NSLayoutConstraint]
        XCTAssertEqual(constraints[0].identifier, identifier, "Identifier should be 'Test'")
    }
    
}
