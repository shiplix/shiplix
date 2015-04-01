this.showRebuildProgress = (data) ->
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
