#!/usr/bin/env bash
#

# NOTE:
# This doesn't work as is on Windows. You'll need to create an equivalent `.bat` file instead
#
# NOTE:
# If you're not using Linux you'll need to adjust the `-configuration` option
# to point to the `config_mac' or `config_win` folders depending on your system.

# case Darwin in
# Linux)
# 	CONFIG="$HOME/.local/share/nvim/lsp_servers/jdtls/config_linux"
# 	;;
# Darwin)
# 	CONFIG="$HOME/.local/share/nvim/lsp_servers/jdtls/config_mac"
# 	;;
# esac


# # Check if JAVA_HOME is set correctly and JAVA executable exists
# if [ -x "$JAVA_HOME/bin/java" ]; then
#     JAVACMD="$JAVA_HOME/bin/java"
# else
#     echo "ERROR: 'java' command could not be found in your JAVA_HOME. Please check your JAVA_HOME setting."
#     exit 1
# fi
#
# JAR="$(find $HOME/.config/local/share/nvim/mason/packages/jdtls/plugins -name 'org.eclipse.equinox.launcher_*.jar' | head -n 1)"
# if [ -z "$JAR" ]; then
#     echo "ERROR: JDTLS launcher jar not found."
#     exit 1
# fi
#
#
#
# echo "JAVA_HOME: $JAVA_HOME"
# echo "JAVACMD: $JAVACMD"
# echo "JAR: $JAR"
# echo "Workspace directory: $1"
#
# # Remaining script contents...
#
# # Determine the Java command to use to start the JVM.
# if [ -n "$JAVA_HOME" ]; then
# 	if [ -x "$JAVA_HOME/jre/sh/java" ]; then
# 		# IBM's JDK on AIX uses strange locations for the executables
# 		JAVACMD="$JAVA_HOME/jre/sh/java"
# 	else
# 		JAVACMD="$JAVA_HOME/bin/java"
# 	fi
# 	if [ ! -x "$JAVACMD" ]; then
# 		die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME
#
# Please set the JAVA_HOME variable in your environment to match the
# location of your Java installation."
# 	fi
# else
# 	JAVACMD="java"
# 	which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
#
# Please set the JAVA_HOME variable in your environment to match the
# location of your Java installation."
# fi
#
# # JAR="$HOME/.config/nvim/.language-servers/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar"
# # JAR="$HOME/.config/local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
# GRADLE_HOME=$HOME/gradle "$JAVACMD" \
# 	-Declipse.application=org.eclipse.jdt.ls.core.id1 \
# 	-Dosgi.bundles.defaultStartLevel=4 \
# 	-Declipse.product=org.eclipse.jdt.ls.core.product \
# 	-Dlog.protocol=true \
# 	-Dlog.level=ALL \
# 	-javaagent:$HOME/.config/local/share/nvim/mason/share/jdtls/lombok.jar \
# 	-Xms1g \
# 	-Xmx2G \
# 	-jar $(echo "$JAR") \
# 	-data "${1:-$HOME/workspace}" \
# 	--add-modules=ALL-SYSTEM \
# 	--add-opens java.base/java.util=ALL-UNNAMED \
# 	--add-opens java.base/java.lang=ALL-UNNAMED
# 	# -configuration "$CONFIG" \
#
# # for older java versions if you wanna use lombok
# # -Xbootclasspath/a:/usr/local/share/lombok/lombok.jar \
#
# # -javaagent:/usr/local/share/lombok/lombok.jar \

# Ensure JAVA_HOME is correctly defined
if [ -z "$JAVA_HOME" ] || [ ! -x "$JAVA_HOME/bin/java" ]; then
    echo "ERROR: JAVA_HOME is not set or incorrect."
    exit 1
fi
JAVACMD="$JAVA_HOME/bin/java"

# Locate the launcher JAR file
JAR="$(find $HOME/.config/local/share/nvim/mason/packages/jdtls/plugins -name 'org.eclipse.equinox.launcher_*.jar' | head -n 1)"
if [ -z "$JAR" ]; then
    echo "ERROR: JDTLS launcher JAR not found."
    exit 1
fi

# Print configurations for verification
echo "JAVA_HOME: $JAVA_HOME"
echo "JAVACMD: $JAVACMD"
echo "JAR: $JAR"
echo "Workspace directory: ${1:-$HOME/workspace}"

# Start the Java Development Tools Language Server
"$JAVACMD" \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.protocol=true \
    -Dlog.level=ALL \
    -javaagent:$HOME/.config/local/share/nvim/mason/packages/jdtls/lombok.jar \
    -Xms1g \
    -Xmx2G \
    -jar "$JAR" \
    -configuration "$CONFIG" \
    -data "${1:-$HOME/workspace}" \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED
