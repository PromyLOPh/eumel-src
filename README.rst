EUMEL source code
=================

Source code and documentation for the `EUMEL operating system`_. Most files
have been extracted from archive disks using `EUMEL utilities`_.

.. _EUMEL operating system: https://6xq.net/eumel/
.. _EUMEL utilities: https://github.com/PromyLOPh/eumel-tools

`This repository`_ is organized as follows:

.. _This repository: https://github.com/PromyLOPh/eumel-src

``<category>/<package>/<version>/{data,doc,src}``

*Category* is one of these:

app
    User applications
devel
    Developer tools, mainly for debugging the system
doc
    Documentation for EUMEL, not belonging to any package
lang
    Programming language support (BASIC, PROLOG, LISP, DYNAMO)
system
    System packages (base, printer, …)

*Package* is the software’s name (not to be confused by EUMEL’s packet
concept), *version* is the package’s version (sometimes a best-guess) and these
subdirectories may exist inside each version directory:

data
    Supplementary dataspaces
doc
    Documentation, usually EUMEL text files
src
    Source code, usually ELAN or assembly

.. contents::

Packages
--------

.. include:: _build/packages.rst

