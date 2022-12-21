# restful 风格操作你的redis
https://github.com/nicolasff/webdis
--------------------------------------
C语言开发的redis代理中间件,http操作读写redis,有简单的权限和Ip限止.直接

` curl http://127.0.0.1:6379/SET/hello/world
` {"SET":[true,"OK"]}

` curl http://127.0.0.1:6379/GET/hello
` {"GET":"world"}

# 此处http/post方法  GET是参数,是redis的get 命令
` curl -X POST -d "GET/hello" http://127.0.0.1:6379/
` {"GET":"world"}

` curl -X POST -d "GET/hello" http://127.0.0.1:6379/.raw
world

`curl http://127.0.0.1:7378/xrange/strc/-/1653994726744-0
{"xrange":[{"id":"1653994605327-0","msg":{"name":"andy","age":"99"}},{"id":"1653994722111-0","msg":{"name":"andy2","age":"92"}},{"id":"1653994726744-0","msg":{"name":"andy3","age":"93"}}]}%

# 全量命令几乎都是支持的. curl http://ip:port/command/require_arguments/option_arguments

# webdis.josn 是配置文件
# 可以配置多个不同的端口实现集群效果

# 有websocket模式github/tests/websocket.html现成demo

# acl 配置可以 操作的命令,来访问的Ip白名单.但是只能控制http,不能控制ws

