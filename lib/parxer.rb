require "parxer/version"
require "require_all"
require "active_support/all"
require "roo"
require "roo-xls"

require_rel "parxer/utils/*.rb"
require_rel "parxer/collections/*.rb"
require_rel "parxer/formatters/*.rb"
require_rel "parxer/validators/*.rb"
require_rel "parxer/values/*.rb"
require_rel "parxer/dsl/*.rb"
require_rel "parxer/parsers/concerns/*.rb"
require_rel "parxer/parsers/*.rb"

module Parxer
end
