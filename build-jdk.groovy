def platforms = [
	jdk: [
		linux: [
			arm32: 'arm32-vfp-hflt',
			arm64: 'arm64-vfp-hflt',
			x86: 'i586',
			x64: 'x64'
		]
	],
	jre: [
		windows: [
			x86: 'i586',
			x64: 'x64'
		],
		macosx: [
			x64: 'x64'
		]
	]
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

	platforms.each{ type, o ->
		o.each{ os, m ->
			m.each{ arch, pkg ->
				def filename = "${type}-${update}-${os}-${pkg}.tar.gz"
				def url = "http://download.oracle.com/otn-pub/java/jdk/${update}-${build}/${filename}"
				def checksum = digest.grep{ it.contains(">${filename}<") }.findResult{ it.find(/sha256: (\p{XDigit}{64})/ ){ match, checksum -> checksum.toLowerCase() } }

				entry(key:"${type}.${os}.${arch}.url", value: url)
				entry(key:"${type}.${os}.${arch}.sha256", value: checksum)
			}
		}
	}
}
