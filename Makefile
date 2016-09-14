all:
	@echo 'Valid commands are:'
	@echo '  install'

# not sure why xcrun -sdk macosx is required
# is there some way to set the environment variable SDKROOT and get around this?
install:
	xcrun -sdk macosx swiftc pbv.swift -O -o /usr/local/bin/pbv
