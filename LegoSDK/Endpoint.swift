import Foundation

struct Endpoint {
    private static let scheme = "https://"
    private static let rebrickableHostName = "rebrickable.com"
    private static let apiLegoV3 = "/api/v3/lego"
    private static let baseUrl = scheme + rebrickableHostName + apiLegoV3

    static let token = baseUrl + "/_token//"
    static let colors = baseUrl + "/colors/"
    static let sets = baseUrl + "/sets/"
    static let minifigs = baseUrl + "/minifigs/"
    static let themes = baseUrl + "/themes/"
}
