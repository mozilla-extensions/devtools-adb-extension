ARCHS=linux linux64 mac64 win32
MANIFEST=extension/manifest.json

VERSION=`grep -Eo '"version"\:\s*"[^"]+' $(MANIFEST) | grep -Eo '[0-9].*'`

define build-xpis
	cd extension; \
	for arch in $(ARCHS); do \
		echo "build dist/$$arch-$(VERSION).xpi"; \
		zip ../dist/$$arch-$(VERSION).xpi -r $$arch adb.json manifest.json; \
	done
endef

define clean
	echo "Remove previous xpi files"; \
	rm -f *.xpi \
	rm -f **/*.xpi
endef

# default target, clean previous XPIs and build new ones.
package:
	@$(call clean)
	@$(call build-xpis)

clean:
	@$(call clean)
