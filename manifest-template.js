#!/bin/node
const fs = require('fs')

const [hash, url] = process.argv.slice(2)

const manifest = {
	"id": "com.tutanota.Tutanota",
	"runtime": "org.freedesktop.Platform",
	"runtime-version": "23.08",
	"base": "org.electronjs.Electron2.BaseApp",
	"base-version": "23.08",
	"sdk": "org.freedesktop.Sdk",
	"command": "tutanota-desktop",
	"separate-locales": false,
	"finish-args": [
		"--share=ipc",
		"--device=dri",
		"--socket=wayland",
		"--socket=x11",
		"--socket=pulseaudio",
		"--share=network",
		"--talk-name=org.freedesktop.secrets",
		"--talk-name=org.kde.StatusNotifierWatcher",
		"--env=TMPDIR=/var/tmp",
		"--device=all"
	],
	"modules": [
		{
			"name": "libsecret",
			"buildsystem": "meson",
			"config-opts": [
				"-Dmanpage=false",
				"-Dvapi=false",
				"-Dgtk_doc=false",
				"-Dintrospection=false"
			],
			"cleanup": [
				"/bin",
				"/include",
				"/lib/pkgconfig",
				"/share/man"
			],
			"sources": [
				{
					"type": "git",
					"url": "https://github.com/tutao/libsecret.git",
					"commit": "3d18f7e928d6de69457ec3d18d5ca84923191957"
				}
			]
		},
		{
			"name": "tutanota",
			"buildsystem": "simple",
			"sources": [
				{
					"dest-filename": "tutanota-unpacked-linux.tar.gz",
					"type": "file",
					"sha256": hash,
					"url": url
				},
				{
					"type": "script",
					"dest-filename": "tutanota-desktop.sh",
					"commands": [
						"export TMPDIR=\"$XDG_RUNTIME_DIR/app/${FLATPAK_ID}\"",
						"exec zypak-wrapper /app/lib/tutanota/tutanota-desktop --ozone-platform-hint=auto \"$@\""
					]
				}
			],
			"build-commands": [
				"tar -xf tutanota-unpacked-linux.tar.gz",
				"rm tutanota-unpacked-linux.tar.gz",
				"mkdir -p /app/lib/",
				"cp -r linux-unpacked /app/lib/tutanota",
				"install -Dm644 linux-unpacked/resources/icons/icon/512.png /app/share/icons/hicolor/512x512/apps/com.tutanota.Tutanota.png",
				"install -Dm644 linux-unpacked/resources/icons/icon/64.png /app/share/icons/hicolor/64x64/apps/com.tutanota.Tutanota.png",
				"install -Dm755 tutanota-desktop.sh /app/bin/tutanota-desktop",
				"rm -rf ./linux-unpacked"
			]
		},
		{
			"name": "metadata",
			"buildsystem": "simple",
			"sources": [
				{
					"type": "file",
					"path": "com.tutanota.Tutanota.appdata.xml"
				},
				{
					"type": "file",
					"path": "com.tutanota.Tutanota.desktop"
				}
			],
			"build-commands": [
				"install -Dm644 com.tutanota.Tutanota.appdata.xml /app/share/appdata/com.tutanota.Tutanota.appdata.xml",
				"install -Dm644 com.tutanota.Tutanota.desktop /app/share/applications/com.tutanota.Tutanota.desktop"
			]
		}
	]
}

try {
	fs.unlinkSync('com.tutanota.Tutanota.json')
} catch {
}
fs.writeFileSync('com.tutanota.Tutanota.json', JSON.stringify(manifest, null, 2))
