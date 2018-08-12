ARCHS=linux linux64 mac64 win32
MANIFEST=manifest.json

VERSION=`grep -Eo '"version"\:\s*"[^"]+' $(MANIFEST) | grep -Eo '[0-9].*'`

define build-xpis
	for arch in $(ARCHS); do \
		echo "build $$arch-$(VERSION).xpi"; \
		rm -f $$arch.xpi; \
		zip $$arch-$(VERSION).xpi -r $$arch adb.json $(MANIFEST); \
	done
endef

package:
	@$(call build-xpis)

clean:
	rm -f *.xpi
