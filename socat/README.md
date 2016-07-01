# Docker port/socket forwarding with socat

## Examples

### Export the weave socket to local host.

```
socat unix-listen:/tmp/weave.sock,reuseaddr,fork 'EXEC:docker run -i --rm -v /var/run/weave/weave.sock\:/weave.sock danisla/socat "STDIO UNIX-CONNECT:/weave.sock"',pty,raw,echo=0

DOCKER_HOST=unix:///tmp/weave.sock docker run -it --rm --name centos centos ping centos.weave.local
```
