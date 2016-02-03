module Owners
  class User < Owner
    belongs_to :user, class_name: "User", foreign_key: :name, primary_key: :name
  end
end
