if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.ini,*/.hgrc,*/.hg/hgrc setfiletype ini
augroup END
