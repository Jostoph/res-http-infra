# Teaching-HEIGVD-RES-2018-Labo-HTTPInfra

# Report

## Step 1: Static HTTP server with apache httpd

### Demo

You can launch the demo by running the following script: `docker-images/apache-php-image/run.sh`

It will build the image and run the container.

Then, you'll be able to access the web page at port 9090 in a web browser. The IP depends on your configuration, here are some examples: http://192.168.99.100:9090/ or http://localhost:9090/

You can also access it with `telnet` using the following command (IP depends on your configuration) : `telnet localhost 9090` and after `GET / HTTP/1.0`

### Theme

We used the following theme https://startbootstrap.com/themes/creative/

### Dockerfile

We build an image from the official php image. Here https://hub.docker.com/_/php

We copy our static web content inside `/var/www/html/`

### Apache configuration

If you access the container in interactive mode, you'll find the apache configuration here `/etc/apache2/ ` more specifically `apache2.confg` and `/sites-available`, `/sites-enabled`.

## Step 2: Dynamic HTTP server with express.js

### Demo

You can launch the demo by running the following script: `docker-images/express-image/run.sh`

It will build the image and run the container.

Then, you'll be able to access the web page at port 9091 in a web browser. The IP depends on your configuration, here are some examples: http://192.168.99.100:9091/ or http://localhost:9091/

You can also access it with `telnet` using the following command (IP depends on your configuration) : `telnet localhost 9091` and after `GET / HTTP/1.0`. Since the server sends back a json array, you may find more comfortable to use Postman (because of auto-indent).

### JSON Payload

We generate animals with species, gender, name, profession and country. Then we use a method to generate a few of them (A quantity between 1 and 10).

Here is an example of payload. 

```json
[
    {
        "species": "Vaquita",
        "gender": "Male",
        "name": "Mr. Douglas Edwards",
        "profession": "Lead EEO Compliance Manager",
        "country": "Botswana"
    },
    {
        "species": "Harbor Porpoise",
        "gender": "Female",
        "name": "Mrs. Annie Thomas",
        "profession": "Junior Computer Operator",
        "country": "Benin"
    },
    {
        "species": "Whistler",
        "gender": "Male",
        "name": "Mr. Stephen Lamb",
        "profession": "Senior Fashion Merchandiser",
        "country": "Bulgaria"
    }
]
```

## Step 3: Reverse proxy with apache (static configuration)

### Demo

#### Before your start

You may want to add `192.168.99.100 demo.res.ch` in your hosts file. This is dependent of your environment. It could be for example `/etc/hosts`

If you want to test with telnet only, you should add the host section. Here is an example :

```
telnet 192.168.99.100 8080
GET / HTTP/1.0
Host: demo.res.ch
```

As mentionned in the previous section, the IP depends on your configuration. 

#### Running the demo

