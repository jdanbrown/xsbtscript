#!/usr/bin/env bash
#

XSBT_VERSION='0.11.2'
XSBT_BRANCH='0.11.2'
XSBT_SCALA_VERSION='2.9.1'

CONSCRIPT="https://raw.github.com/n8han/conscript/master/setup.sh"
CONDIR="$HOME/.conscript"
DEMO="https://raw.github.com/paulp/xsbtscript/master/twitter.scala"
XSBTSCRIPT="$HOME/bin/xsbtscript"
XSBTSCRIPT_V="$XSBTSCRIPT-$XSBT_VERSION"

# bail on errors
set -e

# install conscript / xsbt support
export PATH="$HOME/bin:$PATH"
curl "$CONSCRIPT" | sh
cs harrah/xsbt --branch "$XSBT_BRANCH"

# create xsbtscript since "scalas" doesn't work for us
mkdir -p "$HOME/bin"
if [[ ! -e "$XSBTSCRIPT_V" ]]; then
  cat > "$XSBTSCRIPT_V" <<EOM
#!/usr/bin/env bash
#

java $JAVA_OPTS \\
  -XX:MaxPermSize=256m -Xmx2048M -Xss2M \\
  -jar $CONDIR/sbt-launch.jar \\
  @$CONDIR/harrah/xsbt/xsbtscript-$XSBT_VERSION/launchconfig \\
  "\$@"

EOM

fi

# xsbtscript launch config
if [[ ! -d "$CONDIR/harrah/xsbt/xsbtscript-$XSBT_VERSION" ]]; then
  mkdir -p "$CONDIR/harrah/xsbt/xsbtscript-$XSBT_VERSION"
  cat > "$CONDIR/harrah/xsbt/xsbtscript-$XSBT_VERSION/launchconfig" <<EOM
[scala]
  version: $XSBT_SCALA_VERSION

[app]
  org: org.scala-tools.sbt
  name: sbt
  version: $XSBT_VERSION
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

if [[ ! -e "$XSBTSCRIPT" ]]; then
  ln -s "$XSBTSCRIPT_V" "$XSBTSCRIPT"
fi

chmod +x "$XSBTSCRIPT_V"
hash

curl "$DEMO" > "$XSBTSCRIPT-demo.scala"
chmod +x "$XSBTSCRIPT-demo.scala"

"$XSBTSCRIPT-demo.scala"
