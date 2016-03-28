# Find owners for user.
# Returns array of Owner records.
#
# Example:
#
#   OwnersFinder.new(current_user).call
#     => [<Owner>, <Owner>]
class OwnersFinder
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    user_owner = Owners::User.find_by(name: user.github_username)

    organizations.tap do |orgs|
      orgs << user_owner if user_owner.present?
    end
  end

  private

  def organizations
    logins = api.own_organizations.map { |org| org[:organization][:login] }
    Owners::Org.where(name: logins).to_a
  end

  def api
    GithubApi.new(user.access_token)
  end
end
