filetype off                  " required
syntax on
set mouse=a
set nocompatible              " be iMproved, required
set autoindent
set tabstop=2
set softtabstop=0
set expandtab
set smarttab
set shiftwidth=2
set laststatus=2
set splitright
set splitbelow

" Tree view
let g:netrw_browse_split = 2
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_altv = 1
if winwidth(0) > 90
  augroup ProjectDrawer
    autocmd!
    autocmd VimEnter * :Vexplore
    autocmd VimEnter * :R
  augroup END
endif
set number

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Auto complete
inoremap {<CR> {<CR>}<Esc>ko
autocmd FileType javascript,html inoremap for<Space> for<Space>(i<Space>=<Space>0;i<Space><<Space>array.length;i++)<Space>{<CR><BS>}<Esc>k8wv4ls
autocmd FileType php inoremap for<Space> for<Space>($i<Space>=<Space>0;$i<Space><<Space>$array.length;$i++)<Space>{<CR><BS>}<Esc>k9wv4l
autocmd FileType html inoremap <div> <div></div><Esc>b2hi
inoremap <Tab> <C-p>
map <Tab> w

" Custom commands:
command R call FixSize()
command Q qall
command M call CopyMode()
command NM so $MYVIMRC

" Custom functions
function! CopyMode()
  set mouse=
  set nonumber
  call feedkeys("\<C-w>\<C-w>\:q\<CR>")
endfunction
function! FixSize()
  vertical resize 25
  set wfw
  call feedkeys("\<C-w>\<C-w>")
endfunction

" Function to exit vim if only help/treeview is open
function! CheckLeftBuffers()
  if tabpagenr('$') == 1
    let i = 1
    while i <= winnr('$')
      if getbufvar(winbufnr(i), '&buftype') == 'help' ||
            \ getbufvar(winbufnr(i), '&buftype') == 'quickfix' ||
            \ exists('t:NERDTreeBufName') &&
            \   bufname(winbufnr(i)) == t:NERDTreeBufName ||
            \ bufname(winbufnr(i)) == 'NetrwTreeListing 1'
        let i += 1
      else
        break
      endif
    endwhile
    if i == winnr('$') + 1
      qall
    endif
    unlet i
  endif
endfunction
autocmd BufEnter * call CheckLeftBuffers()

" Clean empty buffers
"function! s:CleanEmptyBuffers()
  "let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
  "if !empty(buffers)
    "exe 'bw '.join(buffers, ' ')
  "endif
"endfunction
"autocmd BufAdd * call CleanEmptyBuffers()

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdcommenter'
Plugin 'davidklsn/vim-sialoquent'
Plugin 'endel/vim-github-colorscheme'
"Plugin 'udalov/kotlin-vim'
"Plugin 'Valloric/YouCompleteMe'

" All Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Only use colorchemes when 256 colors are available
if $TERM == 'xterm-256color'
  " Choose colorscheme based on time
  "if strftime('%H')<7 || strftime('%H') > 15
    colorscheme sialoquent
  "else
    "colorscheme github
  "endif
endif
