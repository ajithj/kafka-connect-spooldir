#!/usr/bin/env bash
#
# Copyright © 2016 Jeremy Custenborder (jcustenborder@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

: ${SUSPEND:='n'}
: ${INPUT_PATH:='/tmp/spooldir/input'}
: ${ERROR_PATH:='/tmp/spooldir/error'}
: ${FINISHED_PATH:='/tmp/spooldir/finished'}

set -e

mvn clean package
export KAFKA_JMX_OPTS="-Xdebug -agentlib:jdwp=transport=dt_socket,server=y,suspend=${SUSPEND},address=5005"
export CLASSPATH="$(find target/kafka-connect-target/usr/share/java -type f -name '*.jar' | tr '\n' ':')"

if [ ! -d "${INPUT_PATH}" ]; then
    mkdir -p "${INPUT_PATH}"
fi

if [ ! -d "${ERROR_PATH}" ]; then
    mkdir -p "${ERROR_PATH}"
fi

if [ ! -d "${FINISHED_PATH}" ]; then
    mkdir -p "${FINISHED_PATH}"
fi

cp src/test/resources/com/github/jcustenborder/kafka/connect/spooldir/csv/FieldsMatch.data "${INPUT_PATH}/FieldsMatch.csv"

connect-standalone config/connect-avro-docker.properties config/CSVExample.properties