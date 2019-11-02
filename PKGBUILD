_pkgname='pastebin'
pkgname="${_pkgname}-git"
pkgver='1.0'
pkgrel='1'
pkgdir='/opt'
pkgdesc='pastebin.rb utilty'

arch=('any')
license=('GPL3')

makedepends=('git')
depends=('ruby>=2.5.0' 'rubygems>=2.7.7')

source=("${_pkgname}::git+https://github.com/Manu-sh/${pkgname}.git")
sha256sums=('SKIP')

prepare() {
	cd "${srcdir}/${_pkgname}"
	gem install nokogiri
}

build() { :; } 
check() { :; }
package_pastebin() {
	cp -r "${srcdir}/${_pkgname}" "${pkgdir}"
	#echo 'PATH="${PATH}:/'${pkgdir}'/${_pkgname}/bin"' >> .bashrc
}
