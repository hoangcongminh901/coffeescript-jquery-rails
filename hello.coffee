http = require("http")
server = http.createServer (req, res) ->
  res.writeHead 200
  res.end "Hello World asf"

server.listen 7999
