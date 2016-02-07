def binaries = [
	armv7l: 'linux-arm32-vfp-hflt',
	armv8:  'linux-arm64-vfp-hflt',
	i686:   'linux-i586',
	x86_64: 'linux-x64'
]

// parse version/update/build from release string
def name    = properties.product
def release = properties.release =~ /(?<version>\d.(?<major>\d).\d_(?<update>\d+))-(?<build>b\d+)/
def version = release[0][1]
def update  = release[0][2..3].join('u')
def build   = release[0][4]

// grep SHA-256 checksums from Oracle
def digest = new URL("https://www.oracle.com/webfolder/s/digest/${update}checksum.html").readLines()

// generate properties file
ant.propertyfile(file: 'build-jdk.properties', comment: "${name} ${update} binaries") {
	entry(key:"jdk.name", value: name)
	entry(key:"jdk.version", value: version)

	binaries.each{ arch, pkg ->
		def filename = "jdk-${update}-${pkg}.tar.gz"
		def url = "http://download.oracle.com/otn-pub/java/jdk/${update}-${build}/${filename}"
		def checksum = digest.grep{ it =~ filename }.findResult{ it.find(/sha256: (\p{XDigit}{64})/ ){ match, checksum -> checksum.toLowerCase() } }

		entry(key:"jdk.${arch}.url", value: url)
		entry(key:"jdk.${arch}.sha256", value: checksum)
	}
}
