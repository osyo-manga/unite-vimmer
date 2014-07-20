scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
\	"name" : "vimmer_uri",
\	"default_action" : "smart_start",
\	"action_table" : {
\		"smart_start" : {
\			"is_selectable" : 1,
\			"description" : "open by browser."
\		},
\		"github_start" : {
\			"is_selectable" : 1,
\			"description" : "open github page by browser."
\		},
\		"twitter_start" : {
\			"is_selectable" : 1,
\			"description" : "open Twitter page by browser."
\		},
\	},
\	"parents" : ["uri"],
\}


function! s:open(candidates, key)
  for candidate in a:candidates
    let path = has_key(candidate, 'action__' . a:key) ?
          \ candidate['action__' . a:key] : candidate.action__path
    if unite#util#is_windows() && path =~ '^//'
      " substitute separator for UNC.
      let path = substitute(path, '/', '\\', 'g')
    endif

    call unite#util#open(path)
  endfor
endfunction


function! s:kind.action_table.smart_start.func(candidates)
	for candidate in a:candidates
		if !empty(candidate.action__path)
			call s:open([candidate], "path")
		elseif !empty(candidate.action__github_uri)
			call s:open([candidate], "github_uri")
		elseif !empty(candidate.action__twitter_uri)
			call s:open([candidate], "twitter_uri")
		else
			call s:open([candidate], "path")
		endif
	endfor
endfunction


function! s:kind.action_table.github_start.func(candidates)
	return s:open(a:candidates, "github_uri")
endfunction

function! s:kind.action_table.twitter_start.func(candidates)
	return s:open(a:candidates, "twitter_uri")
endfunction



function! unite#kinds#vimmer_uri#define()
	return s:kind
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
