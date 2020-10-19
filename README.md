## In order to update:

- Change tag in `generate.bash` to the version to be built
- Run `./generate.bash`.
- Update changelog in `com.tutanota.Tutanota.appdata.xml`.


## Modules

- python2 from shared_modules: apparently required for flatpak-builder to run
- libsecret from shared_modules: used by keytar to access keyrings
- node: to run npm
- tutanota: our app
- metadata: 