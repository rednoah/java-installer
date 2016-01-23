def version  = '8u71'
def build    = 'b15'

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
		def url = "http://download.oracle.com/otn-pub/java/jdk/${version}-${build}/${filename}"
		def checksum = digest.grep{ it =~ filename }.findResult{ it.find(/sha256: (\p{XDigit}{64})/ ){ match, checksum -> checksum.toLowerCase() } }

		entry(key:"jdk.${arch}.url", value: url)
		entry(key:"jdk.${arch}.sha256", value: checksum)
	}
}
