
electron_version = 1.4.14

PATH := node_modules/.bin:$(PATH)

app_version = $(shell node -p "require('./package.json').version")
arch = $(shell uname -m)
platform = linux
compression =

.PHONY: all clean default

default: $(arch)

all: x64 ia32 armv7l win32 win64

# 32-bit x86
i386: ia32
i686: ia32
ia32: electron_arch = ia32
ia32: dist = webjcs-$(platform)-$(electron_arch)
ia32: dest = build/$(dist)
ia32: build-linux-x86_32

# 64-bit x86
x86_64: x64
x64: electron_arch = x64
x64: dist = webjcs-$(platform)-$(electron_arch)
x64: dest = build/$(dist)
x64: build-linux-x86_64

# armv7l
armv7h: armv7l
armv7: armv7l
armv7l: electron_arch = armv7l
armv7l: dist = webjcs-$(platform)-$(electron_arch)
armv7l: dest = build/$(dist)
armv7l: build-linux-armv7l

build-linux-%:
	@echo "Building $(dist)"
	rm -rf "$(dest)" "$(dest).tar.gz"
	@mkdir -pv "$(dest)"
	@#cp -v scripts/launch.sh "$(dest)/"
	scripts/build.js $(electron_arch) $(electron_version) $(platform)

	@echo $(app_version) > "$(dest)/version"
	@echo "Build finished $(dist)"
	@if [ "$(compress)" != "" ]; then\
		cd "$(dest)";\
		echo "Compressing...";\
		tar -czf "../$(dist).tar.gz" .;\
	fi

# win32
win32: platform = win32
win32: electron_arch = ia32
win32: dist = webjcs-$(platform)-$(electron_arch)
win32: dest = build/$(dist)
win32: build-win32

# win64
win64: platform = win32
win64: electron_arch = x64
win64: dist = webjcs-$(platform)-$(electron_arch)
win64: dest = build/$(dist)
win64: build-win64

build-win%:
	@echo "Building $(dist)"
	rm -rf "$(dest)" "$(dest).zip"
	@mkdir -pv "$(dest)"
	@#cp -v scripts/launch.sh "$(dest)/"
	scripts/build.js $(electron_arch) $(electron_version) $(platform)

	@echo $(app_version) > "$(dest)/version"
	@echo "Build finished $(dist)"
	@if [ "$(compress)" != "" ]; then\
		cd "$(dest)";\
		echo "Compressing...";\
		zip -rq -9 "../$(dist).zip" .;\
	fi

# darwin 64-bit
darwin64: platform = darwin
darwin64: electron_arch = x64
darwin64: dist = webjcs-$(platform)-$(electron_arch)
darwin64: dest = build/$(dist)
darwin64: build-darwin64

build-darwin%:
	@echo "Building $(dist)"
	rm -rf "$(dest)" "$(dest).zip"
	@mkdir -pv "$(dest)"
	@#cp -v scripts/launch.sh "$(dest)/"
	scripts/build.js $(electron_arch) $(electron_version) $(platform)

	@echo $(app_version) > "$(dest)/version"
	@echo "Build finished $(dist)"
	@if [ "$(compress)" != "" ]; then\
		cd "$(dest)";\
		echo "Compressing...";\
		zip -rq -9 "../$(dist).zip" .;\
	fi

cleanbuild:
	rm -rf build

cleancache:
	rm -rf cache

clean: cleanbuild cleancache
