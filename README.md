# Downloading

It is easiest to do this with ftp directly, the ruby interface does not support mget.

1. start ftp
1. `prompt` turns off interactive mode
1. make sure the local dirs are all present (don't know how the `! mkdir directory` option works)
1. run something like `$ mget public_html/**/*`
1. verify all files have been copied