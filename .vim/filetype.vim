au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/*,/etc/nginx/snippets/* if &ft == '' | setfiletype nginx | endif
