ARCHS=linux linux64 mac64 win32

ROOT_PATH=/pub/labs/fxos-simulator/adb-helper/
ROOT_UPDATE_URL=https://ftp.mozilla.org$(ROOT_PATH)

VERSION=1.0

define build-xpis
	cd extension; \
	for arch in $(ARCHS); do \
		echo "build dist/$$arch-$(VERSION).xpi"; \
		sed \
			-e 's#@@UPDATE_URL@@#$(ROOT_UPDATE_URL)$$arch/updates.json#' \
			-e 's#@@VERSION@@#$(VERSION)#' \
			template-manifest.json > manifest.json; \
		zip ../dist/$$arch-$(VERSION).xpi -r $$arch adb.json manifest.json; \
		rm manifest.json; \
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
