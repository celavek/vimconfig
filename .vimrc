" Vim config file based on http://vim.wikia.com/wiki/Example_vimrc
"------------------------------------------------------------
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" pathogen
let g:pathogen_disabled = []

if !has("python")
    call add(g:pathogen_disabled, 'python-mode')
    call add(g:pathogen_disabled, 'vim-django')
endif

runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
"call pathogen#incubate()
call pathogen#helptags()

" Attempt to determine the type of a file based on its name and possibly its
" contents.  Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin indent on

" Enable syntax highlighting
syntax on

" status line configuration
function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return ""
    endif
    if bytes < 1024
        return bytes . "b"
    else
        return (bytes / 1024) . "k"
    endif
endfunction

set ls=2
set statusline= " completely reset statusline
set statusline+=%f\ " relative path of the file
set statusline+=%1*%m%r%*\ \ " modified flag and read only flag
set statusline+=[Buf:\ #%n/%{winnr()}]\ " buffer number
set statusline+=%{FileSize()}\ " filesize
set statusline+=[Line:\ %l/%L\ " cursor line/total lines(percent)
set statusline+=Col:\ %c] " cursor column
set statusline+=%= " left/right separator
set statusline+=[%{&wrap?'wrap':'nowrap'}, " wrap state
set statusline+=%{&expandtab?'spaces':'tabs'}:%{&tabstop}]\ " expand tab and tab stop info
set statusline+=[%{strlen(&filetype)?&filetype:'none'}, " filetype
set statusline+=%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}] " file format
set statusline+=\ %P " percent through file

"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" One of the most important options to activate. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files will keep you safe if your computer crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window for multiple buffers, and/or:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Modelines have historically been a source of security vulnerabilities.  As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell.  If visualbell is set, and
" this line is also included, vim will neither flash nor beep.  If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
" set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=4

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

"text length options
set textwidth=120
set colorcolumn=+1

"font settings
set guifont=Inconsolata:h11


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set noexpandtab
set copyindent
set preserveindent
set tabstop=4
set shiftwidth=4
set softtabstop=0

function! SetKernelTabs()
	set tabstop=8
	set shiftwidth=8
	set softtabstop=8
	set noexpandtab
endfunction

function! SetDefaultTabs()
	set tabstop=4
	set shiftwidth=4
	set softtabstop=4
	set noexpandtab
endfunction

"autocmd BufNewFile,BufEnter *.{c},*.{h} call SetKernelTabs()
"autocmd BufLeave *.{c},*.{h} call SetDefaultTabs()

" Indentation settings for using hard tabs for indent. Display tabs as
" two characters wide.
"set shiftwidth=2
"set tabstop=2

" clever tabs (tabs only on the line beginning) BEGIN
function! CleverTabs(shiftwidth)
    let line = getline('.')[:col('.')-2]
    if col('.') == 1 || line =~ '^\t*$' || line =~ '^$'
    let z = "\t"
    else
    let space = ""
    let shiftwidth = a:shiftwidth
    let shiftwidth = shiftwidth - ((virtcol('.')-1) % shiftwidth)

    while shiftwidth > 0
    let shiftwidth = shiftwidth - 1
    let space = space . ' '
    endwhile

    let z = space
    endif

    return z
endfunction "CleverTabs
" map tab key to function
imap <silent> <Tab> <C-r>=CleverTabs(4)<cr>

" build script invocation
function! BuildCurrent(...)
	let wd = getcwd()
	let b_args = a:000
	let script_args = ""
	if empty(b_args)
		let script_args = "Linux x86_64 clang Release"
	else
		let script_args = join(b_args)
	endif
	silent !clear
	echom wd
	echom script_args
	let l:command = '! ./build.sh ' . script_args
	let l:out = system(l:command)
	cexpr l:out
	caddexpr ""
	cwindow
endfunction "BuildCurrent
	        
map <F7> :call BuildCurrent()<CR>
imap <F7> :call BuildCurrent()<CR>

"autocmd FileType qf wincmd L

" highlight tabs in code
highlight ExtraWhitespace ctermbg=06
match ExtraWhitespace /\t\+/

" clever tabs END

" clang format
map <C-K> :pyf /home/mac/bin/clang-format.py<cr>
imap <C-K> <c-o>:pyf /home/mac/bin/clang-format.py<cr>

" set the color scheme
colorscheme desert256

" ditaa support
au BufRead,BufNewFile *.ditaa set ft=ditaa

"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" remove trailing whitespaces
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" Plugin specific options

" MiniBufExplorer
" let g:miniBufExplMapWindowNavVim = 1
" let g:miniBufExplMapWindowNavArrows = 1
" let g:miniBufExplMapCTabSwitchBufs = 1
" let g:miniBufExplModSelTarget = 1
"------------------------------------------------------------
"
" --------------------
" ShowMarks
" --------------------
" let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" let g:showmarks_enable = 1
" For marks a-z
" highlight ShowMarksHLl gui=bold guibg=LightBlue guifg=Blue
" For marks A-Z
" highlight ShowMarksHLu gui=bold guibg=LightRed guifg=DarkRed
" For all other marks
" highlight ShowMarksHLo gui=bold guibg=LightYellow guifg=DarkYellow
" For multiple marks on the same line.
" highlight ShowMarksHLm gui=bold guibg=LightGreen guifg=DarkGreen

" --------------------
" TagList
" --------------------
" F4: Switch on/off TagList
nnoremap <silent> <F4> :TlistToggle<CR>
" TagListTagName - Used for tag names
highlight MyTagListTagName gui=bold guifg=Black guibg=Orange
" TagListTagScope - Used for tag scope
highlight MyTagListTagScope gui=NONE guifg=Blue
" TagListTitle - Used for tag titles
highlight MyTagListTitle gui=bold guifg=DarkRed guibg=LightGray
" TagListComment - Used for comments
highlight MyTagListComment guifg=DarkGreen
" TagListFileName - Used for filenames
highlight MyTagListFileName gui=bold guifg=Black guibg=LightBlue
"let Tlist_Ctags_Cmd = $VIM.'/vimfiles/ctags.exe' " location of ctags tool
let Tlist_Show_One_File = 1 " Displaying tags for only one file~
let Tlist_Exit_OnlyWindow = 1 " if you are the last, kill yourself
let Tlist_Use_Right_Window = 1 " split to the right side of the screen
let Tlist_Sort_Type = "order" " sort by order or name
let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
let Tlist_Compact_Format = 1 " Remove extra information and blank lines from the taglist window.
let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
let Tlist_Close_On_Select = 1 " Close the taglist window when a file or tag is selected.
let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
let Tlist_WinWidth = 40
" let Tlist_Ctags_Cmd = 'ctags --c++-kinds=+p --fields=+iaS --extra=+q --languages=c++'

" ----------------
" Riv
" ----------------
let g:riv_auto_format_table = 0
let g:riv_fold_auto_update = 0

" ------------------
" Split navigation
" ------------------

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

"-------------
" Markdown
"-------------
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"-------
" YCM
"-------
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
let g:ycm_autoclose_preview_window_after_insertion = 1

"------------
" SyntaxRange
"------------
":autocmd Syntax * call SyntaxRange#Include(...)

