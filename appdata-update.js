#!/bin/node
const fs = require('fs')

const [version, date, url] = process.argv.slice(2)


const newRelease = `
    <releases>
      <release version="${version}" date="${date}">
        <description>
	  <p>
	    Check out the release notes on GitHub:
        ${url}
	  </p>
        </description>
      </release>`

const appdata = fs.readFileSync('./com.tutanota.Tutanota.appdata.xml', "utf8")
    .replace(/<releases>/g, newRelease)

try {
    fs.unlinkSync('com.tutanota.Tutanota.appdata.xml.tmp')
} catch {
}
fs.writeFileSync('com.tutanota.Tutanota.appdata.xml.tmp', appdata)
