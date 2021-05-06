// OpenJDK for x64 Mac
def openjdk = []


// BellSoft Liberica JDK/JRE for embedded devices
def liberica = [
	[type: 'jdk', os: 'linux',   arch: 'aarch64', pkg: 'linux-aarch64.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'armv7l',  pkg: 'linux-arm32-vfp-hflt.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'ppc64le', pkg: 'linux-ppc64le.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'x86',     pkg: 'linux-i586.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'x64',     pkg: 'linux-amd64.tar.gz'],	
	[type: 'jdk', os: 'windows', arch: 'x86',     pkg: 'windows-i586.zip'],
	[type: 'jdk', os: 'windows', arch: 'x64',     pkg: 'windows-amd64.zip'],
	[type: 'jdk', os: 'mac',     arch: 'x64',     pkg: 'macos-amd64.zip'],
	[type: 'jre', os: 'linux',   arch: 'aarch64', pkg: 'linux-aarch64.tar.gz'],
	[type: 'jre', os: 'linux',   arch: 'armv7l',  pkg: 'linux-arm32-vfp-hflt.tar.gz'],
	[type: 'jre', os: 'linux',   arch: 'ppc64le', pkg: 'linux-ppc64le.tar.gz'],
	[type: 'jre', os: 'linux',   arch: 'x86',     pkg: 'linux-i586.tar.gz'],
	[type: 'jre', os: 'linux',   arch: 'x64',     pkg: 'linux-amd64.tar.gz'],
	[type: 'jre', os: 'windows', arch: 'x86',     pkg: 'windows-i586.zip'],
	[type: 'jre', os: 'windows', arch: 'x64',     pkg: 'windows-amd64.zip'],
	[type: 'jre', os: 'mac',     arch: 'x64',     pkg: 'macos-amd64.zip'],
]


// Gluon JavaFX
def javafx = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin-jmods.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin-jmods.zip'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin-jmods.zip']
]


// General Build Properties
def name = properties.product
def version = properties.release


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
		def build = properties.openjdk_build
		jdk.with {
			def url = "https://download.java.net/java/GA/jdk${version}/${build}/GPL/openjdk-${version}_${pkg}"
			def checksum = sha256(url)

			entry(key:"jdk.${os}.${arch}.url", value: url)
			entry(key:"jdk.${os}.${arch}.sha256", value: checksum)
		}
	}

	liberica.each{ jdk ->
		def build = properties.liberica_build
		jdk.with {
			def url = "https://download.bell-sw.com/java/${build}/bellsoft-${type}${build}-${pkg}"
			def checksum = sha256(url)

			entry(key:"${type}.${os}.${arch}.url", value: url)
			entry(key:"${type}.${os}.${arch}.sha256", value: checksum)
		}
	}

	javafx.each{ jfx ->
		def build = properties.openjfx_build
		jfx.with {
			def url = "https://download2.gluonhq.com/openjfx/${build}/openjfx-${build}_${pkg}"
			def checksum = sha256(url)

			entry(key:"jfx.${os}.${arch}.url", value: url)
			entry(key:"jfx.${os}.${arch}.sha256", value: checksum)
		}
	}
}
