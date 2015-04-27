hljs.insertSmells = (block, groupedSmells) ->
  $block = $(block)
  groupedSmells = $block.data('smells')

  for own type, smells of groupedSmells
    for smell in smells
      line_cont = $block.find('.js-index-' + smell.line)

      line_cont.after(
        JST['smells/message'](name: smell.name, text: smell.message, icon: smell.icon)
      )