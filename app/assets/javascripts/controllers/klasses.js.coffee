@['klasses#index'] = (data) ->
  $('.js-build-repo').on 'ajax:success', (e, data) ->
    showRebuildProgress(data)

@['klasses#show'] = (data) ->
  $('pre code').each (index, block) ->
    hljs.highlightBlock(block)
    hljs.lineNumbers(block)
    hljs.insertSmells(block)
