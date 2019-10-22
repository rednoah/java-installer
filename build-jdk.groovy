// OpenJDK for x64 Windows / Linux / Mac
def openjdk = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin.tar.gz'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin.tar.gz']
]


// AdoptOpenJDK for JRE
def adoptopenjdk = [
	[type: 'jre', os: 'windows', arch: 'x64', pkg: 'zip'],
	[type: 'jre', os: 'mac',     arch: 'x64', pkg: 'tar.gz']
]


// BellSoft Liberica JDK for embedded devices
def liberica = [
	[os: 'windows', arch: 'x86',     pkg: 'windows-i586.zip'],
	[os: 'linux',   arch: 'x86',     pkg: 'linux-i586.tar.gz'],
	[os: 'linux',   arch: 'aarch64', pkg: 'linux-aarch64.tar.gz'],
	[os: 'linux',   arch: 'armv7l',  pkg: 'linux-arm32-vfp-hflt.tar.gz'],
	[os: 'linux',   arch: 'ppc64le', pkg: 'linux-ppc64le.tar.gz']
]


// Gluon JavaFX
def javafx = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin-sdk.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin-sdk.zip'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin-sdk.zip']
]


// parse version/update/build from release string
def name = properties.product
def (version, build) = properties.release.tokenize(/[+]/)
def (major, minor, update) = version.tokenize(/[.]/)
def uuid = properties.uuid


def sha256(url) {
	try {
		return new URL("${url}.sha256").text.tokenize().first()
	} catch(e) {
		println e
	}

	try {
		return new URL("${url}.sha256.txt").text.tokenize().first()
	} catch(e) {
		println e
	}

	def file = new File('cache', url.tokenize('/').last())
	new AntBuilder().get(src: url, dest: file, skipExisting: 'yes')
	return file.bytes.digest('SHA-256').padLeft(64, '0')
}


// generate properties file
ant.propertyfile(file: 'build-jdk.properties', comment: "${name} ${version} binaries") {
	entry(key: 'jdk.name', value: name)
	entry(key: 'jdk.version', value: version)

	openjdk.each{ jdk ->
		jdk.with {
			def url = "https://download.java.net/java/GA/jdk${version}/${uuid}/${build}/GPL/openjdk-${version}_${pkg}"
			def checksum = sha256(url)

			entry(key:"jdk.${os}.${arch}.url", value: url)
			entry(key:"jdk.${os}.${arch}.sha256", value: checksum)
		}
	}

	adoptopenjdk.each{ jre ->
		jre.with {
			// def url = "https://github.com/AdoptOpenJDK/openjdk${major}-binaries/releases/download/jdk-${version}+${build}/OpenJDK${major}U-${type}_${arch}_${os}_hotspot_${version}_${build}.${pkg}"
			// def checksum = sha256(url)

			entry(key:"jre.${os}.${arch}.url", value: url)
			entry(key:"jre.${os}.${arch}.sha256", value: checksum)
		}
	}

	liberica.each{ jdk ->
		jdk.with {
			def url = "https://download.bell-sw.com/java/${version}/bellsoft-jdk${version}-${pkg}"
			def checksum = sha256(url)

			entry(key:"jdk.${os}.${arch}.url", value: url)
			entry(key:"jdk.${os}.${arch}.sha256", value: checksum)
		}
	}

	javafx.each{ jfx ->
		jfx.with {
			def url = "https://download2.gluonhq.com/openjfx/${version}/openjfx-${version}_${pkg}"
			def checksum = sha256(url)

			entry(key:"jfx.${os}.${arch}.url", value: url)
			entry(key:"jfx.${os}.${arch}.sha256", value: checksum)
		}
	}
}
