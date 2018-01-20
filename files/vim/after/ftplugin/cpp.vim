" indentation
setlocal shiftwidth=4
setlocal softtabstop=4

" auto-formatting
" align unclosed parentheses
setlocal cinoptions+=(0
" do not indent namespaces
setlocal cinoptions+=N-s
" indent public/private 0.5s
setlocal cinoptions+=g0.5s
" indent after label additional 0.5s
setlocal cinoptions+=h0.5s
