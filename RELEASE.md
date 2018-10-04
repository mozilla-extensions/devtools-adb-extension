# Release a new version

1) Update extension version

The current version on github should already be `${YOUR_VERSION}pre`.
The version is set in `Makefile` header, in a `VERSION` variable.
So your first task will be to remove the `pre` suffix.
For example, if we were about to release 0.12.1, Makefile should already be set to:
```
  VERSION=0.12.1pre
```
And, while releasing, you have to update that variable to:
```
  VERSION=0.12.1
```

2) Commit that change

```
$ git commit -m "Release 0.12.1" Makefile
```

3) Get AWS keys to sign *and* upload the extension

For all the informations about how to sign the extension, and get keys, see:
  https://mana.mozilla.org/wiki/display/SVCOPS/Sign+a+Mozilla+Internal+Extension
To get keys used for uploading the extension, please use this bug as a template for you:
  https://bugzilla.mozilla.org/show_bug.cgi?id=1481123

4) Build the extension

This step is simple, just do:
```
  $ make
```
It will create under the dist/ folder:
- `adb-extension-0.12.1-linux.xpi`
- `adb-extension-0.12.1-linux64.xpi`
- `adb-extension-0.12.1-win32.xpi`
- `adb-extension-0.12.1-mac64.xpi`.

5) Setup `sign-xpi` tool, used to sign the extension

```
  git clone https://github.com/mozilla-services/sign-xpi/
  # We need to checkout this revision since we are currently updating and testing a new implementation
  cd sign-xpi/cli
  git checkout 291a3e22ddb100772a452264c2827daaf4ac5774
  virtualenv venv
  source venv/bin/activate
  pip install -e .
```

After that, you can verify that `sign-xpi` is in your path by running it:
```
  $ sign-xpi
  Traceback (most recent call last):
    File "/home/alex/adbhelper/sign-xpi/cli/venv/bin/sign-xpi", line 11, in <module>
  ...
    raise NoRegionError()
  botocore.exceptions.NoRegionError: You must specify a region.
```
(`sign-xpi` throws when no arguments are given, but it means it is in your path!)

You may also want to install amazon AWS cli tool, if you don't have it installed yet:
```
  $ pip install awscli --upgrade
```
(Note that it will install it in the virtualenv, and will only be available from it)

You might need to first uninstall it

```
  $ pip uninstall awscli
```

If you get dependency issues with botocore, try uninstalling and reinstalling it as well

```
  $ pip uninstall botocore boto3 && pip install boto3
```


6) Test your extension

In step 3, you should have received two set of signing keys.
One for "production", and another for "stage".
You can use the stage one in order to test your extension.
Pick the xpi file related to your operating system and do:
```
$ SIGN_AWS_SECRET_ACCESS_KEY=xxx SIGN_AWS_ACCESS_KEY_ID=xxx ./sign.sh adb-extension-0.12.1-linux64.xpi
Signing adb-extension-0.12.1-linux64.xpi
{"uploaded": {"bucket": "net-mozaws-prod-addons-signxpi-output", "key": "adb-extension-0.12.1-linux64.xpi"}}
download: s3://net-mozaws-prod-addons-signxpi-output/adb-extension-0.12.1-linux64.xpi to ./adb-extension-0.12.1-linux64.xpi
```
The xpi file should now be signed and be installable in Firefox.
Please test your extension now.

7) Release the extension

If the extension works fine after testing it, you can release it via:
```
  SIGN_AWS_SECRET_ACCESS_KEY=xxx SIGN_AWS_ACCESS_KEY_ID=xxx  AWS_SECRET_ACCESS_KEY=xxx AWS_ACCESS_KEY_ID=xxx make release
```

SIGN_AWS_SECRET_ACCESS_KEY and SIGN_AWS_ACCESS_KEY_ID are the credential to sign the extension,
while AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID are the one to upload it.

8) Push the release to github

```
$ git tag 0.12.1
$ git push upstream 0.12.1
```

9) Update master's current version

Go edit Makefile again to bump to the next "pre" version:
```
  VERSION=0.12.2pre
```
And commit and push that change to master branch:
```
  $ git commit -m "Bump to 0.12.2pre" Makefile
  $ git push upstream HEAD:master
```

