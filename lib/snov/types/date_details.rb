module Snov
  module Types
    class DateDetails
      include ActiveModel::Model

      attr_accessor :date, :timezone_type, :timezone
    end
  end
end
