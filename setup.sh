#!/usr/bin/env bash
#

CONSCRIPT="https://raw.github.com/n8han/conscript/master/setup.sh"
CONDIR="$HOME/.conscript"
DEMO="https://raw.github.com/paulp/xsbtscript/master/twitter.scala"

# bail on errors
set -e

# install conscript / xsbt support
export PATH="$HOME/bin:$PATH"
curl "$CONSCRIPT" | sh
cs harrah/xsbt --branch 0.10

# create xsbtscript since "scalas" doesn't work for us
mkdir -p "$HOME/bin"
if [[ ! -e "$HOME/bin/xsbtscript" ]]; then
  cat > "$HOME/bin/xsbtscript" <<EOM
#!/usr/bin/env bash
#

java $JAVA_OPTS \\
  -XX:MaxPermSize=256m -Xmx2048M -Xss2M \\
  -jar $CONDIR/sbt-launch.jar \\
  @$CONDIR/harrah/xsbt/xsbtscript/launchconfig \\
  "\$@"

EOM

fi

# xsbtscript launch config
if [[ ! -d "$CONDIR/harrah/xsbt/xsbtscript" ]]; then
  mkdir -p "$CONDIR/harrah/xsbt/xsbtscript"
  cat > "$CONDIR/harrah/xsbt/xsbtscript/launchconfig" <<EOM
[scala]
  version: 2.8.1

[app]
  org: org.scala-tools.sbt
  name: sbt
  version: 0.10.0
  class: sbt.ScriptMain
  components: xsbti
  cross-versioned: true

[repositories]
  local
  maven-local
  typesafe-ivy-releases: http://repo.typesafe.com/typesafe/ivy-releases/, [organization]/[module]/[revision]/[type]s/[artifact](-[classifier]).[ext]
  maven-central
  scala-tools-releases
  scala-tools-snapshots

[boot]
  directory: $CONDIR/boot
EOM

fi

chmod +x "$HOME/bin/xsbtscript"
hash

curl "$DEMO" > "$HOME/bin/xsbtscript-demo.scala"
chmod +x "$HOME/bin/xsbtscript-demo.scala"

"$HOME/bin/xsbtscript-demo.scala"
