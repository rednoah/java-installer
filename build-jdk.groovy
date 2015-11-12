def version  = '8u65'
def build    = 'b17'

def binaries = [
	armv7l: 'linux-arm32-vfp-hflt',
	armv8:  'linux-arm64-vfp-hflt',
	i686:   'linux-i586',
	x86_64: 'linux-x64'
]

// grep SHA-256 checksums from Oracle
def digest = new URL("https://www.oracle.com/webfolder/s/digest/${version}checksum.html").readLines()

// generate properties file
ant.propertyfile(file: 'build-jdk.properties', comment: "Java SE ${version} binaries") {
	binaries.each{ arch, pkg ->
		def filename = "jdk-${version}-${pkg}.tar.gz"
		def checksum = digest.grep{ it =~ filename }.findResult{ it.find(/sha256: (\p{XDigit}{64})/ ){ match, checksum -> checksum.toLowerCase() } }

		entry(key:"jdk.${arch}", value: pkg)
		entry(key:"jdk.${arch}.version", value: version)
		entry(key:"jdk.${arch}.build", value: build)
		entry(key:"jdk.${arch}.tar.gz", value: filename)
		entry(key:"jdk.${arch}.sha256", value: checksum)
	}
}
