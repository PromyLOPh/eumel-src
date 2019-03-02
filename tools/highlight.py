#!/usr/bin/env python3
# vim: set fileencoding=utf8 :

"""
Highlight elan source file
"""

if __name__ == '__main__':
    import sys, os, shutil
    from pygments import highlight
    from pygments.lexers import get_lexer_by_name
    from pygments.formatters import HtmlFormatter
    from jinja2 import Template

    tpl = Template("""<!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
      <link rel="stylesheet" href="/style.min.css" type="text/css" />
      <title>{{ path }}</title>
      <style>
      body {
            max-width: none;
      }
      </style>
    </head>
    <body>
    <h1>{{ path }}</h1>
    <p><a href="{{ rawfile }}">Raw file</a><br><a href="{{ index }}">Back to index</a></p>
    {{ code|safe }}
    </body></html>""")

    destdir = '_build'
    f = sys.argv[1]

    basedir = os.path.dirname (f)
    basedestdir = os.path.join (destdir, basedir)
    os.makedirs (basedestdir, exist_ok=True)
    shutil.copy (f, os.path.join (destdir, f))
    destf = os.path.join (destdir, f + '.html')

    try:
        with open (f, 'r') as srcfd:
            code = srcfd.read ()
    except UnicodeDecodeError as e:
        # that’s expected for data files
        print ('skipping', f, e)
        sys.exit (0)

    print (f)
    lexer = get_lexer_by_name("elan", stripall=True)
    formatter = HtmlFormatter (linenos=True, lineanchors='line', anchorlinenos=True)
    with open (destf, 'w') as destfd:
        tpl.stream(code=highlight(code, lexer, formatter), path=f, rawfile=os.path.basename (f), index=os.path.relpath ('.', os.path.dirname (f))).dump (destfd)

