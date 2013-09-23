{flatten, is-type} = require \prelude-ls
{spawn} = require \child_process
{defer} = require \when
require! \path

lscPath = require.resolve \LiveScript/bin/lsc

module.exports = {lsc, compile}

# Compile separate source file(s) to JS.  The `lsc` command must be available.
# Returns a promise.
#
#     compile([opts], file, [...files])
#
# Available options are 'b' (or 'bare') and 'o' (or 'output'). File args can
# be arrays, which will be flattened:
#
#     compile bare:true, o:'lib/', 'src/1.ls', ['src/2.ls', src/3.ls']
#
function compile ...args
  promise = args |> incoming |> outgoing |> lsc
  return promise

  function incoming args
    opts = if is-type \Object, args[0] then args.shift! else {}
    if not args.length then throw new Error 'No filenames'
    {opts, files: flatten args}

  function outgoing {opts, files}
    args = []
    if opts.b or opts.bare then args.push \-b
    if opts.o || opts.output then args.push \-o, that
    [\-c] ++ args ++ files


# Spawns `lsc` as a child process. Args are passed verbatim.
# Returns a promise.
#
function lsc lscArgs
  stderrOutput = ''
  deferred = defer!

  process = spawn lscPath, lscArgs
  process.stderr.on \data, -> stderrOutput += it.toString!
  process.on \exit, (error) ->
    if stderrOutput.length > 0 then deferred.reject new Error stderrOutput
    else deferred.resolve!

  deferred.promise

