tmplRe = /<%=\s*([^\s]*?)\s*%>/g
@Utils =
  tmplFn: (str, obj) ->
    while (m = tmplRe.exec(str)) != null
      replacee = m[0]
      key = m[1]
      if (obj[key]?)
        str = str.replace(replacee, obj[key])
    return str
