#!/usr/bin/env bash
if [ ! -z "${IGNITE_SCRIPT_STRICT_MODE:-}" ]
then
    set -o nounset
    set -o errexit
    set -o pipefail
    set -o errtrace
    set -o functrace
fi

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Remember command line parameters
ARGS=$@

#
# Import common functions.
#
if [ "${IGNITE_HOME:-}" = "" ];
    then IGNITE_HOME_TMP="$(dirname "$(cd "$(dirname "$0")"; "pwd")")";
    else IGNITE_HOME_TMP=${IGNITE_HOME};
fi

#
# Set SCRIPTS_HOME - base path to scripts.
#
SCRIPTS_HOME="${IGNITE_HOME_TMP}/bin"

source "${SCRIPTS_HOME}"/include/functions.sh
source "${SCRIPTS_HOME}"/include/jvmdefaults.sh

#
# Discover path to Java executable and check it's version.
#
checkJava

#
# Discover IGNITE_HOME environment variable.
#
setIgniteHome

#
# Parse command line parameters.
#
. "${SCRIPTS_HOME}"/include/parseargs.sh

#
# Set IGNITE_LIBS.
#
. "${SCRIPTS_HOME}"/include/setenv.sh

CP="${IGNITE_HOME}/bin/include/visor-common/*${SEP}${IGNITE_HOME}/bin/include/visorcmd/*${SEP}${IGNITE_LIBS}"

#
# JVM options. See http://java.sun.com/javase/technologies/hotspot/vmoptions.jsp for more details.
#
# ADD YOUR/CHANGE ADDITIONAL OPTIONS HERE
#
JVM_OPTS="-Xms1g -Xmx1g -server ${JVM_OPTS}"

# Mac OS specific support to display correct name in the dock.
osname=`uname`

if [ "${DOCK_OPTS:-}" == "" ]; then
    DOCK_OPTS="-Xdock:name=Visor - Ignite Shell Console"
fi

#
# Uncomment to set preference for IPv4 stack.
#
# JVM_OPTS="${JVM_OPTS} -Djava.net.preferIPv4Stack=true"

#
# Assertions are disabled by default since version 3.5.
# If you want to enable them - set 'ENABLE_ASSERTIONS' flag to '1'.
#
ENABLE_ASSERTIONS="0"

#
# Set '-ea' options if assertions are enabled.
#
if [ "${ENABLE_ASSERTIONS}" = "1" ]; then
    JVM_OPTS="${JVM_OPTS} -ea"
fi

#
# Save terminal setting. Used to restore terminal on finish.
#
SAVED_STTY=`stty -g 2>/dev/null`

#
# Restores terminal.
#
function restoreSttySettings() {
    stty ${SAVED_STTY}
}

#
# Trap that restores terminal in case script execution is interrupted.
#
trap restoreSttySettings INT

#
# Final JVM_OPTS for Java 9+ compatibility
#
JVM_OPTS=$(getJavaSpecificOpts $version "$JVM_OPTS")

#
# Start Visor console.
#
case $osname in
    Darwin*)
        "$JAVA" ${JVM_OPTS} ${QUIET} "${DOCK_OPTS}" \
         -DIGNITE_HOME="${IGNITE_HOME}" -DIGNITE_PROG_NAME="$0" \
        -DIGNITE_DEPLOYMENT_MODE_OVERRIDE=ISOLATED ${JVM_XOPTS} -cp "${CP}" \
        org.apache.ignite.visor.commands.VisorConsole ${ARGS}
    ;;
    *)
        "$JAVA" ${JVM_OPTS} ${QUIET}  \
        -DIGNITE_HOME="${IGNITE_HOME}" -DIGNITE_PROG_NAME="$0" -DIGNITE_DEPLOYMENT_MODE_OVERRIDE=ISOLATED \
        ${JVM_XOPTS} -cp "${CP}" \
        org.apache.ignite.visor.commands.VisorConsole ${ARGS}
    ;;
esac

#
# Restore terminal.
#
restoreSttySettings
