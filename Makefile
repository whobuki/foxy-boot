ABI := armeabi-v7a arm64-v8a x86 x86_64
NDK := /usr/bin
NDK_FLAGS :=

.PHONY: all clean ndk-build

all: foxy-boot.zip

clean:
	rm -rfv libs obj magisk/bootanimation-* foxy-boot.zip

ndk-build:
	$(NDK)/ndk-build $(NDK_FLAGS) APP_ABI="$(ABI)"

$(ABI:%=libs/%/bootanimation): ndk-build

$(ABI:%=magisk/bootanimation-%): magisk/bootanimation-%: libs/%/bootanimation
	sed -e 's/libc++_shared.so/libc++.so\x00\x00\x00\x00\x00\x00\x00/' < $< > $@

foxy-boot.zip: $(ABI:%=magisk/bootanimation-%)
	rm -f foxy-boot.zip
	(cd magisk && zip ../foxy-boot.zip -r . -x .git\*)
