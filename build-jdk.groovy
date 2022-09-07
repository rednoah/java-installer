// Eclipse Adoptium OpenJDK for all platforms
def adoptium = [
	[os: 'windows', arch: 'x64'],
	[os: 'windows', arch: 'x32'],
	[os: 'mac',     arch: 'x64'],
	[os: 'mac',     arch: 'aarch64'],
	[os: 'linux',   arch: 'x64'],
	[os: 'linux',   arch: 'arm'],
	[os: 'linux',   arch: 'aarch64'],
	[os: 'linux',   arch: 'ppc64le']
]

// BellSoft Liberica JDK for embedded devices
def liberica = [
	[type: 'jdk', os: 'linux',   arch: 'x86',     pkg: 'linux-i586.tar.gz']
]

// Gluon OpenJFX
def javafx = [
	[os: 'windows', arch: 'x64',     pkg: 'windows-x64_bin-jmods.zip'],
	[os: 'mac',     arch: 'x64',     pkg: 'osx-x64_bin-jmods.zip'],
	[os: 'mac',     arch: 'aarch64', pkg: 'osx-aarch64_bin-jmods.zip'],
	[os: 'linux',   arch: 'x64',     pkg: 'linux-x64_bin-jmods.zip'],
	[os: 'linux',   arch: 'aarch64', pkg: 'linux-aarch64_bin-jmods.zip']
]


// General Build Properties
def name = properties.product
def version = properties.release


// generate properties file
ant.propertyfile(file: 'build-jdk.properties', comment: "${name} ${version} binaries") {
	entry(key: 'jdk.name', value: name)
	entry(key: 'jdk.version', value: version)

	// Eclipse Adoptium Assets
	def assets = new groovy.json.JsonSlurper().parse(new URL("https://api.adoptium.net/v3/assets/version/${properties.adoptium_release}"))

	adoptium.each{ jdk ->
		jdk.with {
			def pkg = assets[0].binaries.find{ a -> os == a.os && arch == a.architecture && 'jdk' == a.image_type }
			if (pkg) {
				println pkg.package.link
				entry(key:"jdk.${os}.${arch}.url", value: pkg.package.link)
				entry(key:"jdk.${os}.${arch}.sha256", value: pkg.package.checksum)
			} else {
				println "$jdk not found"
			}
		}
	}

	liberica.each{ jdk ->
		def build = properties.liberica_release
		def cache = properties.'dir.cache'

		jdk.with {
			def url = "https://download.bell-sw.com/java/${build}/bellsoft-${type}${build}-${pkg}"
			println url

			def file = new File(cache, url.tokenize('/').last())
			new AntBuilder().get(src: url, dest: file, skipExisting: 'yes')
			def checksum = file.bytes.digest('SHA-256').padLeft(64, '0')

			entry(key:"${type}.${os}.${arch}.url", value: url)
			entry(key:"${type}.${os}.${arch}.sha256", value: checksum)
		}
	}

	javafx.each{ jfx ->
		def release = properties.openjfx_release
		jfx.with {
			def url = "https://download2.gluonhq.com/openjfx/${release}/openjfx-${release}_${pkg}"
			def checksum = new URL("${url}.sha256").text.tokenize().first()
			println url

			entry(key:"jfx.${os}.${arch}.url", value: url)
			entry(key:"jfx.${os}.${arch}.sha256", value: checksum)
		}
	}
}
