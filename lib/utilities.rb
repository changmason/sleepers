module Utilities
  def self.uuid_regex
    @uuid_regex ||= /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\Z/
  end
end