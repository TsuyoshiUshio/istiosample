#!/usr/bin/ruby
#
# Copyright 2017 Istio Authors
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require 'webrick'
require 'net/http'

if ARGV.length < 1 then
    puts "usage: #{$PROGRAM_NAME} port"
    exit(-1)
end

port = Integer(ARGV[0])

server = WEBrick::HTTPServer.new :BindAddress => '0.0.0.0', :Port => port

trap 'INT' do server.shutdown end

login = '
<html>
<head>
    <title>V2Tester Login</title>
    <meta http-equiv="Set-Cookie" content="NAME=v2tester"> 
</head>
<body>
    <H1>You logged in as a v2 Tester.</H1>
</body>
</html>
'

logout = '
<html>
<head>
    <title>V2Tester Logout</title>
    <meta http-equiv="Set-Cookie" content="NAME=v2tester; expires=Fri, 31-Dec-1999 23:59:59 GMT;"> 
</head>
<body>
    <H1>You logged out as a v2 Tester.</H1>
</body>
</html>

'

server.mount_proc '/webpage' do |req, res|
    uri = URI.parse(ENV["SERVICE_URL"])
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)

    puts("---------transfar cookie")
    puts(req.cookies)
    cookies = {}
    req.cookies.each{|cookie|
        cookies[cookie.name] = cookie.value
        puts(cookie.name + "=" + cookie.value)
    }
    request['Cookie'] = cookies.map{|k,v|
        "#{k}=#{v}"
    }.join(';')
    puts "Cookie:" + request['Cookie']
    puts "-----end "

    response = http.request(request)
    res.body = response.body

    res.status = 200
    res['Content-Type'] = 'text/html'
end

server.mount_proc '/loginpage' do |req, res|
    res.body = login
    res['Content-Type'] = 'text/html'
end

server.mount_proc '/logoutpage' do |req, res|
    res.body = logout
    res['Content-Type'] = 'text/html'
end

server.start
