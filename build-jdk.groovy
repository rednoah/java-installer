// parse version/update/build from release string
def name    = properties.product
def (version, build) = properties.release.tokenize('[+]')
def (major) = version.tokenize('[.]')


// OpenJDK for x64 Windows / Linux / Mac
def openjdk = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin.tar.gz'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin.tar.gz']
]


// BellSoft Liberica JDK Linux ARM
def liberica = [
	[os: 'linux',   arch: 'aarch64', pkg: 'linux-aarch64-lite.tar.gz'],
	[os: 'linux',   arch: 'armv7l',  pkg: 'linux-arm32-vfp-hflt-lite.tar.gz']
]


// Gluon JavaFX
def javafx = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin-sdk.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin-sdk.zip'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin-sdk.zip']
]



def sha256(url) {
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
			def url = "https://download.java.net/java/GA/jdk${major}/${build}/GPL/openjdk-${version}_${pkg}"
			def checksum = new URL("${url}.sha256").text.trim()

			entry(key:"jdk.${os}.${arch}.url", value: url)
			entry(key:"jdk.${os}.${arch}.sha256", value: checksum)
		}
	}

	liberica.each{ jdk ->
		jdk.with {
			def url = "https://github.com/bell-sw/Liberica/releases/download/${major}/bellsoft-jdk${major}-${pkg}"
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
