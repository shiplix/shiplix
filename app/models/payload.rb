require 'json'

class Payload
  pattr_initialize :agent, :unparsed_data

  def data
    @data ||= JSON.parse(unparsed_data).with_indifderent_access
  end


end
