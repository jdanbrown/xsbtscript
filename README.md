This worked on Jun 29 2011 at 12:58PM.
If the time is presently later than that, who knows.

    curl https://raw.github.com/paulp/xsbtscript/0.10.0/setup.sh | sh

What will it do? It will, even if you have nothing whatsoever on your machine but curl (no sbt, no conscript, no ~/.ivy2, no ~/bin, etc)

 - download a bunch of stuff
 - create some programs in ~/bin
 - download and run the twitter demo

The point of it all is that you want to be able to run programs which look like the following.  All the dependencies are expressed inline and handled automatically.

```scala
#!/usr/bin/env xsbtscript
!#

/***
scalaVersion := "2.9.0-1"

libraryDependencies ++= Seq(
  "net.databinder" %% "dispatch-twitter" % "0.8.3",
  "net.databinder" %% "dispatch-http" % "0.8.3"
)
*/

import dispatch.{ json, Http, Request }
import dispatch.twitter.Search
import json.{ Js, JsObject }

def process(param: JsObject) = {
  val Search.text(txt)        = param
  val Search.from_user(usr)   = param
  val Search.created_at(time) = param

  "(" + time + ")" + usr + ": " + txt
}

Http.x((Search("#scala") lang "en") ~> (_ map process foreach println))
```

If it works, you'll see some twitter search results for #scala.
