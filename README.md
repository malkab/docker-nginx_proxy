nginx Proxy
===========

The sole purpose of this image is to create __nginx__ proxies.


Usage
-----
To build:

```Shell
docker built -t="geographica/nginx_proxy" .
```

Do not upload this image to DockerHub, it makes no sense, for each of its builds are a customized case.

This image configure __nginx__ proxies to dockerized applications. Proxy configurations are in the __conf.d__ folder. A typical proxy looks like this:

```Shell
server {
  listen 80;
  server_name geoservers.geographica.gs;
  
  location /gs_a/ {
    proxy_pass http://geoserver:8080/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
	
  location /gs_b/ {
    proxy_pass http://geoserverb:8085/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
}
```

This means that the server is listening at entries to domain name _geoservers.geographica.gs_ at port 80. This domain name is linking to the server's IP. Remember that multiple domains can be linked to a single machine. When the machine is reached from the given domain and port, __nginx__ analyzes the resource asked (either _gs_a_ or _gs_b_) and redirects to the appropiate host.

Those host are in fact dockerized applications linked with __external_link__ to the __nginx__ proxy. The nginx knows how to resolve the container names to their docker internal network IP, so it is capable of reaching them. This way, is innecesary in production to expose the ports of the dockerized applications: only the __nginx__ proxy knows about them and as such everything is pretty much contained.

To attach a new dockerized application to the proxy, follow this steps:

- make sure the container is attached to the proxy container by adding it's name to the __external_links__ directive in _docker-compose.yml_ control file;

- make, for each new domain, a configuration file inside _conf.d_, or just add a new location to an existing one, pointing to the new dockerized application's web entry point;

- recreate the __nginx__ proxy container:

```Shell
docker stop nginx_proxy ; docker rm -v nginx_proxy ; docker-compose build ; docker-compose up -d
```

Also, don't forget to modify the static HTML in _html_ with something funny.


localhost usage
---------------
The use of __localhost__ as server_name is discouraged. __localhost__ is sometimes a pain because I'm a complete beginner in network management and such. To simulate different domain names on localhost, just edit __/etc/hosts__ and add there additional entries to IP 127.0.0.1. Then _.conf_ files can be created for this local domains.
