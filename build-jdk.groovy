// OpenJDK for x64 Windows / Linux / Mac
def openjdk = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin.tar.gz'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin.tar.gz']
]


// BellSoft Liberica JDK for embedded devices
def liberica = [
	[type: 'jdk', os: 'linux',   arch: 'aarch64', pkg: 'linux-aarch64.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'armv7l',  pkg: 'linux-arm32-vfp-hflt.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'ppc64le', pkg: 'linux-ppc64le.tar.gz'],
	// [type: 'jdk', os: 'windows', arch: 'x64',     pkg: 'windows-amd64.zip'],
	[type: 'jre', os: 'windows', arch: 'x64',     pkg: 'windows-amd64.zip'],
	[type: 'jdk', os: 'windows', arch: 'x86',     pkg: 'windows-i586.zip'],
	[type: 'jre', os: 'windows', arch: 'x86',     pkg: 'windows-i586.zip'],
	// [type: 'jdk', os: 'linux',   arch: 'amd64',   pkg: 'linux-amd64.tar.gz'],
	[type: 'jre', os: 'linux',   arch: 'amd64',   pkg: 'linux-amd64.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'x86',     pkg: 'linux-i586.tar.gz'],
	[type: 'jre', os: 'linux',   arch: 'x86',     pkg: 'linux-i586.tar.gz'],
	// [type: 'jdk', os: 'mac',     arch: 'x64',     pkg: 'macos-amd64.zip'],
	[type: 'jre', os: 'mac',     arch: 'x64',     pkg: 'macos-amd64.zip']
]


// Gluon JavaFX
def javafx = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin-sdk.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin-sdk.zip'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin-sdk.zip']
]


// parse version/update/build from release string
def name = properties.product
def release = properties.release
def (version, build) = release.tokenize(/[+]/)
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
			def url = "https://download.java.net/java/GA/jdk${version}/${uuid}/GPL/openjdk-${version}_${pkg}"
			def checksum = sha256(url)

			entry(key:"jdk.${os}.${arch}.url", value: url)
			entry(key:"jdk.${os}.${arch}.sha256", value: checksum)
		}
	}

	liberica.each{ jdk ->
		jdk.with {
			def url = "https://download.bell-sw.com/java/${release}/bellsoft-${type}${release}-${pkg}"
			def checksum = sha256(url)

			entry(key:"${type}.${os}.${arch}.url", value: url)
			entry(key:"${type}.${os}.${arch}.sha256", value: checksum)
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
