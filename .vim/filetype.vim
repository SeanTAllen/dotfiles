if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.ini,*/.hgrc,*/.hg/hgrc setfiletype ini
  au! BufRead,BufNewFile *.scss setfiletype scss
  au! BufRead,BufNewFile *.sass setfiletype sass
augroup END
