# Testing `RSelenium`

These tests are converted from the Python tests in the Selenium project. The tests use a set of HTML documents from [SeleniumHQ/selenium](https://github.com/SeleniumHQ/selenium/tree/trunk/common/src/web).

First, we create a bridge network to link the Selenium server and the http server:

```sh
docker network create rselenium
```

The tests assume these HTML documents are available and served locally. To serve the files, we use a Docker image [juyeongkim/test-server](https://hub.docker.com/r/juyeongkim/test-server/). This image runs the node application http-server exposing the `/web` directory (cloned HTML documents from [SeleniumHQ/selenium](https://github.com/SeleniumHQ/selenium/tree/trunk/common/src/web)) at port 8080.

```sh
docker run -d --network rselenium --network-alias test-server -p 3000:8080 juyeongkim/test-server
```

Next, we run a Docker image containing the standalone Selenium server and a chrome browser:

```sh
docker run -d --network rselenium --network-alias selenium -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:2.53.1
```

or a debug version with VNC exposed on port 5901 of the host:

```sh
docker run -d --network rselenium --network-alias selenium -p 5901:5900 -p 4444:4444 -v /dev/shm:/dev/shm selenium/standalone-chrome:2.53.1
```

The two Docker containers are linked, so the Selenium server will be able to access the http server on its port 8080 and referencing the http server as "test-server".

```
test-server:8080/*.html
```

Normally, on the test machine, docker containers are stopped and removed prior to testing:

```sh
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
```

## Environment variables

For CRAN and GitHub Actions compatibility, two environmental variables are looked for: `NOT_CRAN`, `SELENIUM_BROWSER`, and `TEST_SERVER`. If the tests are being run locally with the above setup, you can set these environmental variables in `~/.Renviron` or set them in R:

```R
Sys.setenv("NOT_CRAN" = "true")
Sys.setenv("SELENIUM_BROWSER" = "firefox")
Sys.setenv("TEST_SERVER" = "http://test-server:8080")
```
