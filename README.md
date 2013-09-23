Helper functions for working with the LiveScript compiler from your `Slakefile`. Work in progress, currently offering two functions (`lsc` and `compile`) with a promise-based API.

Future functions will likely include `compileDir` and `compileTree`.

Installation and usage
======================

Installation: `npm install git://github.com/PPvG/node-slake-lsc.git`. It may be published on npm in the future, probably as `slake-lsc`.

Usage: simply require it at the top of your `Slakefile`. The helpers have a promise-based API:

    lsc = require \slake-lsc

    task \build ->
      files = [\src/app.ls, \src/helper.ls]
      result = lsc.compile bare:true, output:\./lib, files
      result.then ->
        console.log 'Build successful:', files
      result.otherwise (e) ->
        console.log 'Build failed:', e
        process.exit 1

API
===

`lsc`
-----

Spawn the LiveScript compiler as a child process. This function takes an array of arguments, which are passed verbatim to the child process. E.g.:

    lsc = require `slake-lsc`
    lsc.lsc [\-cbo, \./lib, \./src/1.ls, \./src/2.ls]

It returns a [promise][when].

  [when]: https://github.com/cujojs/when

`compile`
---------

Compile separate source file(s) to JS. Uses the `lsc` function internally and returns the same promise. It optionally takes an `opts` object as its first argument.

    lsc.compile([opts], file, [...files])

Available options are 'b' (or 'bare') and 'o' (or 'output'). File args can
be arrays, which will be flattened:

    lsc.compile bare:true, o:'lib/', 'src/1.ls', ['src/2.ls', src/3.ls']
