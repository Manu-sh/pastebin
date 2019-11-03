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

# source=("${_pkgname}::git+https://github.com/Manu-sh/${pkgname}.git")
source=("${_pkgname}-${pkgver}.tar.gz::https://github.com/Manu-sh/${_pkgname}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')

prepare() {
	cd "${srcdir}/${_pkgname}"
	gem install nokogiri
}

build() { :; } 
check() { :; }
package_pastebin-git() {
	cp -r "${srcdir}/${_pkgname}" "${pkgdir}"
	#echo 'PATH="${PATH}:/'${pkgdir}'/${_pkgname}/bin"' >> .bashrc
}
