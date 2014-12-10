function! MoveToCodeSplit()
  wincmd h
endfunction

function! MoveToTestSplit()
  wincmd l
  wincmd k
endfunction

function! MoveToOutputSplit()
  wincmd l
  wincmd j
endfunction

function! GetFileName()
  call MoveToCodeSplit()
  return @%
endfunction

function! SaveFile()
  call MoveToCodeSplit()
  write
endfunction

function! LoadOutputBuffer()
endfunction

function! Stdin()
  call MoveToTestSplit()
  return join(getline(1, '$'), "\n")
endfunction

function! ExecuteProgram()
  if line('$') == 1 && getline(1) == ''
    echo system("ruby " . GetFileName())
  else
    echo system("ruby " . GetFileName(), Stdin())
  endif
endfunction

function! QuicklyRun()
  if !exists("g:quickly_has_run")
    call Quickly()
    let g:quickly_has_run = 1
  end

  call SaveFile()
  let filename = GetFileName()
  call MoveToTestSplit()
  redir => output
  call ExecuteProgram()
  redir END
  redraw!
  call MoveToOutputSplit()
  normal! ggdG
  put=output
  " Remove two top blank lines
  normal! gg2dd
  call MoveToCodeSplit()
endfunction

function! Quickly()
  vsplit __TestCase__
  normal! ggdGi
  setlocal buftype=nofile

  split __Output__
  normal! ggdG
  setlocal buftype=nofile

  wincmd h
endfunction

command! Quickly call Quickly()
command! QuicklyRun call QuicklyRun()
