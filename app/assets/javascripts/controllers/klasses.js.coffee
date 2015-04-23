@['klasses#index'] = (data) ->
  $('.js-build-repo').on 'ajax:success', (e, data) ->
    showRebuildProgress(data)

@['klasses#show'] = (data) ->
  $('pre code').each (i, block) ->
    hljs.highlightBlock(block)
    hljs.lineNumbers(block)

  $('.shiplix-source').each (index) ->
    $source = $(this)
    grouped_smells = $source.data('smells')

    for own type, smells of grouped_smells
      for smell in smells
        line_cont = $source.find('.js-index-' + smell.line)

        line_cont.after(
          JST['smells/message'](name: smell.name, text: smell.message, icon: smell.icon)
        )
