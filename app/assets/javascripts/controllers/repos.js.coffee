@['repos#index'] = (data) ->
  $('.js-refresh-repos').on 'ajax:success', (e, data, status, xhr) ->
    $('#js-refreshing-progressbar').progressBar
      url: '/jobs'
      pid: data.meta_id
      form: 'load'
      onEnable: ->
        $('#js-refreshing-dialog').modal()
      onSuccess: (data) ->
        location.reload()
      onError: (data) ->
        alert('Error in refreshing repositories')

  $('.js-repo-activate').on 'ajax:success', (e, data, status, xhr) ->
    $('#js-activating-progressbar').progressBar
      url: '/jobs'
      pid: data.meta_id
      form: 'load'
      onEnable: ->
        $('#js-activating-dialog').modal()
      onSuccess: (data) ->
        location.reload()
      onError: (data) ->
        alert('Error in activating repository')

  # Do not uncheck checkbox when confirmation canceled
  $('.js-repo-deactivate').on 'confirm:complete', (e, answer) ->
    if !answer
      e.target.checked = true
    answer

  $('.js-repo-deactivate').on 'ajax:success', (e, data, status, xhr) ->
    $('#js-deactivating-progressbar').progressBar
      url: '/jobs'
      pid: data.meta_id
      form: 'load'
      onEnable: ->
        $('#js-deactivating-dialog').modal()
      onSuccess: (data) ->
        location.reload()
      onError: (data) ->
        alert('Error in deactivating repository')

