# pastebin
###### send code snippet to pastebin

<a href="https://asciinema.org/a/BHRFvPUWv7rJKiysAZmMlrE2v?autoplay=1&t=00:10">
  <img src="https://asciinema.org/a/BHRFvPUWv7rJKiysAZmMlrE2v.png" width="320px" height="200px" alt="" />
</a>

### Installation
```bash
git clone https://github.com/Manu-sh/pastebin
gem install nokogiri

cp -r pastebin /opt

# edit you .bashrc and add /opt/pastebin/bin to your $PATH
PATH="${PATH}:/opt/pastebin/bin"

# then you should be able to type
pastebin -h

user@arch~> pastebin -h
pastebin usage:
	-h, --help
		this help

	-f, --format
		manually specify the format (used for syntax hight-light),
		by default pastebin shall try to recognize it based on file suffix)

                    4CS, 6502_ACME_CROSS_ASSEMBLER, 6502_KICK_ASSEMBLER, 6502_TASM64TASS, ABAP,
                    ACTIONSCRIPT, ACTIONSCRIPT_3, ADA, AIMMS, ALGOL_68, APACHE_LOG, APPLESCRIPT,
                    APT_SOURCES, ARDUINO, ARM, ASM_NASM, ASP, ASYMPTOTE, AUTOCONF, AUTOHOTKEY,
                    AUTOIT, AVISYNTH, AWK, BASCOM_AVR, BASH, BASIC4GL, BATCH, BIBTEX, BLITZ3D,
                    BLITZMAX, BLITZ_BASIC, BNF, BOO, BRAINFUCK, C, C++, C++_WINAPI,
                    C++_WITH_QT_EXTENSIONS, CAD_DCL, CAD_LISP, CEYLON, CFDG, CHAISCRIPT, CHAPEL,
                    CLOJURE, CLONE_C, CLONE_C++, CMAKE, COBOL, COFFEESCRIPT, COLDFUSION, CSS,
                    CUESHEET, C_FOR_MACS, C_INTERMEDIATE_LANGUAGE, C_LOADRUNNER, C_SHARP,
                    C_WINAPI, D, DART, DCL, DCPU16, DCS, DELPHI, DELPHI_PRISM_OXYGENE, DIFF, DIV,
                    DOT, E, EASYTRIEVE, ECMASCRIPT, EIFFEL, EMAIL, EPC, ERLANG, EUPHORIA, FALCON,
                    FILEMAKER, FORMULA_ONE, FORTRAN, FO_LANGUAGE, FREEBASIC, FREESWITCH, F_SHARP,
                    GAMBAS, GAME_MAKER, GDB, GENERO, GENIE, GETTEXT, GO, GROOVY, GWBASIC, HASKELL,
                    HAXE, HICEST, HQ9_PLUS, HTML, HTML_5, ICON, IDL, INI_FILE, INNO_SCRIPT,
                    INTERCAL, IO, ISPF_PANEL_DEFINITION, J, JAVA, JAVASCRIPT, JAVA_5, JCL, JQUERY,
                    JSON, JULIA, KIXTART, KOTLIN, LATEX, LDIF, LIBERTY_BASIC, LINDEN_SCRIPTING,
                    LISP, LLVM, LOCO_BASIC, LOGTALK, LOL_CODE, LOTUS_FORMULAS, LOTUS_SCRIPT,
                    LSCRIPT, LUA, M68000_ASSEMBLER, MAGIKSF, MAKE, MAPBASIC, MATLAB, MIRC,
                    MIX_ASSEMBLER, MODULA_2, MODULA_3, MOTOROLA_68000_HISOFT_DEV, MPASM, MXML,
                    MYSQL, NAGIOS, NETREXX, NEWLISP, NGINX, NIM, NONE, NULLSOFT_INSTALLER,
                    OBERON_2, OBJECK_PROGRAMMING_LANGUA, OBJECTIVE_C, OCALM_BRIEF, OCAML, OCTAVE,
                    OPENBSD_PACKET_FILTER, OPENGL_SHADING, OPENOFFICE_BASIC, OPEN_OBJECT_REXX,
                    ORACLE_11, ORACLE_8, OZ, PARASAIL, PARIGP, PASCAL, PAWN, PCRE, PER, PERL,
                    PERL_6, PHP, PHP_BRIEF, PIC_16, PIKE, PIXEL_BENDER, PLI, PLSQL, POSTGRESQL,
                    POSTSCRIPT, POVRAY, POWERBUILDER, POWERSHELL, PROFTPD, PROGRESS, PROLOG,
                    PROPERTIES, PROVIDEX, PUPPET, PUREBASIC, PYCON, PYTHON, PYTHON_FOR_S60,
                    QBASIC, QKDB+, QML, R, RACKET, RAILS, RBSCRIPT, REBOL, REG, REXX, ROBOTS,
                    RPM_SPEC, RUBY, RUBY_GNUPLOT, RUST, SAS, SCALA, SCHEME, SCILAB, SCL, SDLBASIC,
                    SMALLTALK, SMARTY, SPARK, SPARQL, SQF, SQL, STANDARDML, STONESCRIPT,
                    SUPERCOLLIDER, SWIFT, SYSTEMVERILOG, TCL, TERA_TERM, THINBASIC, TSQL,
                    TYPOSCRIPT, UNICON, UNREALSCRIPT, UPC, URBI, VALA, VBNET, VBSCRIPT, VEDIT,
                    VERILOG, VHDL, VIM, VISUALBASIC, VISUALFOXPRO, VISUAL_PRO_LOG, WHITESPACE,
                    WHOIS, WINBATCH, XBASIC, XML, XORG_CONFIG, XPP, YAML, Z80_ASSEMBLER, ZXBASIC

	-e, --expiration
		paste expiration, default is 10 minutes

                    10_MINUTES, 1_DAY, 1_HOUR, 1_MONTH, 1_WEEK, 1_YEAR, 2_WEEKS, 6_MONTHS, NEVER

	-v, --visibility
		paste exposure, default is public

                    PRIVATE_MEMBERS_ONLY, PUBLIC, UNLISTED

	examples:
		pastebin ~/file.cpp
		pastebin -f c++ ~/file
		pastebin -e 1_day -v unlisted -f bash ~/.bashrc

	see also: https://pastebin.com/faq

```

Note that you could also read from stdin, maybe define an alias still more convenient
```bash
lsblk|pastebin /dev/stdin
```

### Troubleshooting
If somethings doesn't work as expected try to remove `/tmp/pastebin_opt.rb` this file contain a list of available opt and it's automatically generated by parsing the html _DOM_ of pastebin.com

```bash
rm /tmp/pastebin_opt.rb
```

###### Copyright © 2018, [Manu-sh](https://github.com/Manu-sh), s3gmentationfault@gmail.com. Released under the [GPL3 license](LICENSE).
