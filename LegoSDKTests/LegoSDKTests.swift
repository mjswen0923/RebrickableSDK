@testable import LegoSDK
import XCTest
import Swifter
import Combine

class LegoAPITests: UnitTestCase {
    private let legoApi = LegoAPI(apiKey: "262a544a78e1cbca7f70541ce6e6bc2c")
    private var bag = Set<AnyCancellable>()

    func testGetLegoColors() throws {
        try getTest(mock: LegoColors.mock(),
                    endpoint: "/colors",
                    publisher: legoApi.getLegoColors())
    }

    func testGetLegoColor() throws {
        try getTest(mock: LegoColor.mock(),
                    endpoint: "/colors",
                    publisher: legoApi.getLegoColor(with: 1))
    }

    func testGetLegoElement() throws {
        try getTest(mock: LegoElement.mock(),
                    endpoint: "/elements",
                    publisher: legoApi.getLegoElement(with: "6099483"))
    }

    func testGetLegoMinifigures() throws {
        try getTest(mock: LegoSets.mock(),
                    endpoint: "/minifigs",
                    publisher: legoApi.getLegoMinifigures())
    }

    func testGetLegoMinifigureWithSetNum() throws {
        try getTest(mock: LegoSet.mock(),
                    endpoint: "/minifigs",
                    publisher: legoApi.getLegoMinifigureDetails(with: "fig-000001"))
    }

    func testGetLegoMinifigureParts() throws {
        try getTest(mock: LegoInventoryParts.mock(),
                    endpoint: "/parts",
                    publisher: legoApi.getLegoMinifigureParts(with: "fig-000001"))
    }

    func testGetLegoMinifigureSets() throws {
        try getTest(mock: LegoSets.mock(),
                    endpoint: "/sets",
                    publisher: legoApi.getLegoSets(with: "fig-000001"))
    }

    func testGetLegoPartCategories() throws {
        try getTest(mock: LegoPartCategories.mock(),
                    endpoint: "/elements",
                    publisher: legoApi.getLegoPartCategories())
    }

    func testGetLegoPartCategoriesWithId() throws {
        try getTest(mock: LegoPartCategory.mock(),
                    endpoint: "/elements",
                    publisher: legoApi.getLegoPartCategory(with: 49))
    }

    func testGetLegoParts() throws {
        try getTest(mock: LegoParts.mock(),
                    endpoint: "/parts",
                    publisher: legoApi.getLegoParts())
    }

    func testGetLegoPartWithId() throws {
        try getTest(mock: LegoPart.mock(),
                    endpoint: "/parts",
                    publisher: legoApi.getLegoPart(with: "39381"))
    }

    func testGetLegoPartColorsWithPartNum() throws {
        try getTest(mock: LegoPartColors.mock(),
                    endpoint: "/colors",
                    publisher: legoApi.getPartColors(with: "003381"))
    }

    func testGetLegoPartsWitPartAndColor() throws {
        try getTest(mock: LegoSets.mock(),
                    endpoint: "/sets",
                    publisher: legoApi.getSets(partNum: "003381", colorID: "9999"))
    }

    func testGetLegoSets() throws {
        try getTest(mock: LegoSets.mock(),
                    endpoint: "/sets",
                    publisher: legoApi.getLegoSets())
    }

    func testGetLegoSet() throws {
        try getTest(mock: LegoSet.mock(),
                    endpoint: "/sets",
                    publisher: legoApi.getLegoSet(with: "0011-2"))
    }

    func testGetLegoInventoryMinifigsWithSetNum() throws {
        try getTest(mock: LegoInventorySets.mock(),
                    endpoint: "/minifigs",
                    publisher: legoApi.getLegoInventoryMinifigs(with: "0011-2"))
    }

    func testGetLegoInventoryPartsWithSetNum() throws {
        try getTest(mock: LegoInventoryParts.mock(),
                    endpoint: "/parts",
                    publisher: legoApi.getLegoInventoryParts(with: "76139-1"))
    }

    func testGetLegoThemes() throws {
        try getTest(mock: LegoThemes.mock(),
                    endpoint: "/themes",
                    publisher: legoApi.getLegoThemes())
    }

    func testGetLegoThemeWithId() throws {
        try getTest(mock: LegoTheme.mock(),
                    endpoint: "/themes",
                    publisher: legoApi.getLegoTheme(with: 1))
    }
}

extension LegoAPITests {
    func getTest<T: Codable>(mock: T, endpoint: String, publisher: AnyPublisher<T, LegoError>) throws {
        let exp1 = expectation(description: "receiveCompletion")
        let exp2 = expectation(description: "receiveValue")

        try httpServerBuilder
            .route(endpoint, { (request, callCount) -> (HttpResponse) in
                XCTAssertEqual(request.method, APIManager.HttpMethod.get.rawValue)
                XCTAssertEqual(callCount, 1)
                return HttpResponse.encode(value: LegoParts.mock())
            })
            .buildAndStart()

        publisher
            .sink(receiveCompletion: { _ in exp1.fulfill() },
                  receiveValue: { _ in exp2.fulfill() })
            .store(in: &bag)

        waitForExpectations(timeout: 3) { (error) in
            print("Error:\(String(describing: error))")
        }
    }
}
