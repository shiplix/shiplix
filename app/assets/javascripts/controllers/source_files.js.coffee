@['source_files#index'] = (data) ->
  $('.js-build-repo').on 'ajax:success', (e, data) ->
    showRebuildProgress(data)
