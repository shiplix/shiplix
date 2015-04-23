@['repos#index'] = (data) ->
  $('.js-refresh-repos').on 'ajax:success', (e, data, status, xhr) ->
    renderProgresBarContainer
      id: 'refreshing',
      type: 'info',
      title: 'Refreshing repositories'

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
    renderProgresBarContainer
      id: 'activating',
      type: 'success',
      title: 'Activating repository'

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

  $('.js-repo-deactivate').on 'ajax:success', (e, data, status, xhr) ->
    renderProgresBarContainer
      id: 'deactivating',
      type: 'danger',
      title: 'Deactivating repository'

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

