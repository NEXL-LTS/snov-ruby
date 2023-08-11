module SupportedJobAttributes
  extend ActiveSupport::Concern

  included do
    cattr_accessor :supported_fields

    self.supported_fields = ['company_name', 'position', 'social_link', 'site', 'locality', 'state', 'city',
                             'street', 'street2', 'postal', 'founded', 'start_date', 'end_date', 'size',
                             'industry', 'company_type', 'country', 'hq_phone']

    supported_fields.each { |attr| attr_accessor(attr) }
  end

  def initialize(hash)
    supported_fields.each { |f| public_send("#{f}=", hash[f]) }
  end
end
