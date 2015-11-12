def binaries = [
	armv7l: 'linux-arm32-vfp-hflt', 
	armv8:  'linux-arm64-vfp-hflt', 
	i686:   'linux-i586', 
	x86_64: 'linux-x64'
]

def ver = properties['jdk.version']
def dig = new URL("https://www.oracle.com/webfolder/s/digest/${ver}checksum.html").readLines()

ant.propertyfile(file: 'checksum.properties', comment: "Checksum for Java SE ${ver} binaries") {
	binaries.each{ arch, pkg ->
		def filename = "jdk-${ver}-${pkg}.tar.gz"
		def checksum = dig.grep{ it =~ filename }.findResult{ it.find(/sha256: (\p{XDigit}{64})/ ){ match, checksum -> checksum.toLowerCase() } }

		entry(key:"jdk.${arch}", value: pkg)
		entry(key:"jdk.${arch}.tar.gz", value: filename)
		entry(key:"jdk.${arch}.sha256", value: checksum)
	}
}
