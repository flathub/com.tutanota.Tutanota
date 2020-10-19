## In order to update:

- Run `./generate.bash`.
- upload the .tar.gz to the tutanota release with the tag that was built
- open a pull request to this repository with the branch that was created & pushed
- after flatbot built the PR, install & test the flatpak
- merge the PR to master


## Modules
- libsecret from shared_modules: used by keytar to access keyrings
- tutanota: our app
- metadata: changelogs & desktop files