You can launch the demo by running the following script: `docker-images/apache-static-reverse-proxy/run.sh`  *(we've put the old configuration with static IP in this folder, the other one concerns the point 5 )*

It will build three images and run them. The two from step 1 and 2 (in background), and the new one which is a reverse proxy. 

> Warning: It's configured with hardcoded IPs. Depending on what is running on your machine, something could go wrong.

Then, you'll be able to both:

* [http://demo.res.ch:8080/api/animals/](http://demo.res.ch:8080/api/animals/)
* [http://demo.res.ch:8080/](http://demo.res.ch:8080/)

None of the containers (static and dynamic) can be accessed directly. Since the script doesn't have any port mapping for those two.

#### Why it's a fragile configuration

Anything from another Docker running, having to relaunch a docker, etc. would compromise the reverse proxy's configuration. The IPs are hardcoded for testing purposes. We have to find a way to dynamically adapt this configuration.

## Step 4: AJAX requests with JQuery

### Demo

Using the same script as the previous step `docker-images/apache-reverse-proxy/run.sh` you can run the demo.

By accessing http://demo.res.ch:8080/ you should see a paragraph automatically getting updated. It should look something like this example: 

```
Hello there! I'm Miss Winifred Stokes, a Tyrant Flycatcher currently working as Apprentice Microbiologist in Northern Mariana Islands
```

It is updated every 6 seconds so a user has time to read. You can see the AJAX requests with the developpers tool in the section `network > XHR`

#### Why you'd get an error without a reverse proxy

Because of the **same-origin policy**.  For security reasons, your browser restricts cross-origin HTTP requests. 

## Step 5: Dynamic reverse proxy configuration

### Replacing static configuration

As presented in the webcast, we used a PHP script to inject env variables. If you inspect `apache2-foreground` file, you'll see the following line:

```sh
php /var/apache2/templates/config-template.php > /etc/apache2/sites-available/001-reverse-proxy.conf
```

which allows us to do this particular task. It will modify `001-reverse-proxy.conf` so it has the correct IPs in it.

### Demo

You can launch the demo by running the following script: `docker-images/apache-reverse-proxy/run.sh`

The docker Ip addresses of the static and dynamic applications are automatically retrived by inspecting the containers after they are started and are used in the reverse proxy run arguments `STATIC_APP` and `DYNAMIC_APP`.

You could as well launch multiple docker images on your own, and then start the reverse proxy with:

```
docker run -e STATIC_APP=172.17.0.X:80 -e DYNAMIC_APP=172.17.0.Y:3000 --name apache_rp -p 8080:80 res/apache_rp
```


## Additional steps

### Load balancing, Sticky-Session

In order to implement these features, we used [Traefik](https://traefik.io/). It is a modern reverse-proxy and load balancer written in Go. It supports both Weighted Round Robin and Dynamic Round Robin.

It uses a concept of entrypoint to forward correctly to the correct microservice. 

You can run the demo by using the script `docker-images/start-demo.sh`. 

It will use a `docker-compose.yml` to launch Traefik and multiple containers of both the web page and the express image.

We passed an argument so you have access to the API web page to see it in action. To see it, simply go to `demo.res.ch:8080` *(this is the specific port used by Traefik for this purpose)*. You'll be able to see the same "service" with many containers and each having a different IP.

You can specify if you want sticky sessions like this `-"traefik.backend.loadbalancer.sticky=true"` as you can see in the `docker-compose.yml` file.

### Management UI

For this final step, we used [Portainer](https://hub.docker.com/r/portainer/portainer/). We mapped it to `demo.res.ch:9000`. It is a GUI manager for Docker. We added it directly inside of the docker-compose so you don't have to do anything more except creating a local account the first time you want to access the management page.

On the left side menu, you'll see "Containers". From here, you'll be able to monitor all your docker containers. In addition, you can easily run, kill, stop, remove,…

---

## Objectives

The first objective of this lab is to get familiar with software tools that will allow us to build a **complete web infrastructure**. By that, we mean that we will build an environment that will allow us to serve **static and dynamic content** to web browsers. To do that, we will see that the **apache httpd server** can act both as a **HTTP server** and as a **reverse proxy**. We will also see that **express.js** is a JavaScript framework that makes it very easy to write dynamic web apps.

The second objective is to implement a simple, yet complete, **dynamic web application**. We will create **HTML**, **CSS** and **JavaScript** assets that will be served to the browsers and presented to the users. The JavaScript code executed in the browser will issue asynchronous HTTP requests to our web infrastructure (**AJAX requests**) and fetch content generated dynamically.

The third objective is to practice our usage of **Docker**. All the components of the web infrastructure will be packaged in custom Docker images (we will create at least 3 different images).

## General instructions

* This is a **BIG** lab and you will need a lot of time to complete it. This is the last lab of the semester (but it will keep us busy for a few weeks!).
* We have prepared webcasts for a big portion of the lab (**what can get you the "base" grade of 4.5**).
* To get **additional points**, you will need to do research in the documentation by yourself (we are here to help, but we will not give you step-by-step instructions!). To get the extra points, you will also need to be creative (do not expect complete guidelines).
* The lab can be done in **groups of 2 students**. You will learn very important skills and tools, which you will need to next year's courses. You cannot afford to skip this content if you want to survive next year.
* Read carefully all the **acceptance criteria**.
* We will request demos as needed. When you do your **demo**, be prepared to that you can go through the procedure quickly (there are a lot of solutions to evaluate!)
* **You have to write a report. Please do that directly in the repo, in one or more markdown files. Start in the README.md file at the root of your directory.**
* The report must contain the procedure that you have followed to prove that your configuration is correct (what you would do if you were doing a demo)


## Step 1: Static HTTP server with apache httpd

### Webcasts

* [Labo HTTP (1): Serveur apache httpd "dockerisé" servant du contenu statique](https://www.youtube.com/watch?v=XFO4OmcfI3U)

### Acceptance criteria

* You have a GitHub repo with everything needed to build the Docker image.
* You can do a demo, where you build the image, run a container and access content from a browser.
* You have used a nice looking web template, different from the one shown in the webcast.
* You are able to explain what you do in the Dockerfile.
* You are able to show where the apache config files are located (in a running container).
* You have **documented** your configuration in your report.

## Step 2: Dynamic HTTP server with express.js

### Webcasts

* [Labo HTTP (2a): Application node "dockerisée"](https://www.youtube.com/watch?v=fSIrZ0Mmpis)
* [Labo HTTP (2b): Application express "dockerisée"](https://www.youtube.com/watch?v=o4qHbf_vMu0)

### Acceptance criteria

* You have a GitHub repo with everything needed to build the Docker image.
* You can do a demo, where you build the image, run a container and access content from a browser.
* You generate dynamic, random content and return a JSON payload to the client.
* You cannot return the same content as the webcast (you cannot return a list of people).
* You don't have to use express.js; if you want, you can use another JavaScript web framework or event another language.
* You have **documented** your configuration in your report.


## Step 3: Reverse proxy with apache (static configuration)

### Webcasts

* [Labo HTTP (3a): reverse proxy apache httpd dans Docker](https://www.youtube.com/watch?v=WHFlWdcvZtk)
* [Labo HTTP (3b): reverse proxy apache httpd dans Docker](https://www.youtube.com/watch?v=fkPwHyQUiVs)
* [Labo HTTP (3c): reverse proxy apache httpd dans Docker](https://www.youtube.com/watch?v=UmiYS_ObJxY)


### Acceptance criteria

* You have a GitHub repo with everything needed to build the Docker image for the container.
* You can do a demo, where you start from an "empty" Docker environment (no container running) and where you start 3 containers: static server, dynamic server and reverse proxy; in the demo, you prove that the routing is done correctly by the reverse proxy.
* You can explain and prove that the static and dynamic servers cannot be reached directly (reverse proxy is a single entry point in the infra). 
* You are able to explain why the static configuration is fragile and needs to be improved.
* You have **documented** your configuration in your report.

## Step 4: AJAX requests with JQuery

### Webcasts

* [Labo HTTP (4): AJAX avec JQuery](https://www.youtube.com/watch?v=fgpNEbgdm5k)

### Acceptance criteria

* You have a GitHub repo with everything needed to build the various images.
* You can do a complete, end-to-end demonstration: the web page is dynamically updated every few seconds (with the data coming from the dynamic backend).
* You are able to prove that AJAX requests are sent by the browser and you can show the content of th responses.
* You are able to explain why your demo would not work without a reverse proxy (because of a security restriction).
* You have **documented** your configuration in your report.

## Step 5: Dynamic reverse proxy configuration

### Webcasts

* [Labo HTTP (5a): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=iGl3Y27AewU)
* [Labo HTTP (5b): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=lVWLdB3y-4I)
* [Labo HTTP (5c): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=MQj-FzD-0mE)
* [Labo HTTP (5d): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=B_JpYtxoO_E)
* [Labo HTTP (5e): configuration dynamique du reverse proxy](https://www.youtube.com/watch?v=dz6GLoGou9k)

### Acceptance criteria

* You have a GitHub repo with everything needed to build the various images.
* You have found a way to replace the static configuration of the reverse proxy (hard-coded IP adresses) with a dynamic configuration.
* You may use the approach presented in the webcast (environment variables and PHP script executed when the reverse proxy container is started), or you may use another approach. The requirement is that you should not have to rebuild the reverse proxy Docker image when the IP addresses of the servers change.
* You are able to do an end-to-end demo with a well-prepared scenario. Make sure that you can demonstrate that everything works fine when the IP addresses change!
* You are able to explain how you have implemented the solution and walk us through the configuration and the code.
* You have **documented** your configuration in your report.

## Additional steps to get extra points on top of the "base" grade

### Load balancing: multiple server nodes (0.5pt)

* You extend the reverse proxy configuration to support **load balancing**. 
* You show that you can have **multiple static server nodes** and **multiple dynamic server nodes**.
* You prove that the **load balancer** can distribute HTTP requests between these nodes.
* You have **documented** your configuration and your validation procedure in your report.

### Load balancing: round-robin vs sticky sessions (0.5 pt)

* You do a setup to demonstrate the notion of sticky session.
* You prove that your load balancer can distribute HTTP requests in a round-robin fashion to the dynamic server nodes (because there is no state).
* You prove that your load balancer can handle sticky sessions when forwarding HTTP requests to the static server nodes.
* You have documented your configuration and your validation procedure in your report.

### Dynamic cluster management (0.5 pt)

* You develop a solution, where the server nodes (static and dynamic) can appear or disappear at any time.
* You show that the load balancer is dynamically updated to reflect the state of the cluster.
* You describe your approach (are you implementing a discovery protocol based on UDP multicast? are you using a tool such as serf?)
* You have documented your configuration and your validation procedure in your report.

### Management UI (0.5 pt)

* You develop a web app (e.g. with express.js) that administrators can use to monitor and update your web infrastructure.
* You find a way to control your Docker environment (list containers, start/stop containers, etc.) from the web app. For instance, you use the Dockerode npm module (or another Docker client library, in any of the supported languages).
* You have documented your configuration and your validation procedure in your report.
