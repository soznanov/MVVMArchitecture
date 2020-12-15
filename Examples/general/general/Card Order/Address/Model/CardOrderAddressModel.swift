import Foundation

struct CardOrderAddressModel: Codable {
    /** address */
    var address: String?

    /** city */
    var city: String?

    /** Iso country code 3 */
    var country: String?

    /** postal code/zip code */
    var zip: String?

    init(address: String? = nil,
                city: String? = nil,
                country: String? = nil,
                zip: String? = nil
    ) {
        self.address = address
        self.city = city
        self.country = country
        self.zip = zip
    }

}
