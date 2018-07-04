import groovy.xml.*


def f = 'qnap-repo.xml' as File


f.withWriter('UTF-8') { writer ->
	def xml = new MarkupBuilder(writer)

	xml.mkp.xmlDeclaration(version: "1.0", encoding: "utf-8")
	xml.plugins {
		item {
			cachechk(System.currentTimeMillis())
			name(properties.title)
			internalName(properties.package)
			category('Essentials')
			type('Developer Tools')
			icon80('https://raw.githubusercontent.com/rednoah/java-installer/master/package/qnap/icons/oracle-java_80.gif')
			description("${properties.title} will help you install ${properties.product} on your QNAP NAS. Supported platforms include armv7l, armv8, i686 and x86_64 models. During the install, this package will download the latest ${properties.product} Development Kit (180 MB) for your platform. This may take a while.")
			fwVersion('4.2.1')
			version(properties.'jdk.version')
			['TS-269H', 'TS-NASARM', 'TS-NASX86', 'TS-X28', 'TS-X31', 'TS-X31U', 'TS-X41', 'TS-ARM-X09', 'TS-ARM-X19'].each{ id ->
				platform{
					platformID(id)
					location("https://get.filebot.net/qnap/${properties.package}-${properties.'jdk.version'}.qpkg")
				}
			}
			maintainer('rednoah')
			forumLink('https://github.com/rednoah/java-installer')
		}
	}
}
