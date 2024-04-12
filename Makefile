ARCHS=linux linux64 mac64 win32

EXTENSION_NAME=adb-extension
# Please keep only three parts in the value of this `VERSION` variable.
# `build-xpis` below will automatically add a forth part.
VERSION=0.0.8

ROOT_PATH=pub/labs/devtools/$(EXTENSION_NAME)
ROOT_UPDATE_URL=https://ftp.mozilla.org/$(ROOT_PATH)

define build-xpis
	pushd extension; \
	index=0; \
	for arch in $(ARCHS); do \
		xpi_name=$(EXTENSION_NAME)-$(VERSION).$$index; \
		echo "[release-$$arch] Create dist/$$arch/ folder"; \
		mkdir -p ../dist/$$arch; \
		echo "[release-$$arch] Create manifest.json"; \
		sed \
			-e "s#@@ARCH@@#$$arch#" \
			-e "s#@@UPDATE_URL@@#$(ROOT_UPDATE_URL)/$$arch/update.json#" \
			-e "s#@@VERSION@@#$(VERSION).$$index#" \
			template-manifest.json > manifest.json; \
		echo "[release-$$arch] ZIP to $$xpi_name-$$arch.xpi"; \
		zip ../dist/$$arch/$$xpi_name-$$arch.xpi -r $$arch adb.json manifest.json; \
		echo "[release-$$arch] Delete temporary manifest.json"; \
		rm manifest.json; \
		echo "[release-$$arch] Create update.json"; \
		sed \
			-e "s#@@UPDATE_LINK@@#$(ROOT_UPDATE_URL)/$$arch/$$xpi_name-$$arch.xpi#" \
			-e "s#@@VERSION@@#$(VERSION).$$index#" \
			../template-update.json > ../dist/$$arch/update.json; \
		index=$$((index + 1)); \
	done; \
	popd
endef

define clean
	for arch in $(ARCHS); do \
		rm -rf dist/$$arch/; \
	done
endef

package:
	@$(call clean)
	@$(call build-xpis)

clean:
	@$(call clean)
