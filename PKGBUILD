_pkgname='pastebin'
pkgname="${_pkgname}-git"
pkgver=1.0
pkgrel=1
url='https://github.com/Manu-sh/pastebin'

pkgdesc='unofficial pastebin client written in ruby'

arch=('any')
license=('GPL3')

makedepends=('git')
depends=('ruby>=2.5.0' 'rubygems>=2.7.7')

# source=("${_pkgname}::git+https://github.com/Manu-sh/${pkgname}.git")
source=("${_pkgname}-${pkgver}.tar.gz::https://github.com/Manu-sh/${_pkgname}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')

prepare() {
	cd "${srcdir}/${_pkgname}-${pkgver}"
	#gem install nokogiri
}

build() { :; } 
check() { :; }
package() {
	#sudo cp -r "${srcdir}/${_pkgname}-${pkgver}" "${pkgdir}${_pkgdir}";
	#echo sudo cp -r "${_pkgname}-${pkgver}" "${pkgdir}${_pkgdir}";
	#sudo cp -r pastebin-1.0 /home/user/pastebin/pkg/pastebin-git/opt
	#sudo cp -r "${_pkgname}-${pkgver}" "/opt";
	#sudo ln -sf "${_pkgdir}/${_pkgname}-${pkgver}/bin/pastebin" "/usr/bin" 
	#ls -al .

	sudo cp -r "${srcdir}/${_pkgname}-${pkgver}" "${pkgdir}/usr"
}

#post_install() { sudo ln -sf "${_pkgdir}/${_pkgname}-${pkgver}/bin/pastebin" "/usr/bin" }
#post_remove() { sudo rm -f "/usr/bin/pastebin" }
