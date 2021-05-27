local mysql = require "resty.mysql" 
local db, err = mysql:new()
local yuri = ngx.quote_sql_str(ngx.var.host)

if not db then
	ngx.say("failed to instantiate mysql: ", err)
	return 
end 

local ok, err, errcode, sqlstate = db:connect{
	host = "127.0.0.1",
	database = "productionappp",
	user = "root",
	password = "motdepasseamettreici",
}

if not ok then
	ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
	return 
end 

res, err, errcode, sqlstate =
	db:query("select * from urls where active=1 and source=" .. yuri, 1)
if not res then
	ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
	return 
end 

local urlmate = res[1]["destination"] 

local ok, err = db:close() 
if not ok then
	ngx.say("failed to close: ", err)
	return 
end

return ngx.redirect(urlmate, ngx.HTTP_MOVED_PERMANENTLY)
