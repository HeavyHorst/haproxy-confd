# Haproxy-confd
Confd setup to look for etcd entries in /services, and
update a haproxy instance accordingly.

Entries have the form:

- /config/entryname/scheme 
 - Possible values http,tcp
- /config/entryname/host_port
	- Optional, listen on this port for incoming requests to this entry
- /services/entryname/[1,2,3,4]
	- Value is endpoints of IP:Port

## Examples
```
docker run \
   --net=host \
   --name haproxy \
   -e PREFIX=/ \
   quay.io/kaufmann_r/haproxy-confd
```

Example where host is foo.com:

    etcdctl set /services/wordpress/1 192.168.0.10:80
    etcdctl set /config/wordpress/scheme http
    etcdctl set /config/wordpress/host_port 8080

Entries are then available by requesting the service with either
url path matching entryname or host header matching entryname.

http://foo.com/wordpress
http://wordpress.foo.com

If the host_port entry is given a port value then

http://foo.com:8080

will also forward to the correct backend. For tcp services you always have to set the host_port, because of the missing header fields.
