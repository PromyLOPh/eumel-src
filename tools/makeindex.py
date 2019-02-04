#!/usr/bin/env python3
# vim: set fileencoding=utf8 :

"""
Create package index
"""

if __name__ == '__main__':
    import os
    from operator import itemgetter
    from itertools import groupby
    from yarl import URL

    pkgs = {}

    for dirpath, dirnames, filenames in os.walk ('.'):
        dirs = dirpath.split (os.sep)
        if len (dirs) < 4:
            continue

        cat = dirs[1]
        if cat not in {'app', 'devel', 'doc', 'lang', 'system'}:
            continue
        pkg = dirs[2]
        ver = dirs[3]

        i = (cat, pkg, ver)
        pkgs.setdefault (i, [])

        for f in filenames:
            # not highlighting anything else currently (doc for example)
            if dirs[-1] == 'src':
                pkgs[i].append (os.path.join (*dirs[4:], f))

    for cat, pkgs in groupby (sorted (pkgs.items(), key=itemgetter(0)), key=lambda x: x[0][0]):
        print (f'{cat}\n{"^"*len(cat)}\n')
        for (cat, pkg, ver), files in pkgs:
            heading = f'{pkg}-{ver}'
            print (f'\n{heading}\n{"*"*len(heading)}\n')
            disklist = os.path.join (cat, pkg, ver, 'source-disk')
            if os.path.exists (disklist):
                with open (disklist) as fd:
                    diskfiles = [x.strip() for x in fd.readlines ()]
                    assert all (map (lambda x: os.path.isfile (os.path.join ('..', 'disks', x)), diskfiles)), diskfiles
                    disks = map (lambda x: URL('../disks/' + x.split('/')[0] + '.zip'), diskfiles)
                print ('Source disk: ')
                print (',\n'.join (map (lambda x: f'`{x[0]} <{x[1].raw_path}>`__', enumerate (disks, 1))))
                print ('')
            for f in sorted (files, key=lambda x: x.lower()):
                u = URL (f'{cat}/{pkg}/{ver}/{f}.html')
                print (f'- `{f} <{u.raw_path}>`__')
        print ('')

