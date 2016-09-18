### Tests for RSelenium

These tests are converted from the Python tests in the Selenium project. The tests use a set of
HTML documents that can be sourced using

```
svn checkout https://github.com/SeleniumHQ/selenium/trunk/common/src/web
```

The tests assume these HTML documents are available and served locally. To serve the files we
use a Docker image [redsadic/docker-http-server](https://hub.docker.com/r/redsadic/docker-http-server/).
This image runs the node application http-server exposing the /public directory at port 8080. We map the
public directory on the container to the web directory above on the Host (We assume the docker commands are issued from the parent folder containing the web directory - a legacy of using the same calls on TRAVIS):

```
docker run -d -p 3000:8080 --name http-server -v $(pwd)/web:/public redsadic/docker-http-server&
```

Next we run a Docker image containing the standalone Selenium server and a chrome browser:

```
docker run -d -p 127.0.0.1:4444:4444 --link http-server selenium/standalone-chrome:2.53.0

```

or a debug version with VNC exposed on port 5901 of the host

```
docker run -d -p 5901:5900 -p 127.0.0.1:4444:4444 --link http-server selenium/standalone-chrome-debug:2.53.0

```
The two Docker containers are linked so the Selenium server will be able to access the http server on its port 8080 and referencing the http server as "http-server"

```
http-server:8080/*.html
```

Normally on the test machine docker containers are stopped and removed prior to testing:

```
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
```
#### System variables

For CRAN and TRAVIS compatibility two env variables are looked for: NOT_CRAN and 
TRAVIS. If the tests are being ran locally with the above setup you can set these environmental variables = "true" or set them in R:

```
Sys.setenv("NOT_CRAN" = "true")
Sys.setenv("TRAVIS" = "true")
```
