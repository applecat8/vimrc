let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"


"+++     一些键位映射
"+++ my KeyMap---------------------
"+++

"leader 键设置为空格
let mapleader = " "

"JK 键跳5行
nnoremap J 5j
nnoremap K 5k
vnoremap J 5j
vnoremap K 5k

"在插入模式下映射jj为退出
inoremap jj <Esc>

"H,L 键跳到行首，行尾
map H ^
map L $

"开启行号
set number

"分屏操作,跳屏---------------
nnoremap gh <C-w>h
nnoremap gl <C-w>l
nnoremap gj <C-w>j
nnoremap gk <C-w>k
nnoremap <leader>l :vsp<CR>


"+++     一些基础设置
"+++ my some settings----------------
"+++

set showcmd
set wildmenu


"搜索忽略大小写
set hlsearch
set ignorecase
set smartcase

"语法高亮
set t_Co=256
syntax on

"设置缩进
set tabstop=4 
set expandtab
set autoindent
set shiftwidth=4

"防止vim闪屏
set noeb
set vb t_vb=

"设置屏幕下方保持5行
set so=5

"高亮光标所在行
set cursorline
"左边状态栏
set foldcolumn=1

set nocompatible
"文件
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on


"+++
"+++ 代码编译------------------
"+++
nnoremap <silent> <leader><leader>r :call Compole()<CR>

func! Compole()
    exec "w"
    set splitbelow
    if &filetype == 'python'
        :term ++rows=10 python3 %
    elseif &filetype == 'go'
        :term ++rows=10 go run %
    elseif &filetype == 'javascript'
        :term ++rows=10 node %
    elseif &filetype == 'java'
        let p = split(expand('%:r'), "/")
        let jp = join(p[3:-1], ".")
        let mvn = "mvn exec:java -Dexec.mainClass=" . "\"" . jp . "\""
        :call term_start(mvn)
    elseif &filetype == 'c'
        if !isdirectory('.build')
            :silent !mkdir .build
            :redraw!
        endif
        :term ++rows=10 ++shell echo -e "\033[31mCompile Information: \033[0m" && gcc -o .build/%< % && echo -e "\033[32mRunning Result: \033[0m" && .build/%<
    endif
endfunc

"+++
"+++ vim-plug------------------
"+++

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'mg979/vim-visual-multi', {'branch': 'master'}

Plug 'morhetz/gruvbox'

Plug 'turbio/bracey.vim'

Plug 'nathanaelkane/vim-indent-guides'

Plug 'rhysd/accelerated-jk'

Plug 'uiiaoo/java-syntax.vim'

call plug#end()


"+++
"+++ NERDTree配置-----------
"+++

"ff键打开|关闭目录树
nnoremap ff :NERDTreeToggle<CR>

"目录树窗口大小25
let  NERDTreeWinSize = 25

" Exit Vim if NERDTree is the only window left.
" 最后一个窗口关闭
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif



"+++
"+++ Coc配置----------------------
"+++

let g:coc_global_extensions = ['coc-json', 'coc-vimlsp', 'coc-go', 
            \'coc-snippets', 'coc-clangd', 'coc-pyright', 'coc-highlight', 'coc-tsserver',
            \'coc-markdownlint', 'coc-translator', 'coc-lists', 'coc-java']

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c


" Always show the signcolumn, otherwise it would shift the text each time
" " diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
" Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

"使用tab键进行补全
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"<C-o>打开补全
inoremap <silent><expr> <C-o> coc#refresh()

"跳转代码报错
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

"跳转函数定义等
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"显示帮助文档
" Use K to show documentation in preview window.
nnoremap <silent> <leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

"Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
autocmd CursorHold * silent call CocActionAsync('highlight')

xmap if <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-a)



"+++
"+++ theme配置-----------------------------
"+++

" Unified color scheme (default: dark)

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif


" for the dark version
" set background=light " for the light version
set background=dark
colorscheme gruvbox



"+++
"+++ translator配置-----------------------------
"+++

" NOTE: do NOT use `nore` mappings
" popup
nmap <Leader>t <Plug>(coc-translator-p)
vmap <Leader>t <Plug>(coc-translator-pv)


"+++
"+++ coclist配置-----------------------------
"+++
nnoremap <leader>ff :<C-u>CocList files<cr>
nnoremap <leader>fb :<C-u>CocList buffers<cr>
nnoremap <leader>fm :<C-u>CocList marks<cr>

nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size= 1
let g:indent_guides_enable_on_vim_startup = 1
