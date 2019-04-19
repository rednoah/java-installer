// parse version/update/build from release string
def name    = properties.product
def version = properties.release


// OpenJDK for x64 Windows / Linux / Mac
def openjdk = [
	[os: 'windows', arch: 'x64', pkg: 'windows-x64_bin.zip'],
	[os: 'mac',     arch: 'x64', pkg: 'osx-x64_bin.tar.gz'],
	[os: 'linux',   arch: 'x64', pkg: 'linux-x64_bin.tar.gz']
]


// BellSoft Liberica JDK Linux ARM
def liberica = [
	[os: 'windows', arch: 'x86',     pkg: 'windows-i586-lite.zip'],
	[os: 'linux',   arch: 'x86',     pkg: 'linux-i586-lite.tar.gz'],
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
	try {
		return new URL("${url}.sha256").text.tokenize().first()
	} catch(e) {
		def file = new File('cache', url.tokenize('/').last())
		new AntBuilder().get(src: url, dest: file, skipExisting: 'yes')
		return file.bytes.digest('SHA-256').padLeft(64, '0')
	}
}


def getOpenJDK(pkg) {
	return "https://download.java.net/java/GA/jdk${properties.ojdk_version}/${properties.ojdk_uuid}/${properties.ojdk_major}/GPL/openjdk-${properties.ojdk_version}_${pkg}"
}


// generate properties file
ant.propertyfile(file: 'build-jdk.properties', comment: "${name} ${version} binaries") {
	entry(key: 'jdk.name', value: name)
	entry(key: 'jdk.version', value: version)

	openjdk.each{ jdk ->
		jdk.with {
			def url = getOpenJDK(pkg)
			def checksum = sha256(url)

			entry(key:"jdk.${os}.${arch}.url", value: url)
			entry(key:"jdk.${os}.${arch}.sha256", value: checksum)
		}
	}

	liberica.each{ jdk ->
		jdk.with {
			def url = "https://github.com/bell-sw/Liberica/releases/download/${version}/bellsoft-jdk${version}-${pkg}"
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
