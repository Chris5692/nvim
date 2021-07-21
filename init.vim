filetype plugin indent on
set runtimepath^=~/.vim/bundle
set runtimepath^=~/.vim/plugged

call plug#begin() 
Plug 'rakr/vim-one'
Plug 'chrisbra/Colorizer'
Plug 'scrooloose/nerdtree'
Plug 'chrisbra/unicode.vim'
Plug 'crusoexia/vim-monokai'
Plug 'vim-syntastic/Syntastic'
Plug 'vim-airline/vim-airline'
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

"source ~/.vim/bundle/molokai/colors/molokai.vim
"source ~/.vim/bundle/vim-css-color/after/syntax/css.vim
"source ~/.vim/plugged/vim-monokai/colors/monokai.vim

"" NERDTree Customization
" Delete buffer while keeping window layout (don't close buffer's windows).
" " Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
let bclose_multiple = 1
endif

" " Display an error message.
function! s:Warn(msg)
echohl ErrorMsg
echomsg a:msg
echohl NONE
endfunction

" " Command ':Bclose' executes ':bd' to delete buffer in current window.
" " The window will show the alternate buffer (Ctrl-^) if it exists,
" " or the previous buffer (:bp), or a blank buffer if no previous.
" " Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" " An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)	
if empty(a:buffer)
let btarget = bufnr('%')
elseif a:buffer =~ '^\d\+$'
let btarget = bufnr(str2nr(a:buffer))
else
let btarget = bufnr(a:buffer)
endif
if btarget < 0

call s:Warn('No matching buffer for '.a:buffer)
return
endif
if empty(a:bang) && getbufvar(btarget, '&modified')
call s:Warn('No write since last change for buffer '.btarget.' (use:Bclose!)')
return
endif
"Numbers of windows that view target buffer which we will delete.
let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
if !g:bclose_multiple && len(wnums) > 1
call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
return
endif
let wcurrent = winnr()
for w in wnums
execute w.'wincmd w'
let prevbuf = bufnr('#')
if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
buffer #
else
bprevious
endif
if btarget == bufnr('%')
"Numbers of listed buffers which are not the target to be deleted.
let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
" Listed, not target, and not displayed.
let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
" Take the first buffer, if any (could be more intelligent).
let bjump = (bhidden + blisted + [-1])[0]
if bjump > 0
execute 'buffer '.bjump
else
execute 'enew'.a:bang
endif
endif
endfor
execute 'bdelete'.a:bang.' '.btarget
execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>','<args>')
nnoremap <silent> <Leader>bd :Bclose<CR>
nnoremap <silent> <Leader>bD :Bclose!<CR>


"" Normal configs
set number			" Setting numbers
syntax on			" Syntax highlighting for vim
set showcmd			" Show (partial) command in status line
set showmatch			" Show matching brackets.
set ignorecase	 		" Do case insensitive matching
set smartcase			" Do smart case matching
set incsearch	 		" Incremental search
set autowrite 			" Automatically save before commands like :next and :make
set hidden			" Hide buffers when they are abandoned
set mouse=a			" Enable mouse usage (all modes)
set modelines=0			" Status bar
set encoding=utf-8		" Encoding
set path+=**			" setting path for the vim
set wildmenu			" A menu appeared from the wild
set t_Co=256        		" Set colors to 256
set hlsearch 			" Highlight searches 
set wildmode=longest,list,full	" auto complete
set splitbelow splitright
let NERDTreeShowHidden=1	" NERDTree config for showing hidden files
let NERDTreeShowBookmarks=1	" NERDTree config for showing bookmarks

"" Vim colorschemees
set background=dark
colorscheme PaperColor
"au InsertLeave * colorscheme dark
"au InsertEnter * colorscheme light

"" Vim Airline themes 
let g:airline_theme='bubblegum' 
let g:airline#extensions#tabline#enabled=1
let g:airline#entensions#tabline#left_sep=''
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Unicode : Source- https://github.com/msjche/dotfiles_laptop/blob/master/.vimrc
let g:Powerline_symbols = "fancy"
let g:Powerline_dividers_override = ["\Ue0b0","\Ue0b1","\Ue0b2","\Ue0b3"]
let g:Powerline_symbols_override = {'BRANCH': "\Ue0a0", 'LINE': "\Ue0a1", 'RO': "\Ue0a2"}
let g:airline_powerline_fonts = 1
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''

let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"" vim-css-color
let g:cssColorVimDoNotMessMyUpdatetime = 1


"" Alias
command NER NERDTree
inoremap [; <Esc>

"" VIM navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"" Vim split screen navigation
" Use ctrl-[hjkl] to select the active split or panes!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>


"""" Vim buffer navigation
""nnormap <{> :bprevious<CR>
""nnormap <}> :bnext<CR>

