class Parxer::Error < RuntimeError; end
class Parxer::ParsedItemError < Parxer::Error; end
class Parxer::ValidatorError < Parxer::Error; end
