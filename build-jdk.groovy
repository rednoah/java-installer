def platforms = [
	[type: 'jdk', os: 'windows', arch: 'x64', pkg: 'zip'],
	[type: 'jdk', os: 'osx',     arch: 'x64', pkg: 'tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'x64', pkg: 'tar.gz']
]

// parse version/update/build from release string
def name    = properties.product
def (version, build) = properties.release.tokenize('[+]')
def (major) = version.tokenize('[.]')

// generate properties file
ant.propertyfile(file: 'build-jdk.properties', comment: "${name} ${version} binaries") {
	entry(key:"jdk.name", value: name)
	entry(key:"jdk.version", value: version)

	platforms.each{ jdk ->
		jdk.with {
			def url = "https://download.java.net/java/GA/jdk${major}/${build}/GPL/openjdk-${version}_${os}-${arch}_bin.${pkg}"
			def checksum = new URL("${url}.sha256").text.trim()

			entry(key:"${type}.${os}.${arch}.url", value: url)
			entry(key:"${type}.${os}.${arch}.sha256", value: checksum)
		}
	}
}
