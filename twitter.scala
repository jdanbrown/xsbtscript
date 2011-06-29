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
