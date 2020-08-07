filetype plugin on
set t_Co=8
set t_Sf=\033[3%p1%dm
set t_Sb=\033[4%p1%dm
set background=dark

syntax on
filetype plugin indent on

set smartindent
set pastetoggle=<F2>
set cursorline
set ignorecase
"set paste
set mat=2
set encoding=utf8
"set noai
set lbr
set tw=500
colorscheme desert
set background=dark
let g:__autor__      = 'Leonardo Berbert'
let g:__email__      = 'meu_email'
let g:__headerlen__  = 10 
set backspace=indent,eol,start

function HtmlConfig()
        set tabstop=2 softtabstop=2 expandtab shiftwidth=2
endfunction

function PythonConfig()
        set tabstop=4 softtabstop=4 expandtab shiftwidth=4
endfunction

function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceIfExists("/home/vagrant/.vim/syntax/logstash.vim")

function UpdateLastModification () 
     if &modified == 1 
         let l = GetLinMax (g:__headerlen__) 
         silent! 
         \ execute "1," . l . "g/Modified:/s/Modified:.*/Modified: " . 
         \   strftime ("%c") 
     endif 
endfunction 
 


function ReplaceTag (tag, rep, linmax)
    if &modified == 1
        let l = GetLinMax (a:linmax)

        silent!
        \ execute "1," . l . "g/" . a:tag . "/s/" . a:tag . "/" . a:rep
    endif
endfunction

function GetLinMax (linmax)
    if line ("$") > a:linmax
        return a:linmax
    else
        return line ("$")
     endif
endfunction

autocmd FileType html call HtmlConfig()
autocmd FileType python call PythonConfig()

    augroup modelos 
        autocmd!

        " Os modelos estefinidos em ~/.vim/skel. cess criar um
        " novo neste diret para que o Vim passe a utiliz. Caso o
        " modelo nxista, o vim iriar um arquivo vazio, como costuma
        " fazer.
        autocmd BufNewFile * silent!
            \ 0r ~/.vim/skel/skel.%:e|norm G

        " Substitui varis especiais nos modelos carregados pelo valores
        " configurados neste arquivo de configura Esta substituiita
        " quando o arquivo rregado. A data de modificarada apenas
        " por ajustes estos, nada mais. A posido cursor lva e
        " restaurada apstas modifica.
        autocmd BufNewFile *
            \ ks|call ReplaceTag ("%AUTOR%", __autor__, __headerlen__)
            \|   call ReplaceTag ("%EMAIL%", __email__, __headerlen__)
            \|   %s/Modified:.*$/Modified: /ge |'s

        " Faz o mesmo que a opacima, mas com a data de criado arquivo.
        " A substituiita quando o arquivo lvo para que a data de
        " criado mesmo seja fiel a realidade, se e isso faz alguma
        " diferen
        autocmd BufWritePre,FileWritePre *
            \ ks|call ReplaceTag ("%DATA%", strftime ("%c"), __headerlen__)|'s
        autocmd BufWritePre,FileWritePre * 
                \ ks| call UpdateLastModification () |'s 

    augroup end

function! HasPaste()
        if &paste
                return 'PASTE MODE ON '
        en
                return 'PASTE MODE OFF '
endfunction

"""""""""" 5) Linha de status """"""""""""""""""""
"
""" Sempre mostra a linha de status
set laststatus=2
"
""" Formato da linha de status
set statusline=\ %{HasPaste()}\ Arquivo:\ %F%m%r%h\ %w\ \ Diretorio\ de\ trabalho:\ %r%{getcwd()}%h\ -\ Linha:\ %l\ -\ Coluna:\ %c