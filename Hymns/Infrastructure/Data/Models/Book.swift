/**
 * Raw value needs to be an Int to preserve the ordering of the books.
 */
enum Book: Int {
    case genesis
    case exodus
    case leviticus
    case numbers
    case deuteronomy
    case joshua
    case judges
    case ruth
    case firstSamuel
    case secondSamuel
    case firstKings
    case secondKings
    case firstChronicles
    case secondChronicles
    case ezra
    case nehemiah
    case esther
    case job
    case psalms
    case proverbs
    case ecclesiastes
    case songOfSongs
    case isaiah
    case jeremiah
    case lamentations
    case ezekiel
    case daniel
    case hosea
    case joel
    case amos
    case obadiah
    case jonah
    case micah
    case nahum
    case habakkuk
    case zephaniah
    case haggai
    case zechariah
    case malachi
    case matthew
    case mark
    case luke
    case john
    case acts
    case romans
    case firstCorinthians
    case secondCorinthians
    case galatians
    case ephesians
    case philippians
    case colossians
    case firstThessalonians
    case secondThessalonians
    case firstTimothy
    case secondTimothy
    case titus
    case philemon
    case hebrews
    case james
    case firstPeter
    case secondPeter
    case firstJohn
    case secondJohn
    case thirdJohn
    case jude
    case revelation
}

extension Book {

    var bookName: String {
        switch self {
        case .genesis: return "Genesis"
        case .exodus: return "Exodus"
        case .leviticus: return "Leviticus"
        case .numbers: return "Numbers"
        case .deuteronomy: return "Deuteronomy"
        case .joshua: return "Joshua"
        case .judges: return "Judges"
        case .ruth: return "Ruth"
        case .firstSamuel: return "1 Samuel"
        case .secondSamuel: return "2 Samuel"
        case .firstKings: return "1 Kings"
        case .secondKings: return "2 Kings"
        case .firstChronicles: return "1 Chronicles"
        case .secondChronicles: return "2 Chronicles"
        case .ezra: return "Ezra"
        case .nehemiah: return "Nehemiah"
        case .esther: return "Esther"
        case .job: return "Job"
        case .psalms: return "Psalms"
        case .proverbs: return "Proverbs"
        case .ecclesiastes: return "Ecclesiastes"
        case .songOfSongs: return "Song of Songs"
        case .isaiah: return "Isaiah"
        case .jeremiah: return "Jeremiah"
        case .lamentations: return "Lamentations"
        case .ezekiel: return "Ezekiel"
        case .daniel: return "Daniel"
        case .hosea: return "Hosea"
        case .joel: return "Joel"
        case .amos: return "Amos"
        case .obadiah: return "Obadiah"
        case .jonah: return "Jonah"
        case .micah: return "Micah"
        case .nahum: return "Nahum"
        case .habakkuk: return "Habakkuk"
        case .zephaniah: return "Zephaniah"
        case .haggai: return "Haggai"
        case .zechariah: return "Zechariah"
        case .malachi: return "Malachi"
        case .matthew: return "Matthew"
        case .mark: return "Mark"
        case .luke: return "Luke"
        case .john: return "John"
        case .acts: return "Acts"
        case .romans: return "Romans"
        case .firstCorinthians: return "1 Corinthians"
        case .secondCorinthians: return "2 Corinthians"
        case .galatians: return "Galatians"
        case .ephesians: return "Ephesians"
        case .philippians: return "Philippians"
        case .colossians: return "Colossians"
        case .firstThessalonians: return "1 Thessalonians"
        case .secondThessalonians: return "2 Thessalonians"
        case .firstTimothy: return "1 Timothy"
        case .secondTimothy: return "2 Timothy"
        case .titus: return "Titus"
        case .philemon: return "Philemon"
        case .hebrews: return "Hebrews"
        case .james: return "James"
        case .firstPeter: return "1 Peter"
        case .secondPeter: return "2 Peter"
        case .firstJohn: return "1 John"
        case .secondJohn: return "2 John"
        case .thirdJohn: return "3 John"
        case .jude: return "Jude"
        case .revelation: return "Revelation"
        }
    }

    // Can't reduce cyclomatic complexity here since the Bible has 67 books.
    // swiftlint:disable cyclomatic_complexity
    static func from(bookName: String) -> Book? {
        switch bookName {
        case "Genesis": return .genesis
        case "Exodus": return .exodus
        case "Leviticus": return .leviticus
        case "Numbers": return .numbers
        case "Deuteronomy": return .deuteronomy
        case "Joshua": return .joshua
        case "Judges": return .judges
        case "Ruth": return .ruth
        case "1 Samuel": return .firstSamuel
        case "2 Samuel": return .secondSamuel
        case "1 Kings": return .firstKings
        case "2 Kings": return .secondKings
        case "1 Chronicles": return .firstChronicles
        case "2 Chronicles": return .secondChronicles
        case "Ezra": return .ezra
        case "Nehemiah": return .nehemiah
        case "Esther": return .esther
        case "Job": return .job
        case "Psalms": return .psalms
        case "Proverbs": return .proverbs
        case "Ecclesiastes": return .ecclesiastes
        case "Song of Songs": return .songOfSongs
        case "Isaiah": return .isaiah
        case "Jeremiah": return .jeremiah
        case "Lamentations": return .lamentations
        case "Ezekiel": return .ezekiel
        case "Daniel": return .daniel
        case "Hosea": return .hosea
        case "Joel": return .joel
        case "Amos": return .amos
        case "Obadiah": return .obadiah
        case "Jonah": return .jonah
        case "Micah": return .micah
        case "Nahum": return .nahum
        case "Habakkuk": return .habakkuk
        case "Zephaniah": return .zephaniah
        case "Haggai": return .haggai
        case "Zechariah": return .zechariah
        case "Malachi": return .malachi
        case "Matthew": return .matthew
        case "Mark": return .mark
        case "Luke": return .luke
        case "John": return .john
        case "Acts": return .acts
        case "Romans": return .romans
        case "1 Corinthians": return .firstCorinthians
        case "2 Corinthians": return .secondCorinthians
        case "Galatians": return .galatians
        case "Ephesians": return .ephesians
        case "Philippians": return .philippians
        case "Colossians": return .colossians
        case "1 Thessalonians": return .firstThessalonians
        case "2 Thessalonians": return .secondThessalonians
        case "1 Timothy": return .firstTimothy
        case "2 Timothy": return .secondTimothy
        case "Titus": return .titus
        case "Philemon": return .philemon
        case "Hebrews": return .hebrews
        case "James": return .james
        case "1 Peter": return .firstPeter
        case "2 Peter": return .secondPeter
        case "1 John": return .firstJohn
        case "2 John": return .secondJohn
        case "3 John": return .thirdJohn
        case "Jude": return .jude
        case "Revelation": return .revelation
        default: return nil
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
