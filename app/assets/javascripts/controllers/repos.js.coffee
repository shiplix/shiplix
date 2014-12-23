@['repos#index'] = (data) ->
  $('.js-refresh-repos').on 'ajax:success', (e, data, status, xhr) ->
    $('#js-progressbar').progressBar
      url: '/jobs'
      pid: data.meta_id
      form: 'load'
      onEnable: ->
        $('#js-progress-dialog').modal
          keyboard: false
      onSuccess: (data) ->
        location.reload()
      onError: (data) ->
        alert('Error in refreshing repos')

  $('.js-repo-activate').on 'ajax:success', (e, data, status, xhr) ->
    $('#js-progressbar').progressBar
      url: '/jobs'
      pid: data.meta_id
      form: 'load'
      onEnable: ->
        $('#js-progress-dialog').modal
          keyboard: false
      onSuccess: (data) ->
        location.reload()
      onError: (data) ->
        alert('Error in activating repo')