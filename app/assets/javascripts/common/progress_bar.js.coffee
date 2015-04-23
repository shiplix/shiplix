this.renderProgresBarContainer = (options) ->
  unless $('#js-' + options.id + '-progressbar').length
    $('body').append JST['progress_bar'](options)

this.showRebuildProgress = (data) ->
  renderProgresBarContainer
    id: 'refreshing',
    type: 'info',
    title: 'Rebuild'

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
