local yuri = ngx.quote_sql_str(ngx.var.host) 

local yao = ngx.quote_sql_str(ngx.var.request_uri)

local both = ngx.quote_sql_str(ngx.var.host..ngx.var.request_uri)

ngx.say("uri",yuri,"yao",yao,"both",both)
