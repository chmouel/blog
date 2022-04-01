alll: generate

generate:
	@hugo --gc --minify

dev:
	@hugo server -D

theme-update:
	@git submodule update --remote --merge

theme-checkout:
	@git submodule update --init --recursive
