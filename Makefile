PROJECT_BASE = project
BAL_FILES = $(shell find $(PROJECT_BASE) -type f -name '*.bal')
BUILD_JAR_FILES = $(PROJECT_BASE)/target/bin/*.jar

$(BUILD_JAR_FILES): $(BAL_FILES)
	@bal version
	@cd $(PROJECT_BASE) && (bal build --skip-tests || (test -f ballerina-internal.log && cat ballerina-internal.log 1>&2))

execute: $(BUILD_JAR_FILES)
	@echo "Starting application..."
	@BALLERINA_MAX_POOL_SIZE=10 java -XX:TieredStopAtLevel=1 -Djdk.tls.client.protocols=TLSv1.2 -jar $(BUILD_JAR_FILES) || (test -f ballerina-internal.log && cat ballerina-internal.log 1>&2)
	@echo "Application exited"

test:
	@cd $(PROJECT_BASE) && (bal test || (test -f ballerina-internal-tests.log && cat ballerina-internal-tests.log 1>&2))
