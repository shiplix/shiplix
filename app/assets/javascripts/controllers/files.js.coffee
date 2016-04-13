@['files#index'] = (data) ->
  $('.js-build-repo').on 'ajax:success', (e, data) ->
    showRebuildProgress(data)

  $('.js-change-branch').on 'change', (e) ->
    $this = $(this)
    window.location.href = $this.data('url').replace(':branch', $this.val())

@['files#show'] = (data) ->
  $('pre code').each (index, block) ->
    hljs.highlightBlock(block)
    hljs.lineNumbers(block)
    hljs.insertSmells(block)
