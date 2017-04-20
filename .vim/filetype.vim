au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/*,/etc/nginx/snippets/* if &ft == '' | setfiletype nginx | endif
au BufRead,BufNewFile /etc/php/*/*.conf,/usr/local/php/*/*.conf if &ft == '' | setfiletype dosini | endif
