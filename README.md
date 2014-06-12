# Super Simple Rest API with Grape

A very simple API server using rack and grape.

Its not a complete resource, just one that can have a migration count.
(There's actually nothing to do with Migrations other than its from my
original use case)

You can see the current count with a `GET /v1/migrations`

You can increment the count with a `POST /vi/migrations/inc`  

If you supply a `value` parameter set to a positive integer, it will
increment the count by that `value`. A negative integer will decrement
by that `value`

So its not a full out REST example but it shows how to put together
just about the simplest GRAPE app and its pretty clear how to add more
resources and actions.  This may not be the ultimately RESTful way to
do an increment but hey.

The example setup using rack is just for simple playing around. If you
want to scale you should use something else for the underlying server
as this exmaple just uses the default ruby webrick with rack.

## Dependencies

* rack
* grape

## Install

Use bundler to install the dependencies

```
bundle install
```

## Start the server

```
rackup
```

You should see something like:

```
[2014-06-11 22:02:40] INFO  WEBrick 1.3.1
[2014-06-11 22:02:40] INFO  ruby 2.1.2 (2014-05-08) [x86_64-darwin13.0]
[2014-06-11 22:02:40] INFO  WEBrick::HTTPServer#start: pid=6044 port=9292
```

It will use the default `config.ru` and the default ruby webrick for
the server.

The "application" is in app.rb

## Access the API

When you issue the `rackup` command, webrick will show what port its
running on. In the above example it was `9292` and its running on
localhost. So you can access the service with the host port and get
the current count with the command:

```
curl http://localhost:9292/v1/migrations && echo
```

and you should get:
```
{"count":0}
```

The `&& echo` is there just so that you get the output of the `curl`
command on its own line

You can increment the count with a POST:

```
curl -d "" -H Content-Type:application/json http://localhost:9292/v1/migrations/inc
```

Or increment the count by some value (lets say `5`):

```
curl -d '{"value":-5}' -H Content-Type:application/json http://localhost:9292/v1/migrations/inc
```
