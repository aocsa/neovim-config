set pumheight=15                                                                "Maximum number of entries in autocomplete popup
set completeopt-=preview

augroup vimrc_autocomplete
  autocmd!
  autocmd VimEnter * call s:setup_lsp()
  " autocmd FileType javascript,typescript,javascriptreact,typescriptreact let g:completion_trigger_character = ['.']
  " autocmd FileType vim let g:completion_trigger_character = ['.']
  " autocmd FileType sql let g:completion_trigger_character = ['.']
  " autocmd FileType php let g:completion_trigger_character = ['::', '->', ' ']
  autocmd FileType javascript,javascriptreact,vim,php,gopls setlocal omnifunc=v:lua.vim.lsp.omnifunc
  " autocmd BufEnter * lua require'completion'.on_attach()
augroup END

function! s:setup_lsp() abort
  " lua require'source'.addCompleteItems('vim-dadbod-completion', require'vim_dadbod_completion'.complete_item)
  lua require'nvim_lsp'.tsserver.setup{}
  lua require'nvim_lsp'.vimls.setup{}
  lua require'nvim_lsp'.intelephense.setup{}
  lua require'nvim_lsp'.gopls.setup{}
endfunction

let g:completion_confirm_key = "\<C-y>"
let g:completion_auto_change_source = 1
let g:completion_chain_complete_list = {
      \ 'sql': [
      \   {'complete_items': ['vim-dadbod-completion']},
      \   {'mode': '<c-n>'},
      \],
      \ 'default': [
      \    {'complete_items': ['lsp', 'path']},
      \    {'mode': 'tags'},
      \    {'mode': 'keyn'},
      \    {'mode': '<c-p>'},
      \  ]}

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction


let s:snippets = {
      \ 'cl': "console.log();\<Left>\<Left>",
      \ 'class': "class {\<CR>}\<C-o>% \<Left>",
      \ }

function s:tab_completion() abort
  let word = matchlist(getline('.')[0:(col('.') - 1)], '\k*$')
  if !empty(word[0]) && has_key(s:snippets, word[0])
    return "\<C-w>".s:snippets[word[0]]
  endif

  if pumvisible()
    return "\<C-n>"
  endif

  if s:check_back_space()
    return "\<TAB>"
  endif

  if empty(&omnifunc)
    return "\<C-n>"
  endif

  call timer_start(100, function('s:check_omni'))
  return "\<C-x>\<C-o>"
endfunction

function s:check_omni(timer) abort
  if !pumvisible()
    return feedkeys("\<C-g>\<C-g>\<C-n>")
  endif
endfunction

inoremap <silent><expr> <TAB> <sid>tab_completion()

imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" imap <c-j> <cmd>lua require'source'.prevCompletion()<CR>
" imap <c-k> <cmd>lua require'source'.nextCompletion()<CR>

nmap <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
nmap <leader>lc <cmd>lua vim.lsp.buf.declaration()<CR>
nmap <leader>lg <cmd>lua vim.lsp.buf.implementation()<CR>
nmap <leader>lu <cmd>lua vim.lsp.buf.references()<CR>
nmap <leader>lr <cmd>lua vim.lsp.buf.rename()<CR>
nmap <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>

set wildoptions=pum
set wildignore=*.o,*.obj,*~                                                     "stuff to ignore when tab completing
set wildignore+=*.git*
set wildignore+=*.meteor*
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*mypy_cache*
set wildignore+=*__pycache__*
set wildignore+=*cache*
set wildignore+=*logs*
set wildignore+=*node_modules*
set wildignore+=**/node_modules/**
set wildignore+=*DS_Store*
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
