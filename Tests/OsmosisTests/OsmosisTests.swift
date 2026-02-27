import XCTest
@testable import Osmosis

final class OsmosisTests: XCTestCase {

    func testOsmosisInit() {
        let osmosis = Osmosis()
        XCTAssertNotNil(osmosis)
    }

    func testOsmosisSelector() {
        let selector = OsmosisSelector(selector: "h1")
        XCTAssertEqual(selector.selector, "h1")
        XCTAssertNil(selector.attribute)
    }

    func testOsmosisSelectorWithAttribute() {
        let selector = OsmosisSelector(selector: "a", attribute: "href")
        XCTAssertEqual(selector.selector, "a")
        XCTAssertEqual(selector.attribute, "href")
    }

    func testPopulateKeyHashable() {
        let key1 = OsmosisPopulateKey.Single("title")
        let key2 = OsmosisPopulateKey.Single("title")
        let key3 = OsmosisPopulateKey.Array("items")
        XCTAssertEqual(key1, key2)
        XCTAssertNotEqual(key1, key3)
    }

    func testLoadOperation() {
        let expectation = self.expectation(description: "load completes")
        let html = "<html><body><h1>Hello</h1></body></html>"
        guard let data = html.data(using: .utf8) else {
            XCTFail("Failed to create data")
            return
        }

        // load sets the starting node to html.body, then populate searches within it
        Osmosis()
            .load(html: data, encoding: .utf8)
            .populate(dict: [.Single("title"): OsmosisSelector(selector: "h1")])
            .list { dict in
                XCTAssertEqual(dict["title"] as? String, "Hello")
                expectation.fulfill()
            }
            .start()

        waitForExpectations(timeout: 5)
    }
}
