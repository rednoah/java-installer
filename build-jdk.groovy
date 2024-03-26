// Eclipse Adoptium OpenJDK for all platforms
def adoptium = [
	[os: 'windows', arch: 'x64'],
	[os: 'mac',     arch: 'x64'],
	[os: 'mac',     arch: 'aarch64'],
	[os: 'linux',   arch: 'x64'],
	[os: 'linux',   arch: 'aarch64'],
	[os: 'linux',   arch: 'ppc64le'],
	[os: 'linux',   arch: 'riscv64']
]

// BellSoft Liberica JDK for embedded devices
def liberica = [
	[type: 'jdk', os: 'linux',   arch: 'x86',     pkg: 'linux-i586.tar.gz'],
	[type: 'jdk', os: 'linux',   arch: 'arm',     pkg: 'linux-arm32-vfp-hflt.tar.gz'],
	[type: 'jdk', os: 'windows', arch: 'x32',     pkg: 'windows-i586.zip'],
	[type: 'jdk', os: 'windows', arch: 'aarch64', pkg: 'windows-aarch64.zip']
]

// Gluon OpenJFX
def javafx = [
	[os: 'windows', arch: 'x64',     pkg: 'windows-x64_bin-jmods.zip'],
	[os: 'linux',   arch: 'x64',     pkg: 'linux-x64_bin-jmods.zip'],
	[os: 'mac',     arch: 'x64',     pkg: 'osx-x64_bin-jmods.zip'],
	[os: 'mac',     arch: 'aarch64', pkg: 'osx-aarch64_bin-jmods.zip']
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
