@['blocks/namespaces#show'] = (data) ->
  $('pre code').each (index, block) ->
    hljs.highlightBlock(block)
    hljs.lineNumbers(block)
    hljs.insertSmells(block)
