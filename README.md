## ADB Extension

This is a Firefox extension that supports remote debugging in Firefox DevTools.
It provides ADB binaries used by DevTools to connect to Firefox/GeckoView products on Android devices via USB.

### Releases

1. Update the value of the `VERSION` variable in the `Makefile` (and commit the change)
2. Run `make package`. The following files should have been generated in the `dist/` folder:

    ```
    dist
    ├── linux
    │   ├── adb-extension-0.0.7.0-linux.xpi
    │   └── update.json
    ├── linux64
    │   ├── adb-extension-0.0.7.1-linux64.xpi
    │   └── update.json
    ├── mac64
    │   ├── adb-extension-0.0.7.2-mac64.xpi
    │   └── update.json
    └── win32
        ├── adb-extension-0.0.7.3-win32.xpi
        └── update.json
    ```

3. Upload the different XPI files to AMO as unlisted versions. You MUST respect the order of the versions, i.e. start with `linux` (because its version is `0.0.7.0`), then `linux64` (because its version is `0.0.7.1`), etc.
4. Download the signed XPI files. Note that AMO changes the name of the signed XPIs so you have to rename each file individually. For example, uploading `adb-extension-0.0.7.0-linux.xpi` will produce a signed file named `27a75f558d3c46da8dcd-0.0.7.0.xpi`, which you'll need to rename to `adb-extension-0.0.7.0-linux.xpi`.
5. Upload the signed XPI files and their `update.json` files to the FTP server.  Note that we'll want to upload the versioned XPIs (e.g. `adb-extension-0.0.7.3-win32.xpi`) as well as "latest" copies (e.g. `adb-extension-latest-win32.xpi`). You should have the following files to be added to the FTP server:

    ```
    # IMPORTANT: all the XPI files here are signed. They are not the same as above in Step 2.
    # The `update.json` files are coming from the Step 2, though.

    adb-0.0.7
    ├── linux
    │   ├── adb-extension-0.0.7.0-linux.xpi
    │   ├── adb-extension-latest-linux.xpi
    │   └── update.json
    ├── linux64
    │   ├── adb-extension-0.0.7.1-linux64.xpi
    │   ├── adb-extension-latest-linux64.xpi
    │   └── update.json
    ├── mac64
    │   ├── adb-extension-0.0.7.2-mac64.xpi
    │   ├── adb-extension-latest-mac64.xpi
    │   └── update.json
    └── win32
        ├── adb-extension-0.0.7.3-win32.xpi
        ├── adb-extension-latest-win32.xpi
    └── update.json
    ```

### Discussion

For questions and issues specific to this extension, you can use the [GitHub issue tracker](https://github.com/mozilla/devtools-adb-extension/issues).

For more general questions about remote debugging in DevTools or DevTools in general, you can:
- come chat with us on [Slack](https://devtools-html-slack.herokuapp.com/) or IRC (#devtools at irc.mozilla.org)
- file bugs on [Bugzilla](https://bugzilla.mozilla.org/enter_bug.cgi?product=DevTools)
