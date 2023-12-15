/// Generates a public initializer for struct or class.
///
/// Example:
///
///   @Init(defaults: [:], wildcards: [], public: true)
///   public final class Employee {
///       let name: String
///       let yearOfExperiance: Int
///       let isIndian: Bool?
///   }
///
/// produces
///
///    public final class Employee {
///        let name: String
///        let yearOfExperiance: Int
///        let isIndian: Double?
///
///
///        public init(
///            name: String
///            yearOfExperiance: Int,
///            isIndian: Bool?,
///
///        ) {
///            self.name = name
///            self.yearOfExperiance = yearOfExperiance
///            self.isIndian = isIndian
///        }
///    }
///
///    - Parameters:
///      - defaults: Dictionary containing defaults for the specificed properties.
///      - wildcards: Array containing the specificed properties that should be wildcards.
///      - public: The flag to indicate if the init is public or not.
@attached(member, names: named(init))
public macro Init(
    defaults: [String: Any] = [:],
    wildcards: [String] = [],
    public: Bool = true
) = #externalMacro(
    module: "StructClassInitializerMacros",
    type: "InitMacro"
)
