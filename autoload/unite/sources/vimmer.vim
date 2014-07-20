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


let s:source = {
\	"name" : "vimmer",
\	'description' : 'Vimmers in vim-jp : http://vim-jp.org/vimmers2/',
\}

function! s:source.gather_candidates(...)
	if !exists("s:cache")
		let s:cache = s:get_vimmers()
	endif
	return map(copy(s:cache), '{
\		"word" : printf("%-20S : %s", v:val.name, substitute(v:val.description, "\\n", "", "g")),
\		"kind" : "vimmer_uri",
\		"action__path" : v:val.website,
\		"action__github_uri"  : empty(v:val.github) ? "" : ("https://github.com/" . v:val.github),
\		"action__twitter_uri" : empty(v:val.twitter) ? "" : ("https://twitter.com/" . v:val.twitter),
\	}')
endfunction


function! unite#sources#vimmer#define()
	return s:source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
