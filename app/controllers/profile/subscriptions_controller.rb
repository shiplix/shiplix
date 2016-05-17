module Profile
  class SubscriptionsController < ::ApplicationController
    def new
      @owner = resource_owner
      return render_error(404) if @owner.nil?

      @plans = Plan.active
      @subscription_type = PlanSubscriptionType.new(plan_id: @owner.plan&.id)
    end

    def create
      @owner = resource_owner
      return render_error(404) if @owner.nil?

      @plans = Plan.active
      @subscription_type = PlanSubscriptionType.new(params[PlanSubscriptionType.model_name.param_key])

      if @subscription_type.valid?
        Owners::SubscribeToPlan.call!(
          owner: @owner,
          card_token: @subscription_type.token,
          plan: @subscription_type.plan
        )

        flash[:success] = "Success"
        redirect_to new_profile_billing_subscription_url
      else
        render :new
      end
    end

    private

    def resource_owner
      OwnersFinder.new(current_user).call.find { |o| o.name == params[:billing_id] }
    end
  end
end
