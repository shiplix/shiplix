hljs.insertSmells = (block) ->
  $block = $(block)
  smells = $block.data('smells')

  for smell in smells
    line_cont = $block.find('.js-index-' + smell.line)

    line_cont.after(
      JST['smells/message'](name: smell.name, text: smell.message, icon: smell.icon)
    )
