local auth = ngx.req.get_headers()["Authorization"]

if auth ~= "secret"  then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end