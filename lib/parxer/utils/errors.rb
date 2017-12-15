class Parxer::Error < RuntimeError; end
class Parxer::ParserError < Parxer::Error; end
class Parxer::ItemError < Parxer::Error; end
class Parxer::ValidatorError < Parxer::Error; end
class Parxer::XlsDslError < Parxer::Error; end
class Parxer::AttributesError < Parxer::Error; end
class Parxer::FormatterError < Parxer::Error; end
class Parxer::ContextError < Parxer::Error; end
