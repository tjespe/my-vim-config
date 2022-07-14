filetype off                  " required
syntax on " enable syntax colors
set mouse=a " enable mouse gestures
set nocompatible              " be iMproved, required
set laststatus=2 " Show status
set splitright " Split buffer to the right by default
set splitbelow " Split below by default

" Auto indent
set autoindent
set tabstop=2
set softtabstop=0
set expandtab
set smarttab
set shiftwidth=2

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

" Command mappings
cmap w!! w !sudo tee > /dev/null %
cmap Q q!

" Git blame config
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>


" Auto complete
set completeopt=longest,menuone
nnoremap <F9> :w<CR>:!%:p<CR>
inoremap {<CR> {<CR>}<Esc>ko
autocmd FileType javascript,html inoremap for<Space> for<Space>(i<Space>=<Space>0;i<Space><<Space>array.length;i++)<Space>{<CR><BS>}<Esc>k8wv4ls
autocmd FileType php inoremap for<Space> for<Space>($i<Space>=<Space>0;$i<Space><<Space>$array.length;$i++)<Space>{<CR><BS>}<Esc>k9wv4l
autocmd FileType html inoremap <div> <div></div><Esc>b2hi
map <Tab> >>
map <S-Tab> <<
inoremap <expr> <Tab> getline('.')[col('.') - 2] =~ '\a' ? "\<C-n>" : "\<Tab>"
inoremap <S-Tab> <C-d>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Custom commands:
" Fix size of NetrwTreeListing
command R call FixSize()
" Enter copy mode
command M call CopyMode()
" Remove background
command NoBG call RemoveBackground()
command NM so $MYVIMRC
" Word count
command WC ! wc -w '%'

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
function! RemoveBackground()
  hi Normal ctermbg=none
  highlight NonText ctermbg=none
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
            \ bufname(winbufnr(i)) == 'NetrwTreeListing 1' ||
            \ bufname(winbufnr(i)) == 'NetrwTreeListing'
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
Plugin 'othree/vim-autocomplpop'
Plugin 'vim-scripts/L9'
Plugin 'vim-syntastic/syntastic'
Plugin 'ciaranm/detectindent'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'zivyangll/git-blame.vim'

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

" Auto update
silent exec "! ~/.vim/install.sh > /dev/null 2> /dev/null & disown"

" Font size in MacVim
if has("gui_macvim")
  set guifont=Menlo:h14
endif
