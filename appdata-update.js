#!/bin/node
const fs = require('fs')

const [version, date, url] = process.argv.slice(2)


const newRelease = `
    <releases>
      <release version="${version}" date="${date}">
        <description>
          ${url}
        </description>
      </release>`

const appdata = fs.readFileSync('./com.tutanota.Tutanota.appdata.xml', "utf8")
    .replace(/<releases>/g, newRelease)

try {
    fs.unlinkSync('com.tutanota.Tutanota.appdata.xml.tmp')
} catch {
}
fs.writeFileSync('com.tutanota.Tutanota.appdata.xml.tmp', appdata)
