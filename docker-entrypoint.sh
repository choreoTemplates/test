#!/bin/bash

#  Copyright (c) 2020, WSO2 Inc. (http://www.wso2.com). All Rights Reserved.
#
#  This software is the property of WSO2 Inc. and its suppliers, if any.
#  Dissemination of any information or reproduction of any material contained
#  herein is strictly forbidden, unless permitted by WSO2 in accordance with
#  the WSO2 Commercial License available at http://wso2.com/licenses.
#  For specific language governing the permissions and limitations under
#  this license, please see the license as well as any agreement you’ve
#  entered into with WSO2 governing the purchase of this software and any
#  associated services.

# retrieve containerId
containerId="$(grep "memory:/" < /proc/self/cgroup | sed 's|.*/||')"
# export CHOREO_EXT_LOG_LEVEL="DEBUG"

# verify the containerId
if [ -z "$containerId" ]; then
  echo "[WARN] containerId is not found. Using a random uuid as the nodeId"
else
  export CHOREO_EXT_NODE_ID="$containerId"
fi

# start the user application
export BALLERINA_MAX_POOL_SIZE=10
# fixme: remove forcing TLS 1.2 when we update jre version. See https://github.com/wso2-enterprise/choreo/issues/7511
java -XX:MaxRAMPercentage=80 -XX:TieredStopAtLevel=1 -Djdk.tls.client.protocols=TLSv1.2 -jar *.jar \
  || (test -f ballerina-internal.log && cat ballerina-internal.log 1>&2)
