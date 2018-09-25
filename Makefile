ARCHS=linux linux64 mac64 win32

EXTENSION_NAME=adb-extension
VERSION=0.0.3
XPI_NAME=$(EXTENSION_NAME)-$(VERSION)

ROOT_PATH=pub/labs/devtools/$(EXTENSION_NAME)
ROOT_UPDATE_URL=https://ftp.mozilla.org/$(ROOT_PATH)
S3_BASE_URL=s3://net-mozaws-prod-delivery-contrib/$(ROOT_PATH)

define build-xpis
	pushd extension; \
	for arch in $(ARCHS); do \
		echo "[release-$$arch] Create manifest.json"; \
		sed \
			-e "s#@@UPDATE_URL@@#$(ROOT_UPDATE_URL)/$$arch/update.json#" \
			-e "s#@@VERSION@@#$(VERSION)#" \
			template-manifest.json > manifest.json; \
		echo "[release-$$arch] ZIP to $(XPI_NAME)-$$arch.xpi"; \
		zip ../dist/$(XPI_NAME)-$$arch.xpi -r $$arch adb.json manifest.json; \
		echo "[release-$$arch] Delete temporary manifest.json"; \
		rm manifest.json; \
	done; \
	popd
endef

define clean
	echo "Remove previous xpi files"; \
	rm -f **/*.xpi
endef

define release
	pushd dist; \
	for arch in $(ARCHS); do \
		echo "[release-$$arch] Sign .xpi"; \
		../sign.sh $(XPI_NAME)-$$arch.xpi; \
		echo "[release-$$arch] Upload .xpi"; \
		aws s3 cp \
			$(XPI_NAME)-$$arch.xpi \
			$(S3_BASE_URL)/$$arch/$(XPI_NAME)-$$arch.xpi; \
		echo "[release-$$arch] Copy to 'latest' .xpi"; \
		aws s3 cp \
			$(S3_BASE_URL)/$$arch/$(XPI_NAME)-$$arch.xpi \
			$(S3_BASE_URL)/$$arch/adb-extension-latest-$$arch.xpi; \
		echo "[release-$$arch] Create update.json"; \
		sed \
			-e "s#@@UPDATE_LINK@@#$(ROOT_UPDATE_URL)/$$arch/$(XPI_NAME)-$$arch.xpi#" \
			-e "s#@@VERSION@@#$(VERSION)#" \
			../template-update.json > update.json; \
		echo "[release-$$arch] Upload update.json"; \
		aws s3 cp --cache-control max-age=3600 \
			update.json \
			$(S3_BASE_URL)/$$arch/update.json; \
		echo "[release-$$arch] Delete temporary update.json"; \
		rm update.json; \
	done; \
	popd
endef

package:
	@$(call clean)
	@$(call build-xpis)

clean:
	@$(call clean)

release:
	@$(call release)
