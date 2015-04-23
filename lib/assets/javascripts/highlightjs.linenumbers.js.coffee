hljs.lineNumbers = (block) ->
  block = $(block)
  lineStart = parseInt(block.data('line-start'))
  lineStart = 1 if isNaN(lineStart)
  items = block.html().split("\n")
  total = items.length
  result = '<table>'

  for i in [0...total]
    index = lineStart + i
    result += '<tr class="js-index-' + index + '">'
    result += '<td class="line-number">' + index + '</td>'
    result += '<td class="source-row">' + items[i] + '</td>'
    result += '</tr>'

  result += '</table>';

  block.empty().append(result)
