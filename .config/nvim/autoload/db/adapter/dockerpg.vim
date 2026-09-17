" dadbod adapter: run psql *inside* a running Postgres Docker container.
"
" Connect with a `dockerpg://` URL:
"   dockerpg:///mydb                 auto-detect the container, db = mydb
"   dockerpg://postgres/mydb         db = mydb, connect as the default user
"   dockerpg://alice@postgres/mydb   connect as alice
"   dockerpg://pg17/mydb             container named (or id starting) pg17
"
" Container resolution order:
"   1. the host component of the URL, used verbatim as container name or id;
"   2. a running container literally named `postgres`;
"   3. the first running container whose name or image looks like Postgres
"      (postgres, pgvector, pg<NN>, ...).
" The Postgres user defaults to `postgres` (docker exec would otherwise run
" psql as root, which no image has as a role); the database defaults to the
" user.
"
" SQL is piped to psql over stdin, so only `filter` is implemented -- never
" `input`, which would hand psql a `-f` path that exists only on the host.

function! s:containers() abort
  let out = db#systemlist(['docker', 'ps', '--format', '{{.ID}}\t{{.Image}}\t{{.Names}}'])
  return filter(map(out, 'split(v:val, "\t")'), 'len(v:val) == 3')
endfunction

function! s:auto_container() abort
  let running = s:containers()
  for c in running
    if c[2] ==# 'postgres'
      return c[0]
    endif
  endfor
  for c in running
    if c[1] =~? '\v%(postgres|pgvector|pg[0-9])' || c[2] =~? 'postgres'
      return c[0]
    endif
  endfor
  return ''
endfunction

function! s:argv(url, interactive) abort
  let parsed = db#url#parse(a:url)
  let params = get(parsed, 'params', {})
  let container = empty(get(parsed, 'host', '')) ? s:auto_container() : parsed.host
  if empty(container)
    throw 'DB: no running Postgres container found (dockerpg://)'
  endif
  let argv = ['docker', 'exec', a:interactive ? '-it' : '-i', container]
  let password = get(parsed, 'password', get(params, 'password', ''))
  if !empty(password)
    let argv += ['-e', 'PGPASSWORD=' . password]
  endif
  let user = empty(get(parsed, 'user', '')) ? get(params, 'user', 'postgres') : parsed.user
  let db = substitute(get(parsed, 'path', ''), '\v^/+', '', '')
  if empty(db)
    let db = get(params, 'database', user)
  endif
  return argv + ['psql', '-w', '-U', user, '-d', db]
endfunction

function! db#adapter#dockerpg#canonicalize(url) abort
  return a:url
endfunction

function! db#adapter#dockerpg#interactive(url, ...) abort
  return s:argv(a:url, 1) + (a:0 ? a:1 : [])
endfunction

function! db#adapter#dockerpg#filter(url) abort
  return s:argv(a:url, 0) + ['-P', 'columns=' . &columns, '-v', 'ON_ERROR_STOP=1']
endfunction

function! db#adapter#dockerpg#tables(url) abort
  let out = db#systemlist(db#adapter#dockerpg#filter(a:url) + ['--no-psqlrc', '-tA', '-c', '\dtvm'])
  return map(filter(out, 'v:val =~# "|"'), 'split(v:val, "|")[1]')
endfunction

function! db#adapter#dockerpg#complete_database(url) abort
  let cmd = s:argv(a:url, 0) + ['--no-psqlrc', '-tA', '-c', 'SELECT datname FROM pg_database WHERE NOT datistemplate']
  return filter(map(db#systemlist(cmd), 'trim(v:val)'), '!empty(v:val)')
endfunction

function! db#adapter#dockerpg#complete_opaque(_) abort
  return db#adapter#dockerpg#complete_database('dockerpg:///')
endfunction
