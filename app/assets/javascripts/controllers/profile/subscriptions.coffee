@['profile/subscriptions#new'] = (data) ->
  $('.js-payment-form').on 'submit', (e)->
    $form = $(this)

    # Disable the submit button to prevent repeated clicks
    $button = $form.find('button')
    $button.prop('disabled', true)

    Stripe.card.createToken $form, (status, response)->
      if response.error
        $button.prop('disabled', false)
        $form.find('.js-payment-errors').text(response.error.message)
      else
        token = response.id
        $form.find('.js-token').val(token)
        $form.get(0).submit()

    return false
