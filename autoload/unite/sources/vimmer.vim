scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:V = vital#of("unite_vimmer")
let s:HTTP = s:V.import("Web.HTTP")
let s:JSON = s:V.import("Web.JSON")
function! s:get_vimmers()
	let result = s:HTTP.get("https://raw.githubusercontent.com/vim-jp/vim-jp.github.com/master/vimmers/vimmers.json")
	let content = s:JSON.decode(result.content)
	return content
endfunction


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


let s:source = {
\	"name" : "vimmer",
\	'description' : 'Vimmers in vim-jp : http://vim-jp.org/vimmers2/',
\	"action_table" : {
\		"github_start" : {
\			"is_selectable" : 1,
\			"description" : "open github page by browser."
\		},
\		"twitter_start" : {
\			"is_selectable" : 1,
\			"description" : "open Twitter page by browser."
\		},
\	},
\}


function! s:source.action_table.github_start.func(candidates)
	return s:open(a:candidates, "github_uri")
endfunction

function! s:source.action_table.twitter_start.func(candidates)
	return s:open(a:candidates, "twitter_uri")
endfunction


function! s:source.gather_candidates(...)
	if !exists("s:cache")
		let s:cache = s:get_vimmers()
	endif
	return map(copy(s:cache), '{
\		"word" : printf("%-20S : %s", v:val.name, substitute(v:val.description, "\\n", " ", "g")),
\		"kind" : "uri",
\		"action__path" : v:val.website,
\		"action__github_uri"  : "https://github.com/" . v:val.github,
\		"action__twitter_uri" : "https://twitter.com/" . v:val.twitter,
\		"default_action" : !empty(v:val.website) ? "start" : !empty(v:val.twitter) ? "twitter_start" : "github_start",
\	}')
endfunction



function! unite#sources#vimmer#define()
	return s:source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
