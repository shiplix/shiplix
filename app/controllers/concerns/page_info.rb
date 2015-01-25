module PageInfo
  extend ActiveSupport::Concern

  included do
    attr_reader :last_error

    delegate :page_title,
             :page_header,
             :page_description,

             :title_variables,
             :title_variables=,

             :title_key,
             :title_key=,

             :header_key,
             :header_key=,

             :description_key,
             :description_key=,

             :custom_title=,
             :custom_header=,

             :title_postfix,

             :to => :page_info

    helper_method :page_title
    helper_method :page_header
    helper_method :page_description
    helper_method :title_key
    helper_method :header_key
    helper_method :description_key
  end

  def page_info
    @page_info ||= Meta.new(self)
  end

  def last_error?
    !!@last_error
  end
end
