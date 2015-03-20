@['klasses#index'] = (data) ->
  $('.js-build-repo').on 'ajax:success', (e, data, status, xhr) ->
    $('#js-refreshing-progressbar').progressBar
      url: '/jobs'
      pid: data.meta_id
      form: 'load'
      onEnable: ->
        $('#js-refreshing-dialog').modal()
      onSuccess: (data) ->
        location.reload()
      onError: (data) ->
        alert('Error in refreshing repository')
