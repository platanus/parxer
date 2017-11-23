class Parxer::Error < RuntimeError; end
class Parxer::ParserError < Parxer::Error; end
class Parxer::ParsedItemError < Parxer::Error; end
class Parxer::ValidatorError < Parxer::Error; end
class Parxer::XlsDslError < Parxer::Error; end
class Parxer::AttributesError < Parxer::Error; end
